@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0export-wlan-keys.ps1"
if errorlevel 1 exit /b 1
endlocal
