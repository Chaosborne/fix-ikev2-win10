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
echo === TEST 5: Restart Network Adapters ===
echo ========================================
echo.

echo Restarting network adapters...

:: Get active Ethernet adapter name
for /f "tokens=1,2 delims=:" %%a in ('netsh interface show interface ^| find "Enabled" ^| find "Ethernet"') do (
    set "ADAPTER_NAME=%%b"
    goto :found_adapter
)
:found_adapter

if defined ADAPTER_NAME (
    echo Restarting %ADAPTER_NAME%...
    netsh interface set interface "%ADAPTER_NAME%" admin=disable >nul 2>&1
    timeout /t 3 /nobreak >nul
    netsh interface set interface "%ADAPTER_NAME%" admin=enable >nul 2>&1
    echo ✓ Network adapter restarted
) else (
    echo ⚠ Ethernet adapter not found
)

echo.
echo Now try to connect to VPN through Windows tray
echo.
pause