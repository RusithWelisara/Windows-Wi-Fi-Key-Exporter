@echo off
setlocal
cd /d "%~dp0"
set "OUT=%~dp0wlan_profiles.txt"

netsh wlan show profile > "%OUT%" 2>&1

if errorlevel 1 (
  echo Failed. See "%OUT%" for details.
  exit /b 1
)

echo Saved: %OUT%
endlocal
