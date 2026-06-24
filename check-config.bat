@echo off
REM Script de vérification de configuration pour n8n Docker (Windows)
REM Usage: check-config.bat

echo.
echo 🔍 Vérification de la configuration n8n...
echo.

set ERRORS=0
set WARNINGS=0

REM 1. Vérifier Docker
echo 📦 Docker...
docker version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Docker est installé et lancé
) else (
    echo ❌ Docker n'est pas installé ou pas lancé
    set /a ERRORS+=1
    echo    → Lance Docker Desktop
)

REM 2. Vérifier docker-compose
echo.
echo 🔧 Docker Compose...
docker-compose version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Docker Compose est installé
) else (
    echo ❌ Docker Compose n'est pas installé
    set /a ERRORS+=1
)

REM 3. Vérifier le fichier .env.docker
echo.
echo ⚙️  Configuration...
if exist .env.docker (
    echo ✅ Fichier .env.docker existe
    
    REM Vérifier le mot de passe Supabase
    findstr /C:"your_supabase_password_here" .env.docker >nul
    if %errorlevel% equ 0 (
        echo ❌ Mot de passe Supabase non configuré dans .env.docker
        set /a ERRORS+=1
        echo    → Édite .env.docker et remplace DB_PASSWORD
        echo    → Récupère-le sur : https://supabase.com/dashboard/project/vtnqdcxaugstcxkmkpke/settings/database
    ) else (
        echo ✅ Mot de passe Supabase configuré
    )
    
    REM Vérifier la clé de chiffrement
    findstr /C:"your_random_encryption_key_here" .env.docker >nul
    if %errorlevel% equ 0 (
        echo ⚠️  Clé de chiffrement non configurée
        set /a WARNINGS+=1
        echo    → Génère-la sur : https://generate-random.org/encryption-key-generator
        echo    → Ou laisse le script docker-run.bat te guider
    ) else (
        echo ✅ Clé de chiffrement configurée
    )
    
    REM Vérifier le mot de passe n8n
    findstr /C:"N8N_PASSWORD=admin123" .env.docker >nul
    if %errorlevel% equ 0 (
        echo ⚠️  Mot de passe n8n par défaut ^(change-le après la première connexion^)
        set /a WARNINGS+=1
    ) else (
        echo ✅ Mot de passe n8n personnalisé
    )
) else (
    echo ❌ Fichier .env.docker introuvable
    set /a ERRORS+=1
)

REM 4. Vérifier le fichier docker-compose.yml
echo.
echo 🐳 Docker Compose...
if exist docker-compose.yml (
    echo ✅ Fichier docker-compose.yml existe
    
    REM Vérifier la syntaxe
    docker-compose config >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ Syntaxe docker-compose.yml valide
    ) else (
        echo ❌ Erreur de syntaxe dans docker-compose.yml
        set /a ERRORS+=1
    )
) else (
    echo ❌ Fichier docker-compose.yml introuvable
    set /a ERRORS+=1
)

REM 5. Vérifier le port 5678
echo.
echo 🔌 Port 5678...
netstat -an | findstr ":5678" | findstr "LISTENING" >nul
if %errorlevel% equ 0 (
    echo ⚠️  Le port 5678 est déjà utilisé
    set /a WARNINGS+=1
    echo    → Change le port dans docker-compose.yml
    echo    → Ou arrête le processus qui l'utilise
) else (
    echo ✅ Port 5678 disponible
)

REM Résumé
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if %ERRORS% equ 0 (
    if %WARNINGS% equ 0 (
        echo 🎉 Configuration parfaite ! Tu peux démarrer n8n
        echo.
        echo Commande : docker-run.bat
    ) else (
        echo ⚠️  %WARNINGS% warning^(s^) - Tu peux démarrer mais vérifie les warnings
        echo.
        echo Commande : docker-run.bat
    )
) else (
    echo ❌ %ERRORS% erreur^(s^) à corriger avant de démarrer
    echo.
    echo Corrige les erreurs ci-dessus puis relance : check-config.bat
)
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

pause
exit /b %ERRORS%
