@echo off
echo Starting logcat monitoring...
"%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" -s AB3SVB4B08010957 logcat -v time "*:E"
pause
