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
echo === TEST 3: Clear IPsec SA ===
echo ========================================
echo.

echo Clearing IPsec Security Associations...
powershell -Command "Get-NetIPsecMainModeSA | Remove-NetIPsecMainModeSA -Confirm:$false -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Get-NetIPsecQuickModeSA | Remove-NetIPsecQuickModeSA -Confirm:$false -ErrorAction SilentlyContinue" >nul 2>&1

echo ✓ IPsec SA cleared
echo.
echo Now try to connect to VPN through Windows tray
echo.
pause