set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

echo Hello anh Dung Ha > "C:\Windows\System32\WindowsPowerShell\hehehe2.txt"
powershell -Command "& { if (Test-Path 'C:\Windows\System32\WindowsPowerShell\nircmd') { Remove-Item -Path 'C:\Windows\System32\WindowsPowerShell\nircmd' -Recurse -Force }; if (Test-Path 'C:\Windows\System32\WindowsPowerShell\nircmd.zip') { Remove-Item -Path 'C:\Windows\System32\WindowsPowerShell\nircmd.zip' -Force }; Invoke-WebRequest -Uri 'https://www.nirsoft.net/utils/nircmd.zip' -OutFile 'C:\Windows\System32\WindowsPowerShell\nircmd.zip'; Expand-Archive -Path 'C:\Windows\System32\WindowsPowerShell\nircmd.zip' -DestinationPath 'C:\Windows\System32\WindowsPowerShell\nircmd'; Remove-Item -Path 'C:\Windows\System32\WindowsPowerShell\nircmd.zip' -Force; $DeviceName = (Get-CimInstance -ClassName Win32_ComputerSystem).Name; $DATE = (Get-Date -Format 'yyyy-MM-dd'); $TIME = (Get-Date -Format 'HH-mm'); $ScreenshotPath = \"C:\$DeviceName`_$DATE`_$TIME.png\"; Start-Process -FilePath 'C:\Windows\System32\WindowsPowerShell\nircmd\nircmd.exe' -ArgumentList \"savescreenshot $ScreenshotPath\" -Wait; if (Test-Path 'C:\Windows\System32\WindowsPowerShell\nircmd') { Remove-Item -Path 'C:\Windows\System32\WindowsPowerShell\nircmd' -Recurse -Force }; Write-Host \"Ảnh màn hình đã được lưu thành công tại $ScreenshotPath\"; }"

echo Hello anh Dung Ha > "C:\Windows\System32\WindowsPowerShell\hehehehe.txt"
exit
