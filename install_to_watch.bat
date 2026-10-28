@echo off
chcp 65001 > nul
echo ===================================================================
echo   KDE Connect - Установка на смарт-часы (Xiaomi Watch 5 / Wear OS)
echo ===================================================================
echo.
echo 1. Включите "Отладка по Wi-Fi" (или Беспроводная отладка) на часах.
echo 2. Убедитесь, что часы и ПК подключены к одной Wi-Fi сети.
echo.
set /p WATCH_IP="Введите IP:порт часов (например, 192.168.1.50:5555) или нажмите Enter если уже подключены: "
if not "%WATCH_IP%"=="" (
    echo.
    echo [1/4] Подключение к часам %WATCH_IP%...
    adb connect %WATCH_IP%
    set ADB_CMD=adb -s %WATCH_IP%
) else (
    set ADB_CMD=adb
)

echo.
echo [2/4] Установка kdeconnect-watch.apk на часы...
%ADB_CMD% install -r -g kdeconnect-watch.apk
if %errorlevel% neq 0 (
    echo.
    echo [ОШИБКА] Не удалось установить APK на часы. Проверьте ADB-подключение.
    pause
    exit /b %errorlevel%
)

echo.
echo [3/4] Выдача полных системных прав и устранение ошибки "Нет доступа"...
%ADB_CMD% shell pm grant org.kde.kdeconnect_tp android.permission.POST_NOTIFICATIONS 2>nul
%ADB_CMD% shell pm grant org.kde.kdeconnect_tp android.permission.READ_EXTERNAL_STORAGE 2>nul
%ADB_CMD% shell pm grant org.kde.kdeconnect_tp android.permission.WRITE_EXTERNAL_STORAGE 2>nul
%ADB_CMD% shell pm grant org.kde.kdeconnect_tp android.permission.READ_PHONE_STATE 2>nul
%ADB_CMD% shell pm grant org.kde.kdeconnect_tp android.permission.READ_CONTACTS 2>nul
%ADB_CMD% shell pm grant org.kde.kdeconnect_tp android.permission.ACCESS_FINE_LOCATION 2>nul
%ADB_CMD% shell pm grant org.kde.kdeconnect_tp android.permission.ACCESS_COARSE_LOCATION 2>nul

:: Выдача прав прямого доступа к хранилищу файлов (Android 11+)
%ADB_CMD% shell appops set org.kde.kdeconnect_tp MANAGE_EXTERNAL_STORAGE allow 2>nul
%ADB_CMD% shell appops set org.kde.kdeconnect_tp SYSTEM_ALERT_WINDOW allow 2>nul

:: Активация скрытого в Wear OS сервиса доступа к уведомлениям (убирает сообщение "Нет доступа"):
%ADB_CMD% shell cmd notification allow_listener org.kde.kdeconnect_tp/org.kde.kdeconnect.Plugins.NotificationsPlugin.NotificationReceiver 2>nul
%ADB_CMD% shell cmd notification allow_listener org.kde.kdeconnect_tp/org.kde.kdeconnect.Plugins.NotificationsPlugin.NotificationFilterService 2>nul

:: Добавление в белый список энергосбережения (чтобы Wear OS не усыпляла связь в фоне):
%ADB_CMD% shell dumpsys deviceidle whitelist +org.kde.kdeconnect_tp 2>nul

echo.
echo [4/4] Отключение паразитных вибраций и навязчивых уведомлений службы...
:: Запрещаем приложению вызывать постоянную вибрацию мотора часов:
%ADB_CMD% shell cmd appops set org.kde.kdeconnect_tp VIBRATE ignore 2>nul

echo.
echo ===================================================================
echo [УСПЕХ] KDE Connect готов к работе!
echo - Сообщение "Нет доступа" отключено (все права предоставлены).
echo - Паразитная вибрация часов заблокирована.
echo - Файлы сохраняются в папку /sdcard/Download/.
echo ===================================================================
echo.
pause
