@echo off
chcp 65001 > nul
echo ===================================================================
echo   KDE Connect - Установка на смартфон (Android)
echo ===================================================================
echo.
echo Установка kdeconnect-phone.apk на подключенный телефон...
adb install -r -g kdeconnect-phone.apk
if %errorlevel% neq 0 (
    echo.
    echo [ИНФО] Если телефон не подключен по USB/ADB, просто перекиньте файл
    echo kdeconnect-phone.apk в память телефона и откройте его.
    pause
    exit /b %errorlevel%
)
echo.
echo [УСПЕХ] KDE Connect установлен на смартфон!
echo.
pause
