$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$culture = [Globalization.CultureInfo]::InvariantCulture
$rows = @()
$macroBanks = @{}
$patterns = @{
    ff = @{
        input_to_first = @('^u_boundary/core_input\[', '^u_core/stage_one\[')
        first_to_second = @('^u_core/stage_one\[', '^u_core/result\[')
        second_to_output = @('^u_core/result\[', '^u_boundary/result\[')
    }
    latch = @{
        input_to_first = @('^u_boundary/core_input\[', '^u_core/bits\[\d+\]\.u_stage_one/')
        first_to_second = @('^u_core/bits\[\d+\]\.u_stage_one/', '^u_core/bits\[\d+\]\.u_stage_two/')
        second_to_output = @('^u_core/bits\[\d+\]\.u_stage_two/', '^u_boundary/result\[')
    }
}

foreach ($variant in @('ff', 'latch')) {
    $design = $variant + '_timing_top'
    $path = Join-Path $root ('build\' + $variant + '\report_timing\' + $design + '.rtr')
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing report: $path" }
    $text = Get-Content -LiteralPath $path -Raw
    $mappedPath = Join-Path $root ('build\' + $variant + '\generate_netlist\' + $design + '_sim.v')
    $mapped = Get-Content -LiteralPath $mappedPath -Raw
    $macroBanks[$variant] = @{}
    $bankPatterns = @{
        source = '^u_boundary/core_input\['
        sink = '^u_boundary/result\['
        first = if ($variant -eq 'ff') { '^u_core/stage_one\[' } else { '^u_core/bits\[\d+\]\.u_stage_one/' }
        second = if ($variant -eq 'ff') { '^u_core/result\[' } else { '^u_core/bits\[\d+\]\.u_stage_two/' }
    }
    $storage = [regex]::Matches($mapped, '\bV_(?:FF\w*|LAASYN)\s+/\*\s+([^\s]+)\s+\*/')
    foreach ($bank in @('source', 'first', 'second', 'sink')) {
        $cells = @($storage | Where-Object { $_.Groups[1].Value -match $bankPatterns[$bank] })
        if ($cells.Count -ne 8) { throw "Expected eight storage cells: $variant/$bank has $($cells.Count)." }
        $macroBanks[$variant][$bank] = @($cells | ForEach-Object {
            $match = [regex]::Match($_.Groups[1].Value, '^(.*?/opit_\d+[^/]*)/')
            if (-not $match.Success) { throw 'Unsupported storage-macro name.' }
            $match.Groups[1].Value
        } | Sort-Object -Unique)
    }
    $blocks = [regex]::Matches($text, '(?ms)^Startpoint\s+:.*?(?=^Startpoint\s+:|\z)')
    $selected = @{}
    foreach ($group in @('input_to_first', 'first_to_second', 'second_to_output')) {
        $selected[$group] = [Collections.Generic.List[string]]::new()
    }
    foreach ($block in $blocks) {
        $start = [regex]::Match($block.Value, '(?m)^Startpoint\s+:\s*(.+)\r?$').Groups[1].Value.Trim()
        $end = [regex]::Match($block.Value, '(?m)^Endpoint\s+:\s*(.+)\r?$').Groups[1].Value.Trim()
        $group = $null
        foreach ($candidate in @('input_to_first', 'first_to_second', 'second_to_output')) {
            $pair = $patterns[$variant][$candidate]
            if ($start -match $pair[0] -and $end -match $pair[1]) { $group = $candidate; break }
        }
        if (-not $group) { continue }
        $type = [regex]::Match($block.Value, 'Path Type\s+:\s*(max|min) \((slow|fast) corner\)')
        $slack = [regex]::Match($block.Value, '(?m)^ Slack \((?:MET|VIOLATED)\)\s+(-?\d+\.\d+)')
        $delay = [regex]::Match($block.Value, 'Logic:\s*(\d+\.\d+)ns\([^\r\n]*Route:\s*(\d+\.\d+)ns')
        if (-not $type.Success -or -not $slack.Success -or -not $delay.Success) {
            throw "Unsupported detailed-path format: $variant/$group"
        }
        $check = if ($type.Groups[1].Value -eq 'max') { 'setup' } else { 'hold' }
        $logic = [double]::Parse($delay.Groups[1].Value, $culture)
        $route = [double]::Parse($delay.Groups[2].Value, $culture)
        $borrow = [regex]::Match($block.Value, '(?m)^\s*Time borrow\s*:\s*(-?\d+\.\d+)')
        $maximumBorrow = [regex]::Match($block.Value, '(?m)^\s*Max time borrow\s*:\s*(-?\d+\.\d+)')
        $rows += [pscustomobject][ordered]@{
            Variant=$variant; Group=$group; Check=$check; Corner=$type.Groups[2].Value
            SlackNs=[double]::Parse($slack.Groups[1].Value, $culture)
            LogicNs=$logic; RouteNs=$route; DataPathNs=[Math]::Round($logic + $route, 3)
            TimeBorrowNs=if ($borrow.Success) { [double]::Parse($borrow.Groups[1].Value, $culture) } else { $null }
            MaxTimeBorrowNs=if ($maximumBorrow.Success) { [double]::Parse($maximumBorrow.Groups[1].Value, $culture) } else { $null }
            Startpoint=$start; Endpoint=$end
            StartMacro=[regex]::Match($start, '^(.*?/opit_\d+[^/]*)/').Groups[1].Value
            EndMacro=[regex]::Match($end, '^(.*?/opit_\d+[^/]*)/').Groups[1].Value
        }
        $selected[$group].Add($block.Value)
    }
    foreach ($group in @('input_to_first', 'first_to_second', 'second_to_output')) {
        foreach ($check in @('setup', 'hold')) {
            foreach ($corner in @('slow', 'fast')) {
                $subset = @($rows | Where-Object {
                    $_.Variant -eq $variant -and $_.Group -eq $group -and
                    $_.Check -eq $check -and $_.Corner -eq $corner
                })
                $destinationBank = switch ($group) {
                    input_to_first { 'first' }
                    first_to_second { 'second' }
                    second_to_output { 'sink' }
                }
                $endpoints = @($subset.EndMacro | Sort-Object -Unique)
                $expected = $macroBanks[$variant][$destinationBank]
                $missing = @($expected | Where-Object { $_ -notin $endpoints })
                $extra = @($endpoints | Where-Object { $_ -notin $expected })
                if ($missing.Count -ne 0 -or $extra.Count -ne 0) {
                    throw "Incomplete mapped-macro coverage: $variant/$group/$check/$corner; missing=$($missing -join ','); extra=$($extra -join ',')."
                }
            }
        }
    }
    $reportDir = Join-Path $root ('build\' + $variant + '\core_reports')
    New-Item -ItemType Directory -Force -Path $reportDir | Out-Null
    Copy-Item -LiteralPath $path -Destination (Join-Path $reportDir 'all_paths.rtr') -Force
    foreach ($group in @('input_to_first', 'first_to_second', 'second_to_output')) {
        $content = "Extracted detailed paths: $variant/$group`r`nSource: $path`r`nNo Fmax inferred; see the original report for clock definitions.`r`n`r`n" +
            ($selected[$group] -join "`r`n")
        [IO.File]::WriteAllText((Join-Path $reportDir ($group + '.txt')), $content)
    }
}

$outputDir = Join-Path $root 'build\comparison'
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
$rows | Export-Csv -LiteralPath (Join-Path $outputDir 'core_paths.csv') -NoTypeInformation -Encoding UTF8
$lines = [Collections.Generic.List[string]]::new()
$lines.Add('# Independent Core Timing Comparison')
$lines.Add('')
$lines.Add('Transaction period: 640 ns. Related ideal latch inputs: A=[40,200), B=[320,480) ns.')
$lines.Add('These are PDS reports, not measured Fmax. Clock and IO uncertainty/delays are assumptions.')
$lines.Add('Each storage bank contains eight cells. Every destination macro group has setup/hold paths at both corners.')
$lines.Add('Packed add/FF macros can expose several timing pins for several storage bits; path count is not bit count.')
$lines.Add('Data-path delay below is logic plus routing; clock delay and setup requirements are not included.')
$lines.Add('Packed-macro endpoints can also absorb combinational delay into the endpoint timing requirement.')
$lines.Add('')
$lines.Add('| Variant | Group | Worst slow setup slack (ns) | Worst fast hold slack (ns) | Largest slow setup data-path delay (ns) |')
$lines.Add('| --- | --- | ---: | ---: | ---: |')
foreach ($variant in @('ff', 'latch')) {
    foreach ($group in @('input_to_first', 'first_to_second', 'second_to_output')) {
        $slow = @($rows | Where-Object { $_.Variant -eq $variant -and $_.Group -eq $group -and $_.Check -eq 'setup' -and $_.Corner -eq 'slow' })
        $fast = @($rows | Where-Object { $_.Variant -eq $variant -and $_.Group -eq $group -and $_.Check -eq 'hold' -and $_.Corner -eq 'fast' })
        $setup = ($slow | Measure-Object SlackNs -Minimum).Minimum
        $hold = ($fast | Measure-Object SlackNs -Minimum).Minimum
        $delay = ($slow | Measure-Object DataPathNs -Maximum).Maximum
        $lines.Add([string]::Format($culture, '| {0} | {1} | {2:F3} | {3:F3} | {4:F3} |', $variant, $group, $setup, $hold, $delay))
    }
}
$lines.Add('')
$lines.Add('Do not rank Fmax by these slacks: capture edges and latency contracts differ.')
$lines.Add('The complete Performance Summary also contains IO paths and is not a core-only Fmax result.')
$borrowing = @($rows | Where-Object { $_.Variant -eq 'latch' -and $null -ne $_.TimeBorrowNs })
if ($borrowing.Count -gt 0) {
    $largestBorrow = ($borrowing | Measure-Object TimeBorrowNs -Maximum).Maximum
    $lines.Add([string]::Format($culture, 'Largest reported actual latch time borrowing in selected paths: {0:F3} ns.', $largestBorrow))
}
$lines.Add('No clock generator, board pins, SDF run, physical frequency sweep, Howard or LP prediction is provided here.')
[IO.File]::WriteAllText((Join-Path $outputDir 'comparison.md'), ($lines -join "`r`n"))
Write-Host "Exported $($rows.Count) core timing paths: $outputDir"
