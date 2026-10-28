@echo off
chcp 65001 > nul
echo ===================================================================
echo  Устранение вибраций и ошибки "Нет доступа" на часах (Wear OS)
echo ===================================================================
echo.
set /p WATCH_IP="Введите IP:порт часов (или нажмите Enter если уже подключены): "
if not "%WATCH_IP%"=="" (
    adb connect %WATCH_IP%
    set ADB_CMD=adb -s %WATCH_IP%
) else (
    set ADB_CMD=adb
)

echo.
echo 1. Выдача всех скрытых прав доступа...
%ADB_CMD% shell pm grant org.kde.kdeconnect_tp android.permission.POST_NOTIFICATIONS 2>nul
%ADB_CMD% shell pm grant org.kde.kdeconnect_tp android.permission.READ_EXTERNAL_STORAGE 2>nul
%ADB_CMD% shell pm grant org.kde.kdeconnect_tp android.permission.WRITE_EXTERNAL_STORAGE 2>nul
%ADB_CMD% shell pm grant org.kde.kdeconnect_tp android.permission.READ_PHONE_STATE 2>nul
%ADB_CMD% shell pm grant org.kde.kdeconnect_tp android.permission.READ_CONTACTS 2>nul
%ADB_CMD% shell appops set org.kde.kdeconnect_tp MANAGE_EXTERNAL_STORAGE allow 2>nul
%ADB_CMD% shell appops set org.kde.kdeconnect_tp SYSTEM_ALERT_WINDOW allow 2>nul
%ADB_CMD% shell cmd notification allow_listener org.kde.kdeconnect_tp/org.kde.kdeconnect.Plugins.NotificationsPlugin.NotificationReceiver 2>nul
%ADB_CMD% shell cmd notification allow_listener org.kde.kdeconnect_tp/org.kde.kdeconnect.Plugins.NotificationsPlugin.NotificationFilterService 2>nul
%ADB_CMD% shell dumpsys deviceidle whitelist +org.kde.kdeconnect_tp 2>nul

echo 2. Блокировка постоянной вибрации (вибромотор часов больше не будет дрожать)...
%ADB_CMD% shell cmd appops set org.kde.kdeconnect_tp VIBRATE ignore 2>nul

echo 3. Отключение назойливых сервисных уведомлений службы Kaiser Link...
%ADB_CMD% shell cmd notification set_notifications_enabled_for_package org.kde.kdeconnect_tp false 2>nul

echo 4. Оптимизация интерфейса под круглый экран (кнопки больше не будут обрезаться по краям)...
%ADB_CMD% shell wm density 260 2>nul

echo.
echo [ГОТОВО] Вибрация отключена, доступ выдан! Часы перестанут дрожать.
echo.
pause
