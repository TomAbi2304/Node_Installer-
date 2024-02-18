@echo off
setlocal EnableDelayedExpansion

net session >nul 2>&1
if %errorlevel% == 0 (
    echo Script is running with administrator privileges.
) else (
    echo Script must be run as administrator. Exiting...
    pause
)

echo Downloading Node JS...
curl "https://nodejs.org/dist/v20.6.0/node-v20.6.0-x64.msi" --output nodejs.msi

echo Installing Node JS...
msiexec /i nodejs.msi /qn /norestart

set /p FWRULE=Does your node application need access from a port from outside? (y,n) 

if "%FWRULE%" == "n" (
    del installer.bat
    del nodejs.msi
    echo Installtion successfull, exiting...
    pause
) else (
    set /p PORT=Please enter your Port: 
    set RULE_NAME="Node JS Application !PORT!"
    
    netsh advfirewall firewall show rule name=%RULE_NAME% >nul
    if not ERRORLEVEL 1 (
        echo Port %PORT% is already open.
        pause
    ) else (
        echo Creating Firewall Rule...
        netsh advfirewall firewall add rule name=!RULE_NAME! dir=in action=allow protocol=TCP localport=!PORT! > nul
        netsh advfirewall firewall add rule name=!RULE_NAME! dir=in action=allow protocol=UDP localport=!PORT! > nul
        echo Firewall Rule created successfully.
        del installer.bat
        del nodejs.msi
        echo Installtion successfull, exiting...
        pause
    )
)
