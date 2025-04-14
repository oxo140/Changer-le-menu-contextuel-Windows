@echo off
title Changer le menu contextuel Windows 11
color 0B
echo =====================================================
echo   CHOISISSEZ LE MENU CONTEXTUEL WINDOWS 11 OU 10
echo =====================================================
echo [1] Activer l'ancien menu contextuel (Windows 10)
echo [2] Restaurer le menu contextuel par defaut (Windows 11)
echo [3] Quitter
echo =====================================================
choice /C 123 /N /M "Votre choix : "

if %errorlevel%==1 goto Windows10
if %errorlevel%==2 goto Windows11
if %errorlevel%==3 exit

:Windows10
echo Windows Registry Editor Version 5.00 > contextuel.reg
echo. >> contextuel.reg
echo [HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}] >> contextuel.reg
echo @="" >> contextuel.reg
echo. >> contextuel.reg
echo [HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32] >> contextuel.reg
echo @="" >> contextuel.reg
goto Apply

:Windows11
echo Windows Registry Editor Version 5.00 > contextuel.reg
echo. >> contextuel.reg
echo [-HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}] >> contextuel.reg
goto Apply

:Apply
reg import contextuel.reg
del contextuel.reg
echo.
echo ✅ Modification appliquée avec succès !
echo 🔄 Redémarrage de l'Explorateur Windows...
taskkill /f /im explorer.exe
start explorer.exe
exit
