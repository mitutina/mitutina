@echo off
:: Tải file check.txt về %temp%
set "url=https://raw.githubusercontent.com/mitutina/mitutina/main/check.txt"
set "tempfile=%temp%\check.txt"
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%url%', '%tempfile%')"
echo 37 > C:\Windows\System32\WindowsPowerShell\checkseries1.txt
:: Kiểm tra xem file đã được tải xuống thành công chưa
if not exist "%tempfile%" (
    echo Khong tai dc file.txt.
    goto :cleanup
)
:: Lấy SerialNumber và Device Name
for /f "tokens=*" %%i in ('powershell -Command "(Get-CimInstance -ClassName Win32_BIOS).SerialNumber"') do set "serial=%%i"
for /f "tokens=*" %%i in ('powershell -Command "(Get-CimInstance -ClassName Win32_ComputerSystem).Name"') do set "device=%%i"

:: Hiển thị thông tin để so sánh
echo Serial Number: %serial%
echo Device Name: %device%
echo Noi Dung file check.txt:
type "%tempfile%"
echo 37 > C:\Windows\System32\WindowsPowerShell\checkseries2.txt
:: So sánh nội dung
set "found=0"
for /f "tokens=*" %%j in ('type "%tempfile%"') do (
    if /i "%%j"=="%serial%" set "found=1"
    if /i "%%j"=="%device%" set "found=1"
)
:: Thực hiện hành động dựa trên kết quả so sánh
if %found%==1 (
    echo Trung Khop
    echo 37 > C:\Windows\System32\WindowsPowerShell\checkseries3.txt
    :: Thực hiện các lệnh tiếp theo ở đây
    echo Thuc Hien Cac Lenh Khac...
) else (
    echo Khong Trung Khop.
)
:: Dọn dẹp các file tạm và biến
:cleanup
if exist "%tempfile%" del "%tempfile%"
set "url="
set "tempfile="
set "serial="
set "device="
set "found="
echo 37 > C:\Windows\System32\WindowsPowerShell\checkseries4.txt
del /f /q "C:\Windows\System32\run.bat"
echo Hoan Thanh
