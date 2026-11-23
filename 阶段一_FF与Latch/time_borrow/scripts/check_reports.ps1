param([string]$Root = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference = 'Stop'
$culture = [Globalization.CultureInfo]::InvariantCulture
$rows = @()
$summaries = @()

function Number([string]$Text, [string]$Pattern, [switch]$Optional) {
    $match = [regex]::Match($Text, $Pattern)
    if (-not $match.Success) {
        if ($Optional) { return $null }
        throw "Missing report field: $Pattern"
    }
    return [double]::Parse($match.Groups[1].Value, $culture)
}

foreach ($case in (Import-Csv -LiteralPath (Join-Path $Root 'cases.csv'))) {
    $name = $case.Name
    $path = Join-Path $Root "build\$name\report_timing\latch_timing_top.rtr"
    $report = Get-Content -LiteralPath $path -Raw
    $fdc = Get-Content -LiteralPath (Join-Path $Root "constraints\$name.fdc") -Raw
    $waveform = [regex]::Match($fdc, 'create_clock -name phase_a .*?-waveform \{([\d.]+) ([\d.]+)\}')
    if (-not $waveform.Success -or
        [double]::Parse($waveform.Groups[1].Value, $culture) -ne [double]$case.ARiseNs -or
        [double]::Parse($waveform.Groups[2].Value, $culture) -ne [double]$case.AFallNs) {
        throw "Constraint/manifest mismatch: $name"
    }
    $reportedWaveform = [regex]::Match($report, '(?m)^ phase_a\s+640\.0000\s+\{([\d.]+)\s+([\d.]+)\}')
    if (-not $reportedWaveform.Success -or
        [double]::Parse($reportedWaveform.Groups[1].Value, $culture) -ne [double]$case.ARiseNs -or
        [double]::Parse($reportedWaveform.Groups[2].Value, $culture) -ne [double]$case.AFallNs) {
        throw "Report/manifest waveform mismatch: $name; rebuild before checking"
    }
    $selected = @()
    $blocks = [regex]::Matches($report, '(?ms)^Startpoint\s+:.*?(?=^Startpoint\s+:|\z)')
    foreach ($block in $blocks) {
        $text = $block.Value
        $start = [regex]::Match($text, '(?m)^Startpoint\s+:\s*(.+)\r?$').Groups[1].Value.Trim()
        $end = [regex]::Match($text, '(?m)^Endpoint\s+:\s*(.+)\r?$').Groups[1].Value.Trim()
        # Borrowing changes the next path's startpoint from G to D.
        # Classify by the destination bank, not by a fixed source-pin name.
        $group = if ($end -match '^u_core/bits\[\d+\]\.u_stage_one/opit_0/D$') { 'input_to_first' }
        elseif ($end -match '^u_core/bits\[\d+\]\.u_stage_two/opit_0/D$') { 'first_to_second' }
        elseif ($start -match '^u_core/' -and $end -match '^u_boundary/result\[\d+\]/opit_0/D$') { 'second_to_output' }
        else { $null }
        if (-not $group) { continue }
        $type = [regex]::Match($text, 'Path Type\s+:\s*(max|min) \((slow|fast) corner\)')
        if (-not $type.Success) { throw "Unsupported path format: $name" }
        $row = [pscustomobject][ordered]@{
            Case=$name; Group=$group
            Check=if ($type.Groups[1].Value -eq 'max') { 'setup' } else { 'hold' }
            Corner=$type.Groups[2].Value
            SlackNs=(Number $text '(?m)^ Slack \((?:MET|VIOLATED)\)\s+(-?\d+\.\d+)')
            ArrivalNs=(Number $text '(?m)^ Data arrival time\s+(-?\d+\.\d+)')
            RequiredNs=(Number $text '(?m)^ Data required time\s+(-?\d+\.\d+)')
            BorrowNs=(Number $text '(?m)^Time borrow\s*:\s*(-?\d+\.\d+)' -Optional)
            MaxBorrowNs=(Number $text '(?m)^Max time borrow\s*:\s*(-?\d+\.\d+)' -Optional)
            SourceShiftNs=(Number $text '(?m)^\s*time given to startpoint\s+(-?\d+\.\d+)' -Optional)
            Startpoint=$start; Endpoint=$end
        }
        $rows += $row
        $selected += $row
    }
    foreach ($group in @('input_to_first', 'first_to_second', 'second_to_output')) {
        foreach ($check in @('setup', 'hold')) {
            foreach ($corner in @('slow', 'fast')) {
                $subset = @($selected | Where-Object { $_.Group -eq $group -and $_.Check -eq $check -and $_.Corner -eq $corner })
                if ($subset.Count -ne 8 -or @($subset.Endpoint | Sort-Object -Unique).Count -ne 8) {
                    throw "Expected all eight destinations: $name/$group/$check/$corner"
                }
                foreach ($row in $subset) {
                    $expectedSlack = if ($check -eq 'setup') { $row.RequiredNs - $row.ArrivalNs } else { $row.ArrivalNs - $row.RequiredNs }
                    if ([Math]::Abs($expectedSlack - $row.SlackNs) -gt 0.002) { throw 'Slack arithmetic mismatch' }
                }
            }
        }
    }
    $first = @($selected | Where-Object { $_.Group -eq 'input_to_first' -and $_.Check -eq 'setup' -and $_.Corner -eq 'slow' })
    $next = @($selected | Where-Object { $_.Group -eq 'first_to_second' -and $_.Check -eq 'setup' -and $_.Corner -eq 'slow' })
    $fast = @($selected | Where-Object { $_.Group -eq 'input_to_first' -and $_.Check -eq 'setup' -and $_.Corner -eq 'fast' })
    $maxBorrow = ($first | Measure-Object BorrowNs -Maximum).Maximum
    $minSlack = ($first | Measure-Object SlackNs -Minimum).Minimum
    $shift = ($next | Measure-Object SourceShiftNs -Maximum).Maximum
    if ($null -eq $shift) { $shift = 0 }
    switch ($case.Expected) {
        no_borrow {
            if ($maxBorrow -ne 0 -or $minSlack -le 0 -or $report -notmatch 'Design Summary : All Constraints Met\.') {
                throw 'Baseline did not provide an all-met, zero-borrow control'
            }
        }
        borrow_pass {
            if ($maxBorrow -le 0 -or $minSlack -lt -0.001 -or $shift -le 0 -or
                @($next | Where-Object { $_.Startpoint -match '/D$' }).Count -eq 0 -or
                $report -notmatch 'Design Summary : All Constraints Met\.') {
                throw 'Positive borrowing or downstream propagation was not demonstrated'
            }
            if (@($first | Where-Object { $_.BorrowNs -gt $_.MaxBorrowNs + 0.001 }).Count -ne 0) {
                throw 'Passing case exceeded the reported borrow limit'
            }
        }
        setup_fail {
            if ($minSlack -ge 0 -or @($first | Where-Object { $_.SlackNs -lt 0 }).Count -ne 8 -or
                $report -notmatch 'Design Summary : Some Constraints Violated\.') {
                throw 'Negative control did not produce all eight intended setup failures'
            }
        }
        default { throw "Unknown expected outcome: $($case.Expected)" }
    }
    $summaries += [pscustomobject][ordered]@{
        Case=$name; ARiseNs=[double]$case.ARiseNs; AFallNs=[double]$case.AFallNs
        Expected=$case.Expected; MaxSlowBorrowNs=$maxBorrow; WorstSlowSetupNs=$minSlack
        SlowFailingFirstLatchEndpoints=@($first | Where-Object { $_.SlackNs -lt 0 }).Count
        FastFailingFirstLatchEndpoints=@($fast | Where-Object { $_.SlackNs -lt 0 }).Count
        MaxNextStageSourceShiftNs=$shift; ExpectedOutcomeVerified=$true
    }
    $evidence = Join-Path $Root "build\$name\evidence"
    New-Item -ItemType Directory -Force -Path $evidence | Out-Null
    foreach ($group in @('input_to_first', 'first_to_second', 'second_to_output')) {
        $matching = @($blocks | Where-Object {
            $end = [regex]::Match($_.Value, '(?m)^Endpoint\s+:\s*(.+)\r?$').Groups[1].Value.Trim()
            ($group -eq 'input_to_first' -and $end -match '\.u_stage_one/opit_0/D$') -or
            ($group -eq 'first_to_second' -and $end -match '\.u_stage_two/opit_0/D$') -or
            ($group -eq 'second_to_output' -and $_.Value -match '^Startpoint\s+:\s*u_core/' -and $end -match '^u_boundary/result')
        })
        if ($matching.Count -ne 32) { throw "Incomplete detailed export: $name/$group has $($matching.Count) paths" }
        [IO.File]::WriteAllText((Join-Path $evidence "$group.txt"), (($matching | ForEach-Object { $_.Value }) -join "`r`n"))
    }
}
$output = Join-Path $Root 'build\comparison'
New-Item -ItemType Directory -Force -Path $output | Out-Null
$rows | Export-Csv -LiteralPath (Join-Path $output 'paths.csv') -NoTypeInformation -Encoding UTF8
$summaries | Export-Csv -LiteralPath (Join-Path $output 'summary.csv') -NoTypeInformation -Encoding UTF8
$lines = @(
    '# Time Borrowing: PDS Evidence', '',
    'Same RTL and 640 ns reference period; independently placed/routed, not the same fixed routing.',
    'B remains [320,480) ns. All clocks are related ideal external-clock assumptions.', '',
    '| Case | A window (ns) | Max slow borrow (ns) | Worst slow first-latch setup slack (ns) | Slow / fast failing first-latch endpoints | Max next-stage source shift (ns) |',
    '| --- | --- | ---: | ---: | --- | ---: |'
)
foreach ($s in $summaries) {
    $lines += [string]::Format($culture, '| {0} | [{1},{2}) | {3:F3} | {4:F3} | {5} / {6} | {7:F3} |',
        $s.Case, $s.ARiseNs, $s.AFallNs, $s.MaxSlowBorrowNs, $s.WorstSlowSetupNs,
        $s.SlowFailingFirstLatchEndpoints, $s.FastFailingFirstLatchEndpoints, $s.MaxNextStageSourceShiftNs)
}
$lines += @('',
    'All three expected outcomes were checked, including the intentionally failing setup case.',
    'A passing borrowed path may report zero setup slack after borrowing; inspect its borrow and limit fields.',
    'Next-stage source pins become D rather than G, with a positive time-given-to-startpoint adjustment.',
    'Reported borrow and source shift use tool uncertainty/early-late accounting; they need not equal simple physical lateness.',
    'The overflow 1 ns pulse is a diagnostic negative control, not a realizable-board-clock recommendation.',
    'Reference-clock Estimated Frequency can remain positive when phase_a setup fails; do not use it as whole-design Fmax.',
    'No board pins, clock generator, bitstream, SDF run, measured Fmax, Howard or LP integration is included.',
    'The separate RTL concept simulation injects input arrival times, not these PDS clock waveforms.')
[IO.File]::WriteAllText((Join-Path $output 'comparison.md'), ($lines -join "`r`n"))
Write-Host "Verified three expected PDS outcomes and $($rows.Count) core paths: $output"
