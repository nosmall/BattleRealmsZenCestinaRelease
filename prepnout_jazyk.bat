@echo off
chcp 65001 >nul
title Battle Realms v1.60 (Steam Build 24930908) - Přepínač jazyka (CZ / ENG)

set "CZ_H2O=%~dp0data\Interface_Text.H2O"
if not exist "%CZ_H2O%" (
    if exist "%~dp0Interface\Interface_Text.H2O" (
        set "CZ_H2O=%~dp0Interface\Interface_Text.H2O"
    ) else (
        echo [CHYBA] Chybí česká data! (%CZ_H2O%)
        pause
        exit /b 1
    )
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

:menu
cls
echo ======================================================================
echo    BATTLE REALMS: ZEN EDITION - PŘEPÍNAČ JAZYKA
echo ======================================================================
echo  Herní složka: %GAME_DIR%
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
if not exist "%ORIG_H2O%" (
    if exist "%CURR_H2O%" (
        echo [*] Vytvářím zálohu originální angličtiny: Interface_Text.H2O.original
        copy /y "%CURR_H2O%" "%ORIG_H2O%" >nul
    )
)

echo [*] Nasazuji české texty rozhraní...
copy /y "%CZ_H2O%" "%CURR_H2O%" >nul
if errorlevel 1 (
    echo [CHYBA] Kopírování selhalo. Zkontrolujte oprávnění správce a zda hra neběží.
    pause
    goto menu
)

set "PKG_DIA=%~dp0data\Sound\Dialogue"
if exist "%PKG_DIA%" (
    echo [*] Nasazuji české dialogy a titulky...
    set "GAME_DIA=%GAME_DIR%\Sound\Dialogue"
    if not exist "%GAME_DIA%" mkdir "%GAME_DIA%"

    for %%F in ("%PKG_DIA%\*.H2O") do (
        if not exist "%GAME_DIA%\%%~nxF.original" (
            if exist "%GAME_DIA%\%%~nxF" (
                copy /y "%GAME_DIA%\%%~nxF" "%GAME_DIA%\%%~nxF.original" >nul
            )
        )
        copy /y "%%F" "%GAME_DIA%\%%~nxF" >nul
    )
)

echo.
echo [OK] Čeština byla úspěšně aktivována!
echo.
pause
goto end

:set_en
set "RESTORED=0"

if exist "%ORIG_H2O%" (
    echo [*] Obnovuji původní Interface_Text.H2O...
    copy /y "%ORIG_H2O%" "%CURR_H2O%" >nul
    set "RESTORED=1"
)

set "GAME_DIA=%GAME_DIR%\Sound\Dialogue"
if exist "%GAME_DIA%" (
    for %%F in ("%GAME_DIA%\*.original") do (
        echo [*] Obnovuji původní %%~nF...
        copy /y "%%F" "%GAME_DIA%\%%~nF" >nul
        set "RESTORED=1"
    )
)

if "%RESTORED%"=="0" (
    echo.
    echo [!] Záložní soubory nebyly nalezeny. Hra je již pravděpodobně v původním stavu.
    pause
    goto menu
)

echo.
echo [OK] Původní angličtina byla úspěšně obnovena!
echo.
pause
goto end

:end
