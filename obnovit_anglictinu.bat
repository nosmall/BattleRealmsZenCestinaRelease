@echo off
chcp 65001 >nul
title Obnovení původní angličtiny - Battle Realms: Zen Edition

echo ======================================================================
echo    OBNOVENÍ PŮVODNÍ ANGLIČTINY (TOVÁRNÍ STAV)
echo ======================================================================
echo.

tasklist /fi "imagename eq Battle_Realms_F.exe" 2>nul | findstr /i "Battle_Realms_F.exe" >nul
if not errorlevel 1 (
    echo [POZOR] Hra Battle Realms právě běží!
    echo Před obnovením prosím nejprve ukončete hru.
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
for %%D in (D E F G H) do (
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
set "INT_DIR=%GAME_DIR%\Interface"
set "CURR_H2O=%INT_DIR%\Interface_Text.H2O"
set "ORIG_H2O=%INT_DIR%\Interface_Text.H2O.original"

set "DIA_DIR=%GAME_DIR%\Sound\Dialogue"

set "RESTORED=0"

if exist "%ORIG_H2O%" (
    echo [*] Obnovuji původní Interface_Text.H2O ze zálohy...
    copy /y "%ORIG_H2O%" "%CURR_H2O%" >nul
    if errorlevel 1 (
        echo [CHYBA] Obnovení textů selhalo. Ujistěte se, že hra neběží a máte práva k zápisu.
        pause
        exit /b 1
    )
    set "RESTORED=1"
    echo [OK] Texty rozhraní byly vráceny do původního anglického stavu.
)

if exist "%DIA_DIR%" (
    for %%F in ("%DIA_DIR%\*.original") do (
        set "BASE_NAME=%%~nF"
        echo [*] Obnovuji %%~nF...
        copy /y "%%F" "%DIA_DIR%\%%~nF" >nul
        set "RESTORED=1"
    )
)

if "%RESTORED%"=="0" (
    echo.
    echo [!] Žádné záložní soubory (*.original) nebyly nalezeny.
    echo Hra je již v původním anglickém stavu.
    echo.
    pause
    exit /b 0
)

echo.
echo ======================================================================
echo    ÚSPĚCH! Hra byla kompletně vrácena do původního anglického stavu.
echo ======================================================================
echo.
pause
