@echo off
chcp 65001 >nul
title Battle Realms v1.60 (Steam Build 24930908) - Přepínač jazyka (CZ / ENG)

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
echo  [!] SKRIPT VYŽADUJE OPRÁVNĚNÍ SPRÁVCE - ADMINISTRÁTORA
echo ======================================================================
echo.
echo Pro přepínání herních souborů v Program Files je nutné
echo spustit tento skript jako Správce:
echo.
echo   1. Zavřete toto okno.
echo   2. Klikněte na "prepnout_jazyk.bat" pravým tlačítkem myši.
echo   3. Zvolte "Spustit jako správce" / "Run as administrator".
echo.
echo ======================================================================
echo.
pause
exit /b 1

:has_admin
set "DATA_DIR=%~dp0data"
if not exist "%DATA_DIR%" (
    echo [CHYBA] Chybí česká data: %DATA_DIR%
    pause
    exit /b 1
)

:: Zpětná kompatibilita: pokud Interface_Text.H2O leží přímo v data\, přesuneme do data\Interface\
if exist "%DATA_DIR%\Interface_Text.H2O" (
    if not exist "%DATA_DIR%\Interface" mkdir "%DATA_DIR%\Interface" >nul 2>&1
    move /y "%DATA_DIR%\Interface_Text.H2O" "%DATA_DIR%\Interface\Interface_Text.H2O" >nul 2>&1
)

tasklist /fi "imagename eq Battle_Realms_F.exe" 2>nul | findstr /i "Battle_Realms_F.exe" >nul
if not errorlevel 1 (
    echo [POZOR] Hra Battle Realms právě běží!
    echo Před přepnutím jazyka prosím nejprve ukončete hru.
    echo.
    pause
    exit /b 1
)

set "GAME_DIR="
if exist "%~dp0Battle_Realms_F.exe" (
    set "GAME_DIR=%~dp0"
    goto game_found
)
set "C_STEAM=C:\Program Files (x86)\Steam\steamapps\common\Battle Realms"
if exist "%C_STEAM%\Battle_Realms_F.exe" (
    set "GAME_DIR=%C_STEAM%"
    goto game_found
)

:: Detekce Steamu z Windows Registru
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

:: Běžné Steam knihovny na všech discích (C až H)
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

cls
echo ======================================================================
echo    HRA NEBYLA NALEZENA VE VÝCHOZÍ SLOŽCE STEAMU
echo ======================================================================
echo.
echo Zadejte celou cestu ke složce s hrou Battle Realms:
echo (nebo stiskněte Enter pro ukončení)
echo.
set /p "USER_INPUT=Cesta k herní složce: "
if "%USER_INPUT%"=="" exit /b 0
set "USER_INPUT=%USER_INPUT:"=%"
if exist "%USER_INPUT%\Battle_Realms_F.exe" (
    set "GAME_DIR=%USER_INPUT%"
    goto game_found
)
echo [CHYBA] Složka nebyla nalezena.
pause
exit /b 1

:game_found
if "%GAME_DIR:~-1%"=="\" set "GAME_DIR=%GAME_DIR:~0,-1%"

:menu
cls
echo ======================================================================
echo    BATTLE REALMS: ZEN EDITION - PŘEPÍNAČ JAZYKA
echo ======================================================================
echo  Herní složka: %GAME_DIR%
echo  Verze hry:    v%GAME_VER%
echo ======================================================================
echo.
echo  [1] Aktivovat ČEŠTINU
echo  [2] Obnovit původní ANGLIČTINU (Tovární stav)
echo  [0] Konec
echo.
echo ======================================================================
set /p "choice=Zadejte volbu [1/2/0]: "

if "%choice%"=="1" goto set_cz
if "%choice%"=="2" goto set_en
if "%choice%"=="0" goto end
echo Neplatná volba!
timeout /t 1 >nul
goto menu

:set_cz
cls
echo ======================================================================
echo    AKTIVACE ČEŠTINY (PRO HRU v%GAME_VER%)
echo ======================================================================
echo.

set /a TOTAL_COUNT=0
set /a OK_COUNT=0
set /a ERR_COUNT=0

if "%DATA_DIR:~-1%"=="\" set "DATA_DIR=%DATA_DIR:~0,-1%"

for /f "delims=" %%F in ('dir /b /s /a-d "%DATA_DIR%" 2^>nul') do (
    call :process_cz_file "%%F"
)

echo.
if %ERR_COUNT% gtr 0 (
    echo [VAROVÁNÍ] Některé soubory se nepodařilo zkopírovat - chyb: %ERR_COUNT%
) else (
    echo [OK] Čeština byla úspěšně aktivována - instalováno souborů: %OK_COUNT%
)
echo.
pause
goto end

:process_cz_file
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
            echo   [CHYBA] Nelze vytvořit zálohu pro: %REL%
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

:set_en
cls
echo ======================================================================
echo    OBNOVENÍ ANGLIČTINY ZE ZÁLOH (*.original.v%GAME_VER%)
echo ======================================================================
echo.

set /a RESTORE_COUNT=0
set /a RESTORE_ERR=0

set "SUFFIX=.original.v%GAME_VER%"
for /f "delims=" %%F in ('dir /b /s /a-d "%GAME_DIR%\*%SUFFIX%" 2^>nul') do (
    call :restore_file "%%F" "%SUFFIX%"
)

echo.
if %RESTORE_COUNT% equ 0 (
    echo [!] Žádné záložní soubory [*.original.v%GAME_VER%] nebyly nalezeny. Hra je již v původním stavu.
) else (
    if %RESTORE_ERR% gtr 0 (
        echo [VAROVÁNÍ] Obnoveno %RESTORE_COUNT% souborů, ale u %RESTORE_ERR% došlo k chybě.
    ) else (
        echo [OK] Původní angličtina byla úspěšně obnovena - počet souborů: %RESTORE_COUNT%
    )
)
echo.
pause
goto end

:restore_file
set "ORIG_FILE=%~1"
set "EXT_TO_STRIP=%~2"
call set "TARGET_FILE=%%ORIG_FILE:%EXT_TO_STRIP%=%%"
set "REL_FILE=%TARGET_FILE%"
call set "REL_FILE=%%REL_FILE:%GAME_DIR%\=%%"

echo   [*] Obnovuji originál: %REL_FILE%
copy /y "%ORIG_FILE%" "%TARGET_FILE%" >nul 2>&1
if errorlevel 1 (
    echo   [CHYBA] Obnovení souboru selhalo: %REL_FILE%
    set /a RESTORE_ERR+=1
) else (
    set /a RESTORE_COUNT+=1
)
exit /b 0

:end
