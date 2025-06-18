@echo off
echo ========================================
echo     اختبار التطبيق على الهاتف
echo ========================================
echo.

echo [1] التحقق من الأجهزة المتصلة...
flutter devices
echo.

echo [2] هل تريد تشغيل التطبيق على الهاتف؟ (y/n)
set /p choice="اختر (y/n): "

if /i "%choice%"=="y" (
    echo.
    echo [3] تشغيل التطبيق...
    flutter run --debug
) else (
    echo.
    echo [3] بناء APK فقط...
    flutter build apk --debug
    echo.
    echo APK جاهز في: build\app\outputs\flutter-apk\app-debug.apk
    echo يمكنك نسخه إلى الهاتف وتثبيته يدوياً
)

echo.
echo تم الانتهاء!
pause
