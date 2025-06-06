@echo off
setlocal enabledelayedexpansion
net use \\ktv\ktv Thienngan2002 /user:minhtuan283

:input_name
set /p "fullname=1. Ho va ten: "
if "!fullname!"=="" goto input_name

:input_phone
set /p "phone=2. SDT: "
set "phone=!phone: =!"
set "str_len=0"
set "temp_sdt=!phone!"

:count_len_loop
if defined temp_sdt (
    set /a str_len+=1
    set "temp_sdt=!temp_sdt:~1!"
    goto count_len_loop
)

if not !str_len! equ 10 (
    echo SDT phai co dung 10 ky tu. Ban da nhap !str_len! ky tu.
    goto input_phone
)

for /f "delims=0123456789" %%i in ("!phone!") do (
    echo SDT chi duoc chua so.
    goto input_phone
)

:input_serial
echo 3. Chon nguon so series:
echo   A. Lay so Series (tu BIOS)
echo   B. SDT (so dien thoai)
choice /c AB /n /m "Lua chon cua ban (A/B): "
if errorlevel 2 set "serial=!phone!" & goto serial_selected
if errorlevel 1 (
    for /f "delims=" %%a in ('powershell -Command "(Get-CimInstance -ClassName Win32_BIOS).SerialNumber.Trim()"') do set "serial=%%a"
    goto serial_selected
)

:serial_selected
:input_note
set /p "note=4. Ghi chu: "
if "!note!"=="" set "note=Khong co"

:: Dinh nghia cac ky thuat xu ly
set "tech_A=winfree"
set "tech_B=ram"
set "tech_C=ssd"
set "tech_D=win"
set "tech_E=vs"
set "tech_F=psu"

:menu
cls
echo Chon mot hoac nhieu ky thuat xu ly (vi du: ABE):
echo.
echo   A. winfree
echo   B. ram
echo   C. ssd
echo   D. win
echo   E. vs
echo   F. psu
echo.

set "tech_result="
set "user_choice="
set /p "user_choice=Nhap lua chon cua ban va an Enter: "

:: Kiem tra va xu ly lua chon
if not defined user_choice (
    echo Lua chon khong hop le. Vui long thu lai.
    timeout /t 2 >nul
    goto menu
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
    goto menu
)

set "tech_result=!final_result!"

:: Hien thi ket qua
echo.
echo Cac ky thuat duoc chon: !tech_result!
echo.
:input_price
set /p "price=6. Gia tien: "
if "!price!"=="" set "price=0"

:get_pc_info
echo 7. Dang lay thong tin may...
set "thongtinmay=Unknown"
for /f "delims=" %%a in ('powershell -Command "$cpu=(Get-CimInstance Win32_Processor).Name -replace '\s+','';$ram=[math]::Round((Get-CimInstance Win32_PhysicalMemory|Measure-Object Capacity -Sum).Sum/1GB);$gpu=(Get-CimInstance Win32_VideoController).Name|ForEach-Object{$_ -replace '\s+',''};$disk=(Get-CimInstance Win32_DiskDrive).Model|ForEach-Object{$_ -replace '\s+',''};$wifi=(Get-CimInstance Win32_NetworkAdapter|Where-Object{$_.NetEnabled -eq $true -and ($_.Name -match 'Wi-Fi|Wireless')}).Name -replace '\s+','';$out=$cpu + '_' + ${ram} + 'GB' + '_' + ($gpu -join '_') + '_' + ($disk -join '_') + '_' + $wifi;Write-Output $out" 2^>NUL') do set "thongtinmay=%%a"

:write_file
set "output=!fullname!|!phone!|!serial!|!note!|!tech_result!|!price!|!thongtinmay!"
echo !output!>>"\\ktv\ktv\serial\ghinhan.txt"

echo.
echo Hoan thanh ghi du lieu!
echo.
pause
endlocal
