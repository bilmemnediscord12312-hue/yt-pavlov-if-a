@echo off
title PavClient Builder
setlocal enabledelayedexpansion

echo ============================================
echo        PAVCLIENT - Build Baslatiyor
echo ============================================
echo.
echo Minecraft 1.21.4 - Fabric Loom 1.9.2
echo Java 21
echo.

if "%JAVA_HOME%"=="" (
    echo [!] JAVA_HOME ayarlanmamis!
    pause
    exit /b 1
)
echo [*] Java: %JAVA_HOME%
echo.

:: Wrapper yoksa Gradle'i indir ve wrapper olustur
if not exist "gradlew.bat" (
    echo [1/3] Gradle 8.10 indiriliyor...
    powershell -Command "& {param($u,$f) [System.Net.WebClient]::new().DownloadFile($u,$f)}" -u "https://services.gradle.org/distributions/gradle-8.10-bin.zip" -f "%TEMP%\gradle-8.10-bin.zip"
    if !errorlevel! neq 0 (
        echo [!] Gradle indirilemedi. Internet baglantinizi kontrol edin.
        pause
        exit /b 1
    )
    echo [*] Gradle indirildi, ayiklaniyor...
    powershell -Command "Expand-Archive -Path '%TEMP%\gradle-8.10-bin.zip' -DestinationPath '%TEMP%\gradle-8.10' -Force"
    echo [*] Gradle wrapper olusturuluyor...
    "%TEMP%\gradle-8.10\gradle-8.10\bin\gradle" wrapper --gradle-version 8.10
    if !errorlevel! neq 0 (
        echo [!] Gradle wrapper olusturulamadi!
        pause
        exit /b 1
    )
    echo [*] Gradle wrapper hazir
) else (
    echo [1/3] Gradle wrapper mevcut, atlaniyor...
)

echo.
echo [2/3] Gradle build baslatiliyor...
call gradlew.bat build --no-daemon
if !errorlevel! neq 0 (
    echo [!] Build hatasi!
    pause
    exit /b 1
)

echo.
echo [3/3] Build basarili!
echo.
echo Olusan JAR: build/libs/PavClient-1.0.0.jar
echo.
pause
