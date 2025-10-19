@echo off
setlocal enabledelayedexpansion

:: Check admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Administrator rights required, restarting...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: History file
set "HISTORY_FILE=%~dp0VPN-Fix-History.txt"

echo ========================================
echo === SMART VPN FIX ===
echo ========================================
echo.

:: Read history
set "WORKING_FILES="
if exist "%HISTORY_FILE%" (
    echo Reading previous successful fixes...
    for /f "delims=" %%i in (%HISTORY_FILE%) do (
        set "WORKING_FILES=!WORKING_FILES! %%i"
    )
    echo Previous working files: !WORKING_FILES!
) else (
    echo No previous history found. Starting fresh...
)

echo.
echo Step 1: Trying previous successful fixes...
if defined WORKING_FILES (
    echo Running previous successful files in sequence...
    for %%f in (!WORKING_FILES!) do (
        echo Running %%f...
        call "%%f"
    )
    echo.
    echo Try to connect to VPN now. Did it work? (Y/N)
    set /p "RESULT="
    if /i "!RESULT!"=="Y" (
        echo ✓ VPN fixed with previous method!
        goto :success
    )
)

echo.
echo Step 2: Previous method didn't work. Testing individual files...

:: Test files in order
set "TEST_FILES=Test-1-Enable-Adapters.bat Test-2-Start-RemoteAccess.bat Test-3-Clear-IPsec-SA.bat Test-4-Renew-IP.bat Test-5-Restart-Adapters.bat"

for %%f in (!TEST_FILES!) do (
    echo.
    echo Running %%f...
    call "%%f"
    echo.
    echo Try to connect to VPN now. Did it work? (Y/N)
    set /p "RESULT="
    if /i "!RESULT!"=="Y" (
        echo ✓ VPN fixed with %%f!
        echo %%f >> "%HISTORY_FILE%"
        goto :success
    )
)

echo.
echo ✗ None of the individual files worked.
echo Try running Network-Recovery.bat or restart router.
goto :end

:success
echo.
echo ========================================
echo === SUCCESS! ===
echo ========================================
echo History updated. Next time will try this method first.
echo.

:end
pause
