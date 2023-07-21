@echo off
setlocal

REM Create the folder in C:\luukirl
set "folderPath=C:\luukirl"
if not exist "%folderPath%" mkdir "%folderPath%"

REM Copy files from the working directory to C:\luukirl
copy "%~dp0nssm.exe" "%folderPath%"
copy "%~dp0chisel.exe" "%folderPath%"
copy "%~dp0uninstall.bat" "%folderPath%"

echo Files copied successfully to C:\luukirl folder.

REM Change the working directory to C:\luukirl
cd /d "%folderPath%"

REM Prompt the user to enter the required information
set /p "auth=Please provide a value for 'auth': "
set /p "server_url=Please provide a value for 'server_url': "
set /p "fingerprint=Please provide a value for 'fingerprint': "
set /p "remote_port=Please provide a value for 'remote_port': "
set /p "local_port=Please provide a value for 'local_port': "

REM Install 'LuukIRLTunnel' service using nssm
set "servicePath=%folderPath%\chisel.exe"
set "serviceName=LuukIRLTunnel"
nssm install "%serviceName%" "%servicePath%"
nssm set "%serviceName%" AppEnvironmentExtra "AUTH=%auth%"
nssm set "%serviceName%" AppParameters "client --max-retry-interval=1m --fingerprint=%fingerprint% %server_url% R:%remote_port%:%local_port%"
nssm set "%serviceName%" Start SERVICE_DELAYED_AUTO_START

REM Start the service
nssm start "%serviceName%"

echo LuukIRLTunnel service installed successfully.

pause
