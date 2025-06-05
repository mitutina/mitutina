@echo off
setlocal enabledelayedexpansion
net use \\ktv\ktv Thienngan2002 /user:minhtuan283
if not exist "F:\ghinhanhethong\" mkdir "F:\ghinhanhethong"

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

:input_tech
echo 5. Chon ky thuat xu ly (khong khoang cach, VD: abe):
echo   A. winfree   B. ram   C. ssd   D. win   E. vs
set /p "tech_input=Nhap lua chon: "
set "tech_input=!tech_input: =!"
set "tech_input=!tech_input:a=A!"
set "tech_input=!tech_input:b=B!"
set "tech_input=!tech_input:c=C!"
set "tech_input=!tech_input:d=D!"
set "tech_input=!tech_input:e=E!"

if "!tech_input!"=="" goto input_tech

set "tech_result="
set "choices="

for /l %%i in (0,1,31) do (
    set "char=!tech_input:~%%i,1!"
    if "!char!"=="" goto :check_tech_result
    
    set "valid_char=0"
    if "!char!"=="A" set "tech=winfree" & set "valid_char=1"
    if "!char!"=="B" set "tech=ram" & set "valid_char=1"
    if "!char!"=="C" set "tech=ssd" & set "valid_char=1"
    if "!char!"=="D" set "tech=win" & set "valid_char=1"
    if "!char!"=="E" set "tech=vs" & set "valid_char=1"
    
    if !valid_char! equ 0 (
        if not "!char!"=="" (
            echo Ky tu khong hop le: !char!
            goto input_tech
        )
    ) else (
        echo !choices! | find "!char!" > nul
        if errorlevel 1 (
            if "!tech_result!"=="" (
                set "tech_result=!tech!"
            ) else (
                set "tech_result=!tech_result!+!tech!"
            )
            set "choices=!choices!!char!"
        )
    )
)

:check_tech_result
if "!tech_result!"=="" (
    echo Khong co lua chon hop le
    goto input_tech
)

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
pause
echo.
net use \\ktv\ktv /delete
endlocal
