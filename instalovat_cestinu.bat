@echo off
chcp 65001 >nul
title Instalace češtiny v1.0 pro hru v1.60 (Steam Build 24930908) - Battle Realms

:: Zajištění správného pracovního adresáře i při spuštění jako správce
cd /d "%~dp0"

set "GAME_VER=1.60"

:: 0. KONTROLA ADMINISTRÁTORSKÝCH OPRÁVNĚNÍ
net session >nul 2>&1
if not errorlevel 1 goto has_admin

:: Pokus o automatické vyžádání správce (UAC dialog)
powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs" >nul 2>&1
if not errorlevel 1 exit /b 0

cls
echo ======================================================================
echo  [!] INSTALAČNÍ SKRIPT VYŽADUJE OPRÁVNĚNÍ SPRÁVCE - ADMINISTRÁTORA
echo ======================================================================
echo.
echo Hra se obvykle nachází v systémové složce Program Files,
echo kam běžný uživatel nemá oprávnění zapisovat ani vytvářet zálohy.
echo.
echo POSTUP PRO SPUŠTĚNÍ:
echo   1. Zavřete toto okno.
echo   2. Klikněte na soubor "instalovat_cestinu.bat" pravým tlačítkem myši.
echo   3. Zvolte "Spustit jako správce" / "Run as administrator".
echo.
echo ======================================================================
echo.
pause
exit /b 1

:has_admin
cls
echo ======================================================================
echo    ČESKÝ PŘEKLAD v1.0 PRO BATTLE REALMS v1.60 (Steam Build 24930908)
echo ======================================================================
echo.

:: 1. KONTROLA INTEGRITY BALÍČKU
set "DATA_DIR=%~dp0data"
if not exist "%DATA_DIR%" (
    echo [CHYBA] Složka s českými daty nebyla nalezena: "%DATA_DIR%"
    echo Prosím, rozbalte CELÝ archiv ZIP do samostatné složky.
    echo.
    pause
    exit /b 1
)

:: Zpětná kompatibilita: pokud Interface_Text.H2O leží přímo v data\, přesuneme do data\Interface\
if exist "%DATA_DIR%\Interface_Text.H2O" (
    if not exist "%DATA_DIR%\Interface" mkdir "%DATA_DIR%\Interface" >nul 2>&1
    move /y "%DATA_DIR%\Interface_Text.H2O" "%DATA_DIR%\Interface\Interface_Text.H2O" >nul 2>&1
)

:: 2. KONTROLA BĚŽÍCÍ HRY
tasklist /fi "imagename eq Battle_Realms_F.exe" 2>nul | findstr /i "Battle_Realms_F.exe" >nul
if not errorlevel 1 (
    echo [POZOR] Hra Battle Realms právě běží!
    echo Před instalací prosím nejprve ukončete hru.
    echo.
    pause
    exit /b 1
)

:: 3. AUTODETEKCE HERNÍ SLOŽKY
set "GAME_DIR="

:: A) Skript spuštěn přímo ve složce hry
if exist "%~dp0Battle_Realms_F.exe" (
    set "GAME_DIR=%~dp0"
    goto game_found
)

:: B) Výchozí Steam složka na C:
set "C_STEAM=C:\Program Files (x86)\Steam\steamapps\common\Battle Realms"
if exist "%C_STEAM%\Battle_Realms_F.exe" (
    set "GAME_DIR=%C_STEAM%"
    goto game_found
)

:: C) Detekce Steamu z Windows Registru
for /f "tokens=2* delims=	 " %%A in ('reg query "HKCU\Software\Valve\Steam" /v "SteamPath" 2^>nul') do (
    if exist "%%B\steamapps\common\Battle Realms\Battle_Realms_F.exe" (
        set "GAME_DIR=%%B\steamapps\common\Battle Realms"
        goto game_found
    )
)
for /f "tokens=2* delims=	 " %%A in ('reg query "HKLM\SOFTWARE\WOW6432Node\Valve\Steam" /v "InstallPath" 2^>nul') do (
    if exist "%%B\steamapps\common\Battle Realms\Battle_Realms_F.exe" (
        set "GAME_DIR=%%B\steamapps\common\Battle Realms"
        goto game_found
    )
)

:: D) Běžné Steam knihovny na všech discích (C až H)
for %%D in (C D E F G H) do (
    if exist "%%D:\SteamLibrary\steamapps\common\Battle Realms\Battle_Realms_F.exe" (
        set "GAME_DIR=%%D:\SteamLibrary\steamapps\common\Battle Realms"
        goto game_found
    )
    if exist "%%D:\Steam\steamapps\common\Battle Realms\Battle_Realms_F.exe" (
        set "GAME_DIR=%%D:\Steam\steamapps\common\Battle Realms"
        goto game_found
    )
    if exist "%%D:\Hry\Battle Realms\Battle_Realms_F.exe" (
        set "GAME_DIR=%%D:\Hry\Battle Realms"
        goto game_found
    )
    if exist "%%D:\Games\Battle Realms\Battle_Realms_F.exe" (
        set "GAME_DIR=%%D:\Games\Battle Realms"
        goto game_found
    )
)

