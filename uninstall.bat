@echo off
setlocal

REM Set the service name to uninstall
set "serviceName=LuukIRLTunnel"

REM Change the working directory to script directory
cd /d "%~dp0"

REM Stop the service if it is running
echo Stopping the LuukIRLTunnel service...
net stop "%serviceName%" >nul 2>&1

REM Wait for the service to stop
:WAIT_LOOP
timeout /t 1 /nobreak >nul
sc query "%serviceName%" | find "STATE" | find "RUNNING" >nul
if not errorlevel 1 goto :WAIT_LOOP

REM Remove the service using nssm
nssm remove "%serviceName%" confirm

echo LuukIRLTunnel service uninstalled successfully.

REM Remove the directory after the cleanup
rmdir /s /q "%~dp0"

pause
