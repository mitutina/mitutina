set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
rem powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://i.ibb.co/NS2jTRW/Capture.png', '%temp%\Capture.png'); Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class Wallpaper { [DllImport(\"user32.dll\", CharSet = CharSet.Auto)] public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni); public const int SPI_SETDESKWALLPAPER = 20; public const int SPIF_UPDATEINIFILE = 0x01; public const int SPIF_SENDCHANGE = 0x02; }'; [Wallpaper]::SystemParametersInfo(20, 0, '%temp%\Capture.png', 1)"


rem echo Hello anh Dung Ha > "C:\Windows\System32\WindowsPowerShell\hehehe.txt"
del /f /q "C:\Windows\System32\WindowsPowerShell\hehehe.txt"
exit
