@echo off
chcp 65001 >nul
title Obnovení původní angličtiny - Battle Realms: Zen Edition

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
echo Pro obnovení původních herních souborů v Program Files je nutné
echo spustit tento skript jako Správce:
echo.
echo   1. Zavřete toto okno.
echo   2. Klikněte na "obnovit_anglictinu.bat" pravým tlačítkem myši.
echo   3. Zvolte "Spustit jako správce" / "Run as administrator".
echo.
echo ======================================================================
echo.
pause
exit /b 1

:has_admin
cls
echo ======================================================================
echo    OBNOVENÍ PŮVODNÍ ANGLIČTINY (TOVÁRNÍ STAV PRO HRU v%GAME_VER%)
echo ======================================================================
echo.

:: 1. KONTROLA BĚŽÍCÍ HRY
tasklist /fi "imagename eq Battle_Realms_F.exe" 2>nul | findstr /i "Battle_Realms_F.exe" >nul
if not errorlevel 1 (
    echo [POZOR] Hra Battle Realms právě běží!
    echo Před obnovením prosím nejprve ukončete hru.
    echo.
    pause
    exit /b 1
)

:: 2. AUTODETEKCE HERNÍ SLOŽKY
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
echo [CHYBA] Ve složce se nenachází Battle_Realms_F.exe.
pause
exit /b 1

:game_found
if "%GAME_DIR:~-1%"=="\" set "GAME_DIR=%GAME_DIR:~0,-1%"
echo [*] Nalezena herní složka: "%GAME_DIR%"
echo.
echo ======================================================================
echo    OBNOVOVÁNÍ PŮVODNÍCH SOUBORŮ ZE ZÁLOH (*.original.v%GAME_VER%)
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
    echo [!] Žádné záložní soubory [*.original.v%GAME_VER%] nebyly v herní složce nalezeny.
    echo Hra je již v původním stavu nebo nebyla zálohována tímto instalátorem.
) else (
    if %RESTORE_ERR% gtr 0 (
        echo ======================================================================
        echo  [VAROVÁNÍ] Obnoveno %RESTORE_COUNT% souborů, ale u %RESTORE_ERR% došlo k chybě zápisu.
        echo ======================================================================
    ) else (
        echo ======================================================================
        echo    ÚSPĚCH! Obnoveno %RESTORE_COUNT% souborů do původního anglického stavu.
        echo ======================================================================
    )
)
echo.
pause
exit /b 0

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
