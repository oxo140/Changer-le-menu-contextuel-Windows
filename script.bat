@echo off
title Changer le menu contextuel Windows 11
color 0B

:: Fonction pour détecter la version de Windows
for /f "tokens=4-5 delims=. " %%i in ('ver') do set version=%%i.%%j

echo =====================================================
echo   DETECTION DE LA VERSION DE WINDOWS
echo =====================================================
echo Version détectée : %version%
echo =====================================================

:: Menu principal
echo CHOISISSEZ LE MENU CONTEXTUEL WINDOWS 11 OU 10
echo =====================================================
echo [1] Activer l'ancien menu contextuel (Windows 10)
echo [2] Restaurer le menu contextuel par defaut (Windows 11)
echo [3] Quitter
echo =====================================================
choice /C 123 /N /M "Votre choix : "

if %errorlevel%==1 goto OldMenu
if %errorlevel%==2 goto DefaultMenu
if %errorlevel%==3 exit

:OldMenu
if "%version%" GEQ "10.0.22621" (
    echo.
    echo 🔍 Windows 11 22H2 ou plus recent detecte.
    if "%version%" GEQ "10.0.22631" (
        echo 🚨 Windows 11 23H2 detecte.
        echo La modification via registre ne fonctionne plus sur cette version.
        echo Voulez-vous installer ExplorerPatcher pour restaurer l'ancien menu contextuel ?
        echo [O] Oui
        echo [N] Non
        choice /C ON /N /M "Votre choix : "
        if %errorlevel%==1 goto InstallExplorerPatcher
        if %errorlevel%==2 exit
    ) else (
        goto RegistryOldMenu
    )
) else (
    goto RegistryOldMenu
)

:RegistryOldMenu
echo.
echo 📝 Application de la modification du registre...
echo Windows Registry Editor Version 5.00 > contextuel.reg
echo. >> contextuel.reg
echo [HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}] >> contextuel.reg
echo @="" >> contextuel.reg
echo. >> contextuel.reg
echo [HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32] >> contextuel.reg
echo @="" >> contextuel.reg
goto Apply

:DefaultMenu
echo.
echo 📝 Restauration du menu contextuel par defaut...
echo Windows Registry Editor Version 5.00 > contextuel.reg
echo. >> contextuel.reg
echo [-HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}] >> contextuel.reg
goto Apply

:Apply
reg import contextuel.reg
del contextuel.reg
echo.
echo ✅ Modification appliquee avec succes !
echo 🔄 Redemarrage de l'Explorateur Windows...
taskkill /f /im explorer.exe
start explorer.exe
pause
exit

:InstallExplorerPatcher
echo.
echo ⏬ Telechargement et installation d'ExplorerPatcher...
bitsadmin /transfer "ExplorerPatcher" https://github.com/valinet/ExplorerPatcher/releases/latest/download/ep_setup.exe "%cd%\ep_setup.exe"
echo.
echo ▶️ Installation en cours...
start /wait ep_setup.exe /silentinstall
del ep_setup.exe
echo ✅ Installation terminee !
echo 🔄 Redemarrage de l'Explorateur Windows...
taskkill /f /im explorer.exe
start explorer.exe
pause
exit
