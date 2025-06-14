@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (
    echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %*", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)
:: Ket noi den o dia mang
echo [1/9] Dang ket noi den \\ktv\ktv...
net use \\ktv\ktv Thienngan2002 /user:minhtuan283 >nul 2>&1

if !errorlevel! neq 0 (
    echo.
    echo *** Thu ket noi khong can mat khau...
    net use \\ktv\ktv >nul 2>&1
)

if !errorlevel! neq 0 (
    echo.
    echo *** LOI: Ket noi that bai!
    echo *** Kiem tra lai:
    echo     1. Ket noi mang
    echo     2. Trang thai may chu
    echo     3. Thong tin tai khoan
    echo.
    pause
    goto :eof
)
echo [1/9] Ket noi thanh cong!
timeout /t 2 >nul
cls

:: Khoi tao bien
set "user="
set "passuser="
set "fullname="
set "phone="
set "serial="
set "note="
set "tech_result="
set "price="

:begin_input
:: Nhap thong tin
echo [2/7] THONG TIN KHACH HANG
echo --------------------------
if defined user (set "user_prompt=[Hien tai: !user!]") else (set "user_prompt=")
set /p "user=  1. Nhap ID Eservice !user_prompt!: "
if "!user!"=="" goto begin_input

if defined passuser (set "pass_prompt=[Hien tai: !passuser!]") else (set "pass_prompt=")
set /p "passuser=  2. Nhap Password Eservice !pass_prompt!: "
if "!passuser!"=="" set "passuser=N/A"

if defined fullname (set "name_prompt=[Hien tai: !fullname!]") else (set "name_prompt=")
:input_name
set /p "fullname=  3. Ho ten khach hang !name_prompt!: "
if "!fullname!"=="" goto input_name

if defined phone (set "phone_prompt=[Hien tai: !phone!]") else (set "phone_prompt=")
:input_phone
set /p "phone=  4. SDT !phone_prompt!: "
set "phone=!phone: =!"
if "!phone!"=="" goto input_phone

:: Kiem tra SDT
set "str_len=0"
set "temp_sdt=!phone!"
:count_len_loop
if defined temp_sdt (
    set /a str_len+=1
    set "temp_sdt=!temp_sdt:~1!"
    goto count_len_loop
)

if not !str_len! equ 10 (
    echo    SDT phai co 10 chu so. Ban nhap: !str_len! ky tu
    timeout /t 2 >nul
    goto input_phone
)

for /f "delims=0123456789" %%i in ("!phone!") do (
    echo    SDT chi duoc chua so
    timeout /t 2 >nul
    goto input_phone
)

:: Chon nguon serial
:input_serial
echo   5. Nhap so Serial:
echo      A. Lay so Series (tu BIOS)
echo      B. SDT (so dien thoai)
if defined serial (
    echo     [Lua chon hien tai: !serial!]
) else (
    echo     [Chua chon]
)
choice /c AB /n /m "   Lua chon (A/B): "
if errorlevel 2 set "serial_source=B" & set "serial=!phone!" & goto serial_selected
if errorlevel 1 set "serial_source=A" & (
    for /f "delims=" %%a in ('powershell -Command "(Get-CimInstance -ClassName Win32_BIOS).SerialNumber.Trim()"') do set "serial=%%a"
)
:serial_selected
echo    Da chon: !serial_source! - Serial: !serial!

:INPUT_NOTE
:: Thiết lập note_prompt nếu đã có note trước đó
if defined note (
    set "note_prompt=[Hien tai: !note!]"
) else (
    set "note_prompt="
)

:: Yêu cầu nhập
set /p "note=  6. Mo Ta Loi !note_prompt!: "

:: Nếu để trống thì nhắc và quay lại
if "!note!"=="" (
    echo.
    echo Ban chua nhap mo ta loi. Vui long nhap lai.
    echo.
    goto INPUT_NOTE
)

:: Xử lý tiếp khi da co note
echo Da nhap mo ta loi: !note!

:: Chon ky thuat
:: Dinh nghia cac ky thuat xu ly
set "tech_A=winfree"
set "tech_B=ram"
set "tech_C=ssd"
set "tech_D=win"
set "tech_E=vs"
set "tech_F=psu"

:menuu
cls
echo [3/7] CHON KY THUAT XU LY
echo -------------------------
echo  7. Chon mot hoac nhieu ky thuat (VD: A,ABE,acf,AdE,...):
echo.
echo    A. Xu ly Phan Mem Free     [Cai Free]
echo    B. RAM                     [Thay RAM]
echo    C. SSD                     [Thay SSD]
echo    D. Xu ly Phan Mem 120k     
echo    E. Ve Sinh May             [Dich vu Ve Sinh]
echo    F. Psu                     [Thay nguon]
echo.

set "tech_result="
set "user_choice="
set /p "user_choice=Nhap lua chon cua ban va an Enter: "

:: Kiem tra va xu ly lua chon
if not defined user_choice (
    echo Lua chon khong hop le. Vui long thu lai.
    timeout /t 2 >nul
    goto menuu
)

set "temp_choice=%user_choice%"
set "processed_chars="
set "final_result="

:process_loop
if not "!temp_choice!"=="" (
    set "char=!temp_choice:~0,1!"
    set "temp_choice=!temp_choice:~1!"

    REM Kiem tra xem ky tu da duoc xu ly chua
    echo "!processed_chars!" | find /i "!char!" >nul
    if errorlevel 1 (
        set "processed_chars=!processed_chars!!char!"
        for %%T in (A B C D E F) do (
            if /i "!char!"=="%%T" (
                if defined final_result (
                    set "final_result=!final_result!+!tech_%%T!"
                ) else (
                    set "final_result=!tech_%%T!"
                )
            )
        )
    )
    goto process_loop
)

if not defined final_result (
    echo Lua chon khong hop le. Vui long thu lai.
    timeout /t 2 >nul
    goto menuu
)

set "tech_result=!final_result!"
:: Hien thi ket qua
echo.
echo Cac ky thuat duoc chon: !tech_result!
echo.

:: Nhap gia tien
if defined price (set "price_prompt=[Hien tai: !price! VND]") else (set "price_prompt=")
:input_price
set /p "price=  8. Gia tien !price_prompt!: "
if "!price!"=="" set "price=0"

:MENU
cls
echo.
echo [4/7] Lay cau hinh may:
:: LUA CHON CHE DO NHAP THONG TIN
:NHAP_THONG_TIN_CHOICE
echo.
echo   [LUA CHON NHAP THONG TIN MAY]
echo   A. Nhap cau hinh may AUTO (tu dong)
echo   B. Nhap thu cong (Vd: Laptop Dell, Laptop Acer,...)
echo.
choice /c:AB /n /m "Nhap lua chon [A/B]: "

if errorlevel 2 goto :NHAP_THU_CONG
if errorlevel 1 goto :NHAP_TU_DONG

:: CHE DO TU DONG
:NHAP_TU_DONG
echo [AUTO] Dang kiem tra cau hinh...
set "thongtinmay=UNKNOWN"

for /f "delims=" %%a in ('powershell -Command "$cpu=(Get-CimInstance Win32_Processor).Name -replace '\s+','';$ram=[math]::Round((Get-CimInstance Win32_PhysicalMemory|Measure-Object Capacity -Sum).Sum/1GB);$gpu=(Get-CimInstance Win32_VideoController).Name|ForEach-Object{$_ -replace '\s+',''};$disk=(Get-CimInstance Win32_DiskDrive).Model|ForEach-Object{$_ -replace '\s+',''};$wifi=(Get-CimInstance Win32_NetworkAdapter|Where-Object{$_.NetEnabled -eq $true -and ($_.Name -match 'Wi-Fi|Wireless')}).Name -replace '\s+','';$out=$cpu + '_' + ${ram} + 'GB' + '_' + ($gpu -join '_') + '_' + ($disk -join '_') + '_' + $wifi;Write-Output $out" 2^>NUL') do set "thongtinmay=%%a"

goto :CONTINUE_SCRIPT

:: CHE DO NHAP TAY
:NHAP_THU_CONG
echo.
set /p "thongtinmay=[MANUAL] Nhap thong tin may : "
if "!thongtinmay!"=="" (
    echo Khong duoc de trong! Hay nhap lai
    goto :NHAP_THU_CONG
)

:CONTINUE_SCRIPT
echo Da luu thong tin: !thongtinmay!
timeout /t 1

:: Khởi tạo giá trị mặc định
set "checkdevice=desktop"

:: Kiểm tra pin bằng PowerShell
for /f "delims=" %%i in ('powershell -command "$battery = Get-WmiObject Win32_Battery -ErrorAction SilentlyContinue; if ($battery) { 'laptop' } else { 'desktop' }" 2^>nul') do (
    set "checkdevice=%%i"
)

:: Hiển thị kết quả (có thể bỏ qua nếu chỉ cần biến)
echo Thiet bi la: !checkdevice!

:: Hien thi xac nhan
:confirmation
cls
echo [5/7] XAC NHAN THONG TIN
echo =======================
echo   1. User.......: !user!
echo   2. Password...: !passuser!
echo   3. Ho ten.....: !fullname!
echo   4. SDT........: !phone!
echo   5. Serial.....: !serial!  [Nguon: !serial_source!]
echo   6. Ghi chu....: !note!
echo   7. Ky thuat...: !tech_result!
echo   8. Gia tien...: !price! VND
echo   9. Thong tin..: !thongtinmay!
echo   10. Loai may..: !checkdevice!
echo.
choice /c YN /n /m "   Ban co muon ghi thong tin? (Y/N): "
if errorlevel 2 goto begin_input
if errorlevel 1 goto write_file

:: Ghi du lieu
:write_file
echo [6/7] Dang ghi du lieu...
set "output=!user!|!passuser!|!fullname!|!phone!|!serial!|!note!|!tech_result!|!price!|!thongtinmay!|!checkdevice!"
>>"\\ktv\ktv\serial\ghinhan.txt" echo !output!
echo   Ghi file thanh cong!
timeout /t 2 >nul
cls

:: Ngat ket noi
echo [7/7] Dang ngat ket noi...
net use \\ktv\ktv /delete /y >nul 2>&1
echo   Da ngat ket noi
timeout /t 2 >nul
cls


endlocal
