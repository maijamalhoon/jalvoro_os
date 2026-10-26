# Jalvoro OS Windows host readiness report
# Read-only diagnostic. Run from a normal PowerShell window; no administrator rights required.
$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host " Jalvoro OS - Windows Readiness Check" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "This report only reads system information. It does not install or change anything."

$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$computer = Get-CimInstance Win32_ComputerSystem
$ramGB = [math]::Round($computer.TotalPhysicalMemory / 1GB, 1)

Write-Host "`n[Windows]"
Write-Host ("OS: {0} (version {1})" -f $os.Caption, $os.Version)
Write-Host ("Architecture: {0}" -f $os.OSArchitecture)

Write-Host "`n[CPU]"
Write-Host ("Processor: {0}" -f $cpu.Name)
Write-Host ("Cores / logical processors: {0} / {1}" -f $cpu.NumberOfCores, $cpu.NumberOfLogicalProcessors)

Write-Host "`n[Memory]"
Write-Host ("Installed RAM: {0} GB" -f $ramGB)
if ($ramGB -lt 16) {
    Write-Host "WARNING: RAM is below a comfortable level even for heavier local development." -ForegroundColor Yellow
} elseif ($ramGB -lt 32) {
    Write-Host "NOTE: Suitable for lightweight app work; full AOSP builds will be heavily constrained." -ForegroundColor Yellow
} else {
    Write-Host "RAM looks more suitable, but disk space and virtualization still need checking."
}

Write-Host "`n[Fixed drives]"
$drives = @(Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3")
foreach ($drive in $drives) {
    $totalGB = if ($drive.Size) { [math]::Round($drive.Size / 1GB, 1) } else { 0 }
    $freeGB = if ($drive.FreeSpace) { [math]::Round($drive.FreeSpace / 1GB, 1) } else { 0 }
    Write-Host ("{0}  total {1} GB | free {2} GB" -f $drive.DeviceID, $totalGB, $freeGB)
}
$maxFreeGB = 0
if ($drives.Count -gt 0) {
    $maxFreeGB = [math]::Round((($drives | Measure-Object -Property FreeSpace -Maximum).Maximum) / 1GB, 1)
}
if ($maxFreeGB -lt 400) {
    Write-Host "BLOCKER: No single fixed drive currently has 400 GiB free for the repository's guarded AOSP sync script." -ForegroundColor Red
} else {
    Write-Host "At least one fixed drive has 400 GB free; confirm filesystem and actual AOSP requirements before syncing."
}

Write-Host "`n[WSL]"
$wslCommand = Get-Command wsl.exe -ErrorAction SilentlyContinue
if (-not $wslCommand) {
    Write-Host "wsl.exe was not found."
} else {
    & wsl.exe --status
    Write-Host "`nInstalled distributions:"
    & wsl.exe --list --quiet
}

Write-Host "`n[Recommended next step]"
if ($ramGB -lt 16 -or $maxFreeGB -lt 400) {
    Write-Host "Do not start a full AOSP source sync/build on this machine yet." -ForegroundColor Yellow
    Write-Host "Continue with repository checks and lightweight Android app/source work first."
    Write-Host "For full platform builds, consider a suitable Linux workstation or remote build host."
} else {
    Write-Host "Host may be worth further checking. Verify Linux environment, free space, virtualization, and the selected AOSP target."
}
Write-Host "`nDone. This diagnostic made no system changes."
