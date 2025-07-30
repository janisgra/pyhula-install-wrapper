@echo off
REM PyHula Environment Setup - Simple Launcher
REM This batch file helps students run the PowerShell setup script

echo.
echo ===============================================
echo   PyHula Environment Setup for Students
echo ===============================================
echo.
echo This script will:
echo - Install Python 3.6 (if not already installed)
echo - Create a virtual environment for PyHula
echo - Install PyHula library and dependencies
echo - Create easy-to-use activation scripts
echo.

REM Check if PowerShell is available
powershell -Command "Write-Host 'PowerShell detected'" >nul 2>&1
if errorlevel 1 (
    echo ERROR: PowerShell is not available or accessible.
    echo Please ensure PowerShell is installed and try again.
    pause
    exit /b 1
)

echo Press any key to start the installation...
pause >nul

echo.
echo Starting PowerShell setup script...
echo.

REM Run the PowerShell script with execution policy bypass
powershell -ExecutionPolicy Bypass -File "%~dp0setup_pyhula_environment.ps1" -Verbose

if errorlevel 1 (
    echo.
    echo Installation failed. Please check the error messages above.
    echo You may need to:
    echo - Run as Administrator
    echo - Check your internet connection
    echo - Disable antivirus temporarily
    echo.
) else (
    echo.
    echo Installation completed successfully!
    echo.
)

echo Press any key to exit...
pause >nul
