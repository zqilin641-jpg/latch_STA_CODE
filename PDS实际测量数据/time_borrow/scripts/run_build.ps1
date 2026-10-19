param(
    [ValidateSet('baseline', 'borrow', 'overflow', 'all')][string]$Case = 'all',
    [string]$PdsDir = 'C:\pango design suite\PDS_2022.2-SP6.4'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$shell = Join-Path $PdsDir 'bin\pds_shell.exe'
if (-not (Test-Path -LiteralPath $shell)) { throw "Missing PDS: $shell" }
$cases = if ($Case -eq 'all') { @('baseline', 'borrow', 'overflow') } else { @($Case) }
$oldCase = $env:LATCH_BORROW_CASE
try {
    foreach ($name in $cases) {
        $build = Join-Path $root ('build\' + $name)
        New-Item -ItemType Directory -Force -Path $build | Out-Null
        $env:LATCH_BORROW_CASE = $name
        $started = (Get-Date).AddSeconds(-2)
        & $shell -file (Join-Path $root 'pds\build_case.tcl') -work_dir $build -project_name latch_timing_top
        if ($LASTEXITCODE -ne 0) { throw "PDS execution failed: $name" }
        foreach ($relative in @('report_timing\latch_timing_top.rtr', 'generate_netlist\latch_timing_top_sim.v')) {
            $path = Join-Path $build $relative
            if (-not (Test-Path -LiteralPath $path)) { throw "Missing output: $path" }
            $item = Get-Item -LiteralPath $path
            if ($item.Length -eq 0 -or $item.LastWriteTime -lt $started) { throw "Stale output: $path" }
        }
        $netlist = Get-Content -LiteralPath (Join-Path $build 'generate_netlist\latch_timing_top_sim.v') -Raw
        $latches = [regex]::Matches($netlist, '\bV_LAASYN\s+/\*').Count
        $coreFfs = [regex]::Matches($netlist, '\bV_FF\w*\s+/\* u_core/').Count
        $boundaryFfs = [regex]::Matches($netlist, '\bV_FF\w*\s+/\* u_boundary/').Count
        if ($latches -ne 16 -or $coreFfs -ne 0 -or $boundaryFfs -ne 16) {
            throw "Storage mapping changed: $name; latches=$latches; core FFs=$coreFfs; boundary FFs=$boundaryFfs"
        }
        Write-Host "Built ${name}: 16 core latches and 16 boundary FFs. No bitstream requested."
    }
} finally {
    $env:LATCH_BORROW_CASE = $oldCase
}
if ($Case -eq 'all') {
    & (Join-Path $PSScriptRoot 'check_reports.ps1')
}
