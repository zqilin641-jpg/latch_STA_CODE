param(
    [switch]$Gui,
    [string]$ModelsimDir = 'E:\real-modelsim\win64',
    [string]$PdsDir = 'C:\pango design suite\PDS_2022.2-SP6.4'
)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$build = Join-Path $root 'build\modelsim_concept'
New-Item -ItemType Directory -Force -Path $build | Out-Null
$vendor = Join-Path $PdsDir 'arch\vendor\pango\verilog\simulation'
$sources = @(
    (Join-Path $vendor 'GTP_GRS.v'), (Join-Path $vendor 'GTP_DLATCH_C.v'),
    (Join-Path $root '..\single_latch\rtl\datapath_compare.v'),
    (Join-Path $root 'sim\tb_borrow_concept.v')
)
foreach ($path in $sources) {
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing source: $path" }
}
$oldGui = $env:LATCH_BORROW_SIM_GUI
$env:LATCH_BORROW_SIM_GUI = if ($Gui) { '1' } else { '0' }
Push-Location -LiteralPath $build
try {
    if (-not (Test-Path -LiteralPath 'modelsim.ini')) {
        & (Join-Path $ModelsimDir 'vmap.exe') -c
        if ($LASTEXITCODE -ne 0) { throw 'vmap failed' }
    }
    if (-not (Test-Path -LiteralPath 'work')) {
        & (Join-Path $ModelsimDir 'vlib.exe') work
        if ($LASTEXITCODE -ne 0) { throw 'vlib failed' }
    }
    & (Join-Path $ModelsimDir 'vlog.exe') -sv -work work @sources
    if ($LASTEXITCODE -ne 0) { throw 'vlog failed' }
    if (Test-Path -LiteralPath 'result.txt') { Remove-Item -LiteralPath 'result.txt' }
    $do = (Join-Path $root 'sim\run_concept.do').Replace('\', '/')
    $arguments = if ($Gui) { @('-l', 'transcript.log') } else { @('-c', '-l', 'transcript.log') }
    & (Join-Path $ModelsimDir 'vsim.exe') @arguments -do "do {$do}"
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath 'result.txt')) { throw 'Concept simulation failed' }
    Get-Content -LiteralPath 'result.txt'
} finally {
    Pop-Location
    $env:LATCH_BORROW_SIM_GUI = $oldGui
}
