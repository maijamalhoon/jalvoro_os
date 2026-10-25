# Jalvoro OS Windows host preparation
# Run in an elevated PowerShell terminal. This requests WSL2 + Ubuntu; Windows may require a reboot.
$ErrorActionPreference = "Stop"

Write-Host "Jalvoro OS: Windows host preparation" -ForegroundColor Cyan
Write-Host "For predictable AOSP builds, native Ubuntu Linux is preferred."
Write-Host "This script installs WSL2 and Ubuntu 22.04 only; it does not download AOSP source or build Android."
Write-Host "You may need to reboot and create a Linux username/password on first Ubuntu launch."
$answer = Read-Host "Continue with WSL2 + Ubuntu installation? Type YES"
if ($answer -cne "YES") {
    Write-Host "Cancelled. No changes requested."
    exit 0
}

$wsl = Get-Command wsl.exe -ErrorAction SilentlyContinue
if (-not $wsl) {
    throw "wsl.exe was not found. Update Windows and enable WSL, then retry."
}

wsl.exe --install --distribution Ubuntu-22.04
if ($LASTEXITCODE -ne 0) {
    Write-Host "WSL installation did not complete. Read the message above; Windows Update/reboot or admin rights may be required." -ForegroundColor Yellow
    exit $LASTEXITCODE
}

Write-Host ""
Write-Host "Next steps after Ubuntu opens for the first time:" -ForegroundColor Green
Write-Host "1. Complete the Ubuntu username/password setup."
Write-Host "2. In Ubuntu, clone the repository and enter it:"
Write-Host "   git clone https://github.com/maijamalhoon/jalvoro_os.git"
Write-Host "   cd jalvoro_os"
Write-Host "   git switch feature/dev-environment"
Write-Host "3. Run: bash scripts/setup-ubuntu.sh"
Write-Host "4. Keep AOSP source/build files under Linux home (e.g. ~/aosp), never /mnt/c."
