param(
    [switch]$PostRoute,
    [switch]$Gui,
    [string]$ModelsimDir = 'E:\real-modelsim\win64',
    [string]$PdsDir = 'C:\pango design suite\PDS_2022.2-SP6.4'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$suffix = if ($PostRoute) { 'modelsim_mapped' } else { 'modelsim_rtl' }
$buildDir = Join-Path $root ('build\' + $suffix)
$executables = @{}
foreach ($name in @('vlib', 'vmap', 'vlog', 'vsim')) {
    $executables[$name] = Join-Path $ModelsimDir ($name + '.exe')
    if (-not (Test-Path -LiteralPath $executables[$name])) {
        throw "Missing simulator: $($executables[$name])"
    }
}
$vendorSimulation = Join-Path $PdsDir 'arch\vendor\pango\verilog\simulation'
$sources = @((Join-Path $vendorSimulation 'GTP_GRS.v'))
if ($PostRoute) {
    $netlists = @(
        (Join-Path $root 'build\ff\generate_netlist\ff_timing_top_sim.v'),
        (Join-Path $root 'build\latch\generate_netlist\latch_timing_top_sim.v')
    )
    $types = @('INT_LUTMUX2_UDP', 'INT_LUTMUX4_UDP')
    foreach ($path in $netlists) {
        if (-not (Test-Path -LiteralPath $path)) { throw "Build both projects first: $path" }
        $text = Get-Content -LiteralPath $path -Raw
        $types += [regex]::Matches($text, '(?m)^\s+(V_\w+)\s') |
            ForEach-Object { $_.Groups[1].Value }
    }
    $vendorMapped = Join-Path $PdsDir 'arch\vendor\pango\verilog\bsim'
    foreach ($type in ($types | Sort-Object -Unique)) {
        $sources += Join-Path $vendorMapped ($type + '.v')
    }
    $sources += $netlists
} else {
    $sources += Join-Path $vendorSimulation 'GTP_DLATCH_C.v'
    $sources += Join-Path $root '..\single_latch\rtl\datapath_compare.v'
    $sources += Join-Path $root 'rtl\timing_boundaries.v'
    $sources += Join-Path $root 'rtl\ff_timing_top.v'
    $sources += Join-Path $root 'rtl\latch_timing_top.v'
}
$sources += Join-Path $root 'sim\tb_independent_timing.v'
foreach ($path in $sources) {
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing simulation source: $path" }
}
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
Push-Location -LiteralPath $buildDir
try {
    if (-not (Test-Path -LiteralPath 'modelsim.ini')) {
        & $executables['vmap'] -c
        if ($LASTEXITCODE -ne 0) { throw 'ModelSim configuration failed.' }
    }
    if (-not (Test-Path -LiteralPath 'work')) {
        & $executables['vlib'] work
        if ($LASTEXITCODE -ne 0) { throw 'ModelSim library creation failed.' }
    }
    & $executables['vlog'] -sv -work work @sources
    if ($LASTEXITCODE -ne 0) { throw 'Simulation compilation failed.' }
    $scriptName = if ($Gui) { 'run_gui.do' } else { 'run_batch.do' }
    $script = (Join-Path $root ('sim\' + $scriptName)).Replace('\', '/')
    if ($Gui) {
        & $executables['vsim'] -do "do {$script}"
    } else {
        $resultPath = Join-Path $buildDir 'result.txt'
        if (Test-Path -LiteralPath $resultPath) { Remove-Item -LiteralPath $resultPath }
        & $executables['vsim'] -c -l transcript.log -do "do {$script}"
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $resultPath)) {
            throw "Simulation failed: $buildDir"
        }
        Get-Content -LiteralPath $resultPath
    }
} finally {
    Pop-Location
}
