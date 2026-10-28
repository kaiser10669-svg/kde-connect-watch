@echo off
chcp 65001 > nul
echo ===================================================================
echo   Kaiser Link - Установка на смартфон (Android)
echo ===================================================================
echo.
echo Установка kaiser-link-phone.apk на подключенный телефон...
adb install -r -d -g kaiser-link-phone.apk
if %errorlevel% neq 0 (
    echo.
    echo [ИНФО] Если телефон не подключен по USB/ADB, просто перекиньте файл
    echo kaiser-link-phone.apk в память телефона и откройте его.
    pause
    exit /b %errorlevel%
)
echo.
echo [УСПЕХ] Kaiser Link успешно установлен на смартфон!
echo.
pause
