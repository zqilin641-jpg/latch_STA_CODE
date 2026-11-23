param(
    [ValidateSet('ff', 'latch', 'all')][string]$Variant = 'all',
    [string]$PdsDir = 'C:\pango design suite\PDS_2022.2-SP6.4'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$shellPath = Join-Path $PdsDir 'bin\pds_shell.exe'
if (-not (Test-Path -LiteralPath $shellPath)) { throw "Missing PDS: $shellPath" }
$variants = if ($Variant -eq 'all') { @('ff', 'latch') } else { @($Variant) }

function Assert-FreshArtifact([string]$Path, [datetime]$Started) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "Missing build output: $Path"
    }
    $item = Get-Item -LiteralPath $Path
    if ($item.Length -eq 0 -or $item.LastWriteTime -lt $Started) {
        throw "Empty or stale build output: $Path"
    }
}

foreach ($name in $variants) {
    $design = $name + '_timing_top'
    $buildDir = Join-Path $root ('build\' + $name)
    $script = Join-Path $root ('pds\' + $name + '_build.tcl')
    New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
    $started = (Get-Date).AddSeconds(-2)
    Push-Location -LiteralPath $buildDir
    try {
        & $shellPath -file $script -work_dir $buildDir -project_name $design
        if ($LASTEXITCODE -ne 0) { throw "PDS $name build failed." }
        $mapped = Join-Path $buildDir ('generate_netlist\' + $design + '_sim.v')
        $summary = Join-Path $buildDir ('place_route\' + $design + '_timing_summary_after_hold_fix.txt')
        Assert-FreshArtifact $mapped $started
        Assert-FreshArtifact $summary $started
        $netlist = Get-Content -LiteralPath $mapped -Raw
        $latches = [regex]::Matches($netlist, '\bV_LAASYN\s+/\*').Count
        $coreFfs = [regex]::Matches($netlist, '\bV_FF\w*\s+/\* u_core/').Count
        if ($name -eq 'ff' -and ($latches -ne 0 -or $coreFfs -ne 16)) {
            throw "FF mapping changed: core FFs=$coreFfs, latches=$latches."
        }
        if ($name -eq 'latch' -and ($latches -ne 16 -or $coreFfs -ne 0)) {
            throw "Latch mapping changed: core FFs=$coreFfs, latches=$latches."
        }
        $reportDir = Join-Path $buildDir 'core_reports'
        New-Item -ItemType Directory -Force -Path $reportDir | Out-Null
        $reportSource = Join-Path $buildDir ('report_timing\' + $design + '.rtr')
        Assert-FreshArtifact $reportSource $started
        Copy-Item -LiteralPath $reportSource -Destination (Join-Path $reportDir 'all_paths.rtr') -Force
        Write-Host "Independent $name project: $buildDir\$design.pds"
        Write-Host "Core mapping: $coreFfs FFs, $latches latches. Timing report: $summary"
        Write-Host 'Analysis only: no bitstream was requested.'
    } finally {
        Pop-Location
    }
}
if ($Variant -eq 'all') {
    & (Join-Path $PSScriptRoot 'export_comparison.ps1')
}
