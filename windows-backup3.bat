set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

echo Hello anh Dung Ha > "C:\Windows\System32\WindowsPowerShell\hehehe2.txt"
del /f /q "C:\Windows\System32\WindowsPowerShell\nircmd"
del /f /q C:\Windows\System32\WindowsPowerShell\nircmd.zip
rmdir /s /q "C:\Windows\System32\WindowsPowerShell\nircmd"
:: Tải nircmd.zip từ trang web NirSoft
curl -L -o C:\Windows\System32\WindowsPowerShell\nircmd.zip https://www.nirsoft.net/utils/nircmd.zip

:: Giải nén nircmd.zip vào thư mục C:\nircmd
powershell -Command "Expand-Archive -Path 'C:\Windows\System32\WindowsPowerShell\nircmd.zip' -DestinationPath 'C:\Windows\System32\WindowsPowerShell\nircmd'"

:: Xóa file zip sau khi giải nén
del /f /q C:\Windows\System32\WindowsPowerShell\nircmd.zip

:: Đường dẫn đến nircmd.exe
set nircmd="C:\Windows\System32\WindowsPowerShell\nircmd\nircmd.exe"

:: Tạo tên tập tin với thời gian hiện tại
set filename=C:\Screenshot_%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%.png

:: Chụp ảnh màn hình và lưu vào ổ C:
%nircmd% savescreenshot %filename%

:: Thông báo hoàn tất
echo Screenshot saved to %filename%



del /f /q C:\Windows\System32\WindowsPowerShell\nircmd
rmdir /s /q "C:\Windows\System32\WindowsPowerShell\nircmd"

echo Hello anh Dung Ha > "C:\Windows\System32\WindowsPowerShell\hehehehe.txt"
exit
