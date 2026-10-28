@echo off
chcp 65001 > nul
echo ===================================================================
echo   KDE Connect - Установка на смарт-часы (Xiaomi Watch 5 / Wear OS)
echo ===================================================================
echo.
echo 1. Убедитесь, что на часах включена "Отладка по Wi-Fi" в Настройках разработчика.
echo 2. Часы и ПК должны быть в одной Wi-Fi сети.
echo.
set /p WATCH_IP="Введите IP:порт часов (например, 192.168.1.50:5555) или нажмите Enter если уже подключены: "
if not "%WATCH_IP%"=="" (
    echo Подключение к часам %WATCH_IP%...
    adb connect %WATCH_IP%
    echo Установка kdeconnect-watch.apk на часы...
    adb -s %WATCH_IP% install -r -g kdeconnect-watch.apk
) else (
    echo Установка kdeconnect-watch.apk на часы...
    adb install -r -g kdeconnect-watch.apk
)

if %errorlevel% neq 0 (
    echo.
    echo [ОШИБКА] Не удалось установить APK на часы. Проверьте ADB-подключение.
    pause
    exit /b %errorlevel%
)

echo.
echo [УСПЕХ] KDE Connect установлен на часы!
echo Выдача системных разрешений для стабильной работы в фоне...
if not "%WATCH_IP%"=="" (
    adb -s %WATCH_IP% shell pm grant org.kde.kdeconnect_tp android.permission.POST_NOTIFICATIONS 2>nul
    adb -s %WATCH_IP% shell pm grant org.kde.kdeconnect_tp android.permission.READ_EXTERNAL_STORAGE 2>nul
    adb -s %WATCH_IP% shell pm grant org.kde.kdeconnect_tp android.permission.WRITE_EXTERNAL_STORAGE 2>nul
) else (
    adb shell pm grant org.kde.kdeconnect_tp android.permission.POST_NOTIFICATIONS 2>nul
    adb shell pm grant org.kde.kdeconnect_tp android.permission.READ_EXTERNAL_STORAGE 2>nul
    adb shell pm grant org.kde.kdeconnect_tp android.permission.WRITE_EXTERNAL_STORAGE 2>nul
)
echo Разрешения выданы.
echo.
pause
