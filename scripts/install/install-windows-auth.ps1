# Windows Authentication Setup Script
# PowerShell version

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Windows Authentication Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will install the required" -ForegroundColor Yellow
Write-Host "msnodesqlv8 package for Windows Auth." -ForegroundColor Yellow
Write-Host ""
Write-Host "Prerequisites (must be installed first):" -ForegroundColor White
Write-Host "  - Visual C++ Redistributable" -ForegroundColor White
Write-Host "  - ODBC Driver 18 for SQL Server" -ForegroundColor White
Write-Host ""
Write-Host "See WINDOWS_AUTH_SETUP.md for details." -ForegroundColor Gray
Write-Host ""

$continue = Read-Host "Continue? (Y/N)"
if ($continue -ne "Y" -and $continue -ne "y") {
    Write-Host "Installation cancelled." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Installing msnodesqlv8..." -ForegroundColor Cyan
Write-Host ""

npm install msnodesqlv8

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

if ($LASTEXITCODE -eq 0) {
    Write-Host " SUCCESS! Package installed." -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Configure your .env file" -ForegroundColor White
    Write-Host "  2. Run: node test-connection-windows.js" -ForegroundColor White
    Write-Host "  3. If test passes, run: npm run server" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host " FAILED! Installation error." -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  1. Install Visual C++ Redistributable" -ForegroundColor White
    Write-Host "     https://aka.ms/vs/17/release/vc_redist.x64.exe" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  2. Install ODBC Driver 18 for SQL Server" -ForegroundColor White
    Write-Host "     https://go.microsoft.com/fwlink/?linkid=2249004" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  3. Try: npm install --global windows-build-tools" -ForegroundColor White
    Write-Host ""
    Write-Host "See WINDOWS_AUTH_SETUP.md for full details." -ForegroundColor Gray
    Write-Host ""
}

Read-Host "Press Enter to exit"
