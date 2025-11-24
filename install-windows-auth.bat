@echo off
echo ========================================
echo  Windows Authentication Setup
echo ========================================
echo.
echo This script will install the required
echo msnodesqlv8 package for Windows Auth.
echo.
echo Prerequisites (must be installed first):
echo  - Visual C++ Redistributable
echo  - ODBC Driver 18 for SQL Server
echo.
echo See WINDOWS_AUTH_SETUP.md for details.
echo.
pause

echo.
echo Installing msnodesqlv8...
echo.
npm install msnodesqlv8

echo.
echo ========================================
if %ERRORLEVEL% EQU 0 (
    echo  SUCCESS! Package installed.
    echo ========================================
    echo.
    echo Next steps:
    echo  1. Configure your .env file
    echo  2. Run: node test-connection-windows.js
    echo  3. If test passes, run: npm run server
    echo.
) else (
    echo  FAILED! Installation error.
    echo ========================================
    echo.
    echo Troubleshooting:
    echo  1. Install Visual C++ Redistributable
    echo     https://aka.ms/vs/17/release/vc_redist.x64.exe
    echo.
    echo  2. Install ODBC Driver 18 for SQL Server
    echo     https://go.microsoft.com/fwlink/?linkid=2249004
    echo.
    echo  3. Try: npm install --global windows-build-tools
    echo.
    echo See WINDOWS_AUTH_SETUP.md for full details.
    echo.
)

pause
