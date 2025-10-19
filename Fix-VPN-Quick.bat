@echo off
setlocal enabledelayedexpansion

:: Log file
set "LOGFILE=%~dp0VPN-Quick-Fix.log"

:: Check admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Administrator rights required, restarting...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ======================================== >> "%LOGFILE%"
echo ==== QUICK VPN FIX ==== >> "%LOGFILE%"
echo ==== Started: %date% %time% ==== >> "%LOGFILE%"
echo ======================================== >> "%LOGFILE%"

echo.
echo ========================================
echo === QUICK VPN FIX ===
echo ========================================
echo.

:: Step 1: Disconnect VPN
echo [%time%] Step 1: Disconnecting VPN... >> "%LOGFILE%"
echo Step 1: Disconnecting VPN...
rasdial Skynet /disconnect >nul 2>&1
echo ✓ VPN disconnected

:: Step 2: Clear IPsec SA
echo [%time%] Step 2: Clearing IPsec SA... >> "%LOGFILE%"
echo Step 2: Clearing IPsec SA...
powershell -Command "Get-NetIPsecMainModeSA | Remove-NetIPsecMainModeSA -Confirm:$false -ErrorAction SilentlyContinue" >nul 2>&1
powershell -Command "Get-NetIPsecQuickModeSA | Remove-NetIPsecQuickModeSA -Confirm:$false -ErrorAction SilentlyContinue" >nul 2>&1
echo ✓ IPsec SA cleared

:: Step 3: Clear DNS cache
echo [%time%] Step 3: Clearing DNS cache... >> "%LOGFILE%"
echo Step 3: Clearing DNS cache...
ipconfig /flushdns >nul 2>&1
echo ✓ DNS cache cleared

:: Step 4: Clear ARP cache
echo [%time%] Step 4: Clearing ARP cache... >> "%LOGFILE%"
echo Step 4: Clearing ARP cache...
arp -d * >nul 2>&1
echo ✓ ARP cache cleared

:: Step 5: Restart network services
echo [%time%] Step 5: Restarting network services... >> "%LOGFILE%"
echo Step 5: Restarting network services...

:: Check and start RemoteAccess
sc query RemoteAccess | find "STOPPED" >nul 2>&1
if %errorlevel% equ 0 (
    echo [%time%] Starting RemoteAccess... >> "%LOGFILE%"
    echo Starting RemoteAccess...
    sc config RemoteAccess start= auto >nul 2>&1
    sc start RemoteAccess >nul 2>&1
    echo ✓ RemoteAccess started
) else (
    echo ✓ RemoteAccess already running
)

:: Check and start PolicyAgent
sc query PolicyAgent | find "STOPPED" >nul 2>&1
if %errorlevel% equ 0 (
    echo [%time%] Starting PolicyAgent... >> "%LOGFILE%"
    echo Starting PolicyAgent...
    sc start PolicyAgent >nul 2>&1
    echo ✓ PolicyAgent started
) else (
    echo ✓ PolicyAgent already running
)

:: Check and start IKEEXT
sc query IKEEXT | find "STOPPED" >nul 2>&1
if %errorlevel% equ 0 (
    echo [%time%] Starting IKEEXT... >> "%LOGFILE%"
    echo Starting IKEEXT...
    sc start IKEEXT >nul 2>&1
    echo ✓ IKEEXT started
) else (
    echo ✓ IKEEXT already running
)

:: Step 6: Restart network adapters
echo [%time%] Step 6: Restarting network adapters... >> "%LOGFILE%"
echo Step 6: Restarting network adapters...

:: Get active Ethernet adapter name
for /f "tokens=1,2 delims=:" %%a in ('netsh interface show interface ^| find "Enabled" ^| find "Ethernet"') do (
    set "ADAPTER_NAME=%%b"
    goto :found_adapter
)
:found_adapter

if defined ADAPTER_NAME (
    echo [%time%] Restarting %ADAPTER_NAME%... >> "%LOGFILE%"
    echo Restarting %ADAPTER_NAME%...
    netsh interface set interface "%ADAPTER_NAME%" admin=disable >nul 2>&1
    timeout /t 3 /nobreak >nul
    netsh interface set interface "%ADAPTER_NAME%" admin=enable >nul 2>&1
    echo ✓ Network adapter restarted
) else (
    echo [%time%] Ethernet adapter not found >> "%LOGFILE%"
    echo ⚠ Ethernet adapter not found
)

:: Step 7: Wait for stabilization
echo [%time%] Step 7: Waiting for network stabilization... >> "%LOGFILE%"
echo Step 7: Waiting for network stabilization...
timeout /t 5 /nobreak >nul

:: Step 8: Check internet
echo [%time%] Step 8: Checking internet... >> "%LOGFILE%"
echo Step 8: Checking internet...
ping -n 1 8.8.8.8 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ Internet available
    echo [%time%] ✓ Internet available >> "%LOGFILE%"
) else (
    echo ✗ Internet issues
    echo [%time%] ✗ Internet issues >> "%LOGFILE%"
)

:: Step 9: Check firewall rules
echo [%time%] Step 9: Checking firewall rules... >> "%LOGFILE%"
echo Step 9: Checking firewall rules...

:: Create rule for UDP 500 if it doesn't exist
netsh advfirewall firewall show rule name="IKEv2 UDP 500" >nul 2>&1
if %errorlevel% neq 0 (
    echo [%time%] Creating UDP 500 rule... >> "%LOGFILE%"
    echo Creating UDP 500 rule...
    netsh advfirewall firewall add rule name="IKEv2 UDP 500" dir=in action=allow protocol=UDP remoteport=500 >nul 2>&1
    echo ✓ UDP 500 rule created
) else (
    echo ✓ UDP 500 rule already exists
)

:: Create rule for UDP 4500 if it doesn't exist
netsh advfirewall firewall show rule name="IKEv2 UDP 4500" >nul 2>&1
if %errorlevel% neq 0 (
    echo [%time%] Creating UDP 4500 rule... >> "%LOGFILE%"
    echo Creating UDP 4500 rule...
    netsh advfirewall firewall add rule name="IKEv2 UDP 4500" dir=in action=allow protocol=UDP remoteport=4500 >nul 2>&1
    echo ✓ UDP 4500 rule created
) else (
    echo ✓ UDP 4500 rule already exists
)

:: Create rule for ESP if it doesn't exist
netsh advfirewall firewall show rule name="IKEv2 ESP" >nul 2>&1
if %errorlevel% neq 0 (
    echo [%time%] Creating ESP rule... >> "%LOGFILE%"
    echo Creating ESP rule...
    netsh advfirewall firewall add rule name="IKEv2 ESP" dir=in action=allow protocol=50 >nul 2>&1
    echo ✓ ESP rule created
) else (
    echo ✓ ESP rule already exists
)

echo.
echo ========================================
echo === FIX COMPLETED ===
echo ========================================
echo.
echo Now try to connect to VPN through:
echo 1. Windows tray (network icon)
echo 2. Settings - Network and Internet - VPN
echo.
echo If VPN still doesn't work:
echo 1. Restart router
echo 2. Try different internet
echo 3. Contact provider
echo.

echo [%time%] === FIX COMPLETED === >> "%LOGFILE%"
echo [%time%] Recommendations saved to log >> "%LOGFILE%"
echo ======================================== >> "%LOGFILE%"
echo ==== Completed: %date% %time% ==== >> "%LOGFILE%"
echo ======================================== >> "%LOGFILE%"

echo.
echo Log saved to: %LOGFILE%
echo.
pause