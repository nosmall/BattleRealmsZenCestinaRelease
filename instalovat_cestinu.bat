@echo off
chcp 65001 >nul
title Instalace češtiny v1.0 pro hru v1.60 (Steam Build 24930908) - Battle Realms

echo ======================================================================
echo    ČESKÝ PŘEKLAD v1.0 PRO BATTLE REALMS v1.60 (Steam Build 24930908)
echo ======================================================================
echo.

:: 1. KONTROLA INTEGRITY BALÍČKU
set "CZ_H2O=%~dp0data\Interface_Text.H2O"
if exist "%CZ_H2O%" goto check_game
if exist "%~dp0Interface\Interface_Text.H2O" (
    set "CZ_H2O=%~dp0Interface\Interface_Text.H2O"
    goto check_game
)

echo [CHYBA] Chybí česká data: "%CZ_H2O%"
echo Prosím, rozbalte CELÝ archiv ZIP do samostatné složky.
echo.
pause
exit /b 1

:check_game
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

:: C) Časté Steam knihovny na dalších discích
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

:: D) Dotaz na cestu, pokud nebyla nalezena
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
pause
exit /b 1

:game_found
echo [*] Nalezena herní složka: "%GAME_DIR%"
echo.

set "INT_DIR=%GAME_DIR%\Interface"
set "CURR_H2O=%INT_DIR%\Interface_Text.H2O"
set "ORIG_H2O=%INT_DIR%\Interface_Text.H2O.original"

:: 4. BEZPEČNÁ ZÁLOHA ORIGINÁLNÍHO ANGLICKÉHO SOUBORU
if not exist "%ORIG_H2O%" (
    if exist "%CURR_H2O%" (
        echo [*] Vytvářím zálohu originální angličtiny: Interface_Text.H2O.original
        copy /y "%CURR_H2O%" "%ORIG_H2O%" >nul
        if errorlevel 1 (
            echo [VAROVÁNÍ] Nepodařilo se vytvořit záložní soubor.
        ) else (
            echo [OK] Původní angličtina je bezpečně zálohována.
        )
    )
) else (
    echo [*] Záloha originální angličtiny již existuje.
)

:: 5. KOPÍROVÁNÍ POUZE JEDNOHO ČESKÉHO SOUBORU
:: 5. KOPÍROVÁNÍ ČESKÝCH TEXTŮ A DIALOGŮ
echo [*] Instaluji české texty rozhraní...
copy /y "%CZ_H2O%" "%CURR_H2O%" >nul
if errorlevel 1 (
    echo [CHYBA] Instalace textů selhala! Ujistěte se, že hra neběží a máte práva k zápisu.
    pause
    exit /b 1
)
echo [OK] České texty rozhraní úspěšně nainstalovány.

:: Kontrola, zda balíček obsahuje i český dabing/titulky dialogů (Sound\Dialogue)
set "PKG_DIA=%~dp0data\Sound\Dialogue"
if exist "%PKG_DIA%" (
    echo.
    echo [*] Nalezeny české dialogy a titulky ke cutscénám...
    set "GAME_DIA=%GAME_DIR%\Sound\Dialogue"
    if not exist "%GAME_DIA%" mkdir "%GAME_DIA%"

    for %%F in ("%PKG_DIA%\*.H2O") do (
        if not exist "%GAME_DIA%\%%~nxF.original" (
            if exist "%GAME_DIA%\%%~nxF" (
                echo   [+] Zálohuji originální %%~nxF...
                copy /y "%GAME_DIA%\%%~nxF" "%GAME_DIA%\%%~nxF.original" >nul
            )
        )
        echo   [+] Instaluji český %%~nxF...
        copy /y "%%F" "%GAME_DIA%\%%~nxF" >nul
    )
    echo [OK] Všechny české dialogy a titulky byly úspěšně nainstalovány.
)

echo.
echo ======================================================================
echo    ČEŠTINA BYLA ÚSPĚŠNĚ NAINSTALOVÁNA!
echo ======================================================================
echo Hra je nyní kompletně připravena v českém jazyce.
echo Spusťte hru přes Steam a v nastavení se ujistěte, že máte zapnuté
echo titulky (Subtitles), aby se vám zobrazovaly české texty k rozhovorům.
echo.
pause
