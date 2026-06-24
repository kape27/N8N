@echo off
REM Script pour démarrer n8n avec Docker sur Windows
REM Usage: docker-run.bat

echo.
echo 🚀 Démarrage de n8n avec Docker...
echo.

REM Vérifier que le fichier .env.docker existe
if not exist .env.docker (
    echo ❌ Erreur : Le fichier .env.docker n'existe pas
    echo 📝 Copie .env.docker depuis .env.example et configure-le
    pause
    exit /b 1
)

REM Vérifier que le mot de passe Supabase est configuré
findstr /C:"your_supabase_password_here" .env.docker >nul
if %errorlevel% equ 0 (
    echo ⚠️  ATTENTION : Le mot de passe Supabase n'est pas configuré !
    echo.
    echo 📝 Pour le récupérer :
    echo    1. Va sur https://supabase.com/dashboard/project/vtnqdcxaugstcxkmkpke
    echo    2. Settings ^> Database
    echo    3. Copie le mot de passe ou réinitialise-le
    echo    4. Modifie DB_PASSWORD dans .env.docker
    echo.
    set /p continue="Veux-tu continuer quand même ? (y/N) "
    if /i not "%continue%"=="y" exit /b 1
)

REM Vérifier que la clé de chiffrement est configurée
findstr /C:"your_random_encryption_key_here" .env.docker >nul
if %errorlevel% equ 0 (
    echo ⚠️  ATTENTION : La clé de chiffrement n'est pas configurée !
    echo.
    echo 📝 Tu peux générer une clé ici : https://generate-random.org/encryption-key-generator
    echo    Choisis 256-bit et copie la clé dans .env.docker ^(N8N_ENCRYPTION_KEY^)
    echo.
    pause
    exit /b 1
)

echo.
echo 📦 Démarrage du conteneur Docker...

REM Démarrer avec docker-compose
docker-compose --env-file .env.docker up -d

echo.
echo ✅ n8n est en cours de démarrage...
echo.
echo 📊 Pour voir les logs :
echo    docker-compose logs -f n8n
echo.
echo 🌐 Accède à n8n sur : http://localhost:5678
echo.
echo 🔑 Identifiants par défaut :
echo    Utilisateur : admin
echo    Mot de passe : admin123
echo.
echo ⚠️  Change le mot de passe après la première connexion !
echo.
echo 🛑 Pour arrêter n8n :
echo    docker-compose down
echo.
pause
