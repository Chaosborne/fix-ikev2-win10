@echo off
setlocal enabledelayedexpansion

:: Check admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Administrator rights required, restarting...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo.
echo ========================================
echo === NETWORK RECOVERY ===
echo ========================================
echo.

echo Step 1: Enabling all network adapters...
powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Disabled'} | Enable-NetAdapter" >nul 2>&1

echo Step 2: Starting network services...
net start nsi >nul 2>&1
net start netprofm >nul 2>&1
net start NlaSvc >nul 2>&1
net start Dhcp >nul 2>&1
net start Dnscache >nul 2>&1
net start IKEEXT >nul 2>&1
net start RemoteAccess >nul 2>&1
net start PolicyAgent >nul 2>&1

echo Step 3: Clearing DNS cache...
ipconfig /flushdns >nul 2>&1

echo Step 4: Renewing IP addresses...
ipconfig /renew >nul 2>&1

echo Step 5: Checking internet...
ping -n 1 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ Internet restored!
) else (
    echo ✗ Internet not working
    echo.
    echo Run "Windows Network Diagnostics":
    echo 1. Press Win + R
    echo 2. Type: ms-settings:troubleshoot
    echo 3. Select "Internet connections"
    echo 4. Click "Run the troubleshooter"
)

echo.
echo Recovery completed!
pause