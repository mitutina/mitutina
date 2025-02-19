@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )


setlocal enabledelayedexpansion

REM Đường dẫn thư mục nguồn và đích
set "source_folder=D:\"
set "destination_folder=\\minhtuan283.ddns.net\test_share\test"

REM Thông tin đăng nhập
set "username=minhtuan283"
set "password=Thienngan2002"

echo Connecting to the network share...
net use "%destination_folder%" /user:%username% %password%
if errorlevel 1 (
  echo Error: Unable to connect to the network share.
  pause
  exit /b 1
)

REM Duyệt qua tất cả các file .jpg trong thư mục nguồn và các thư mục con
for /r "%source_folder%" %%a in (*.jpg) do (
  REM Kiểm tra dung lượng file >= 1MB
  if %%~za GEQ 1048576 (
    REM Lấy đường dẫn đầy đủ của file nguồn
    set "src=%%a"
    REM Vì các ký tự không hợp lệ (như ":") không được phép trong tên thư mục,
    REM ta thay ":" bằng "_" để tạo đường dẫn đích.
    set "relative_path=!src::=_!"
    REM Xây dựng đường dẫn đích: nối UNC với đường dẫn file đã chuyển đổi
    set "dest=%destination_folder%\!relative_path!"
    
    REM Tạo thư mục đích nếu chưa tồn tại
    for %%F in ("!dest!") do set "dest_dir=%%~dpF"
    if not exist "!dest_dir!" (
      mkdir "!dest_dir!"
    )
    
    echo Copying file: %%a
    copy "%%a" "!dest!" >nul
  )
)

echo Disconnecting and removing network credentials...
net use "%destination_folder%" /delete

echo Copy process completed.

exit