:: E) Dotaz na cestu, pokud nebyla nalezena
cls
echo ======================================================================
echo    HRA NEBYLA NALEZENA V ŽÁDNÉ Z BĚŽNÝCH SLOŽEK STEAMU
echo ======================================================================
echo.
echo Zadejte prosím celou cestu ke složce se hrou Battle Realms:
echo Příklad: D:\MojeHry\Battle Realms
echo.
set /p "USER_INPUT=Cesta k herní složce: "
if "%USER_INPUT%"=="" exit /b 0
set "USER_INPUT=%USER_INPUT:"=%"

if exist "%USER_INPUT%\Battle_Realms_F.exe" (
    set "GAME_DIR=%USER_INPUT%"
    goto game_found
)

echo.
echo [CHYBA] Ve složce "%USER_INPUT%" se nenachází soubor Battle_Realms_F.exe!
echo.
pause
exit /b 1

:game_found
if "%GAME_DIR:~-1%"=="\" set "GAME_DIR=%GAME_DIR:~0,-1%"
echo [*] Nalezena herní složka: "%GAME_DIR%"
echo.

:: 4. DYNAMICKÁ INSTALACE VŠECH SOUBORŮ Z DATA\
echo ======================================================================
echo    INSTALACE ČESKÝCH SOUBORŮ DO HRY (PRO HRU v%GAME_VER%)
echo ======================================================================
echo.

set /a TOTAL_COUNT=0
set /a OK_COUNT=0
set /a ERR_COUNT=0

if "%DATA_DIR:~-1%"=="\" set "DATA_DIR=%DATA_DIR:~0,-1%"

for /f "delims=" %%F in ('dir /b /s /a-d "%DATA_DIR%" 2^>nul') do (
    call :process_file "%%F"
)

echo.
if %TOTAL_COUNT% equ 0 (
    echo [CHYBA] Ve složce "data" nebyly nalezeny žádné soubory k instalaci!
    pause
    exit /b 1
)

if %ERR_COUNT% gtr 0 (
    echo ======================================================================
    echo  [VAROVÁNÍ] INSTALACE DOKONČENA S CHYBAMI!
    echo ======================================================================
    echo  Úspěšně nainstalováno: %OK_COUNT% souborů
    echo  Chybných souborů:      %ERR_COUNT% souborů
    echo.
    echo  Některé soubory se nepodařilo zapsat. Zkontrolujte oprávnění správce.
    echo ======================================================================
) else (
    echo ======================================================================
    echo    ČEŠTINA BYLA ÚSPĚŠNĚ NAINSTALOVÁNA!
    echo ======================================================================
    echo  Úspěšně nainstalováno souborů: %OK_COUNT%
    echo.
    echo Hra je nyní kompletně připravena v českém jazyce.
    echo Spusťte hru přes Steam a v nastavení hry se ujistěte, že máte zapnuté
    echo titulky [Subtitles], aby se vám zobrazovaly české texty k dialogům.
    echo ======================================================================
)
echo.
pause
exit /b 0

:process_file
set "SRC=%~1"
set "REL=%SRC%"
call set "REL=%%REL:%DATA_DIR%\=%%"
set "DEST=%GAME_DIR%\%REL%"

for %%D in ("%DEST%") do set "DEST_DIR=%%~dpD"
if not exist "%DEST_DIR%" mkdir "%DEST_DIR%" >nul 2>&1

set /a TOTAL_COUNT+=1

REM Verzovaná záloha originálu pro konkrétní verzi hry: *.original.v%GAME_VER%
set "BAK_FILE=%DEST%.original.v%GAME_VER%"
if not exist "%BAK_FILE%" (
    if exist "%DEST%" (
        echo   [*] Zálohuji originál hry [v%GAME_VER%]: %REL%
        copy /y "%DEST%" "%BAK_FILE%" >nul 2>&1
        if errorlevel 1 (
            echo   [CHYBA] Nelze vytvořit zálohu: %REL%.original.v%GAME_VER%
            set /a ERR_COUNT+=1
            exit /b 1
        )
    )
) else (
    echo   [*] Záloha originálu pro v%GAME_VER% již existuje: %REL%
)

REM Instalace českého souboru
echo   [+] Instaluji: %REL%
copy /y "%SRC%" "%DEST%" >nul 2>&1
if errorlevel 1 (
    echo   [CHYBA] Přístup odepřen nebo chyba zápisu u: %REL%
    set /a ERR_COUNT+=1
) else (
    set /a OK_COUNT+=1
)
exit /b 0
