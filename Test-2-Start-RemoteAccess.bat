@echo off
setlocal enabledelayedexpansion

:: Check admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Administrator rights required, restarting...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ========================================
echo === TEST 2: Start RemoteAccess Service ===
echo ========================================
echo.

echo Starting RemoteAccess service...
sc config RemoteAccess start= auto >nul 2>&1
sc start RemoteAccess >nul 2>&1

echo ✓ RemoteAccess started
echo.
echo Now try to connect to VPN through Windows tray
echo.
pause