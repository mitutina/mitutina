@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )


setlocal enabledelayedexpansion
REM Source and Destination folders
set "source_folder=F:\"
set "destination_folder=\\minhtuan283.ddns.net\test_share\test"

REM Login credentials
set "username=minhtuan283"
set "password=Thienngan2002"

REM Danh sách các phần mở rộng file cần sao chép (cách nhau bằng dấu cách)
set "ext_list=.jpg .png .mp4"

echo Connecting to the network share...
net use "%destination_folder%" /user:%username% %password%
if errorlevel 1 (
    echo Error: Unable to connect to the network share.
    pause
    exit /b 1
)

echo Processing files from %source_folder% ...

REM Duyệt qua từng phần mở rộng trong danh sách
for %%e in (%ext_list%) do (
    echo Processing extension %%e ...
    REM Duyệt đệ quy các file có phần mở rộng %%e
    for /r "%source_folder%" %%a in (*%%e) do (
        REM Kiểm tra kích thước file >= 1MB (1MB = 1048576 bytes)
        if %%~za GEQ 1048576 (
            REM Lấy đường dẫn file nguồn
            set "src=%%a"
            REM Thay thế ký tự ":" bằng "_" để tránh lỗi khi tạo thư mục
            set "relative_path=!src::=_!"
            REM Xây dựng đường dẫn file đích
            set "dest=%destination_folder%\!relative_path!"
            
            REM Nếu file đã tồn tại ở đích thì bỏ qua
            if exist "!dest!" (
                echo File already exists, skipping: %%a
            ) else (
                REM Tạo thư mục đích nếu chưa tồn tại
                for %%F in ("!dest!") do set "dest_dir=%%~dpF"
                if not exist "!dest_dir!" (
                    mkdir "!dest_dir!"
                )
                echo Copying file: %%a
                copy "%%a" "!dest!" >nul
            )
        )
    )
)

echo Disconnecting and removing network credentials...
net use "%destination_folder%" /delete

echo Copy process completed.
exit
