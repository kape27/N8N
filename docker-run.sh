#!/bin/bash

# Script pour démarrer n8n avec Docker
# Usage: ./docker-run.sh

set -e

echo "🚀 Démarrage de n8n avec Docker..."
echo ""

# Vérifier que le fichier .env.docker existe
if [ ! -f .env.docker ]; then
    echo "❌ Erreur : Le fichier .env.docker n'existe pas"
    echo "📝 Copie .env.docker depuis .env.example et configure-le"
    exit 1
fi

# Vérifier que le mot de passe Supabase est configuré
if grep -q "your_supabase_password_here" .env.docker; then
    echo "⚠️  ATTENTION : Le mot de passe Supabase n'est pas configuré !"
    echo ""
    echo "📝 Pour le récupérer :"
    echo "   1. Va sur https://supabase.com/dashboard/project/vtnqdcxaugstcxkmkpke"
    echo "   2. Settings > Database"
    echo "   3. Copie le mot de passe ou réinitialise-le"
    echo "   4. Modifie DB_PASSWORD dans .env.docker"
    echo ""
    read -p "Veux-tu continuer quand même ? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Vérifier que la clé de chiffrement est configurée
if grep -q "your_random_encryption_key_here" .env.docker; then
    echo "⚠️  ATTENTION : La clé de chiffrement n'est pas configurée !"
    echo ""
    echo "📝 Génère une clé avec : openssl rand -base64 32"
    echo "   Et ajoute-la dans .env.docker (N8N_ENCRYPTION_KEY)"
    echo ""
    read -p "Veux-tu que je génère une clé automatiquement ? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ENCRYPTION_KEY=$(openssl rand -base64 32)
        # Remplacer dans .env.docker (compatible macOS et Linux)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/N8N_ENCRYPTION_KEY=.*/N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY/" .env.docker
        else
            sed -i "s/N8N_ENCRYPTION_KEY=.*/N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY/" .env.docker
        fi
        echo "✅ Clé générée et sauvegardée dans .env.docker"
    else
        exit 1
    fi
fi

echo ""
echo "📦 Démarrage du conteneur Docker..."

# Démarrer avec docker-compose
docker-compose --env-file .env.docker up -d

echo ""
echo "✅ n8n est en cours de démarrage..."
echo ""
echo "📊 Pour voir les logs :"
echo "   docker-compose logs -f n8n"
echo ""
echo "🌐 Accède à n8n sur : http://localhost:5678"
echo ""
echo "🔑 Identifiants par défaut :"
echo "   Utilisateur : admin"
echo "   Mot de passe : admin123"
echo ""
echo "⚠️  Change le mot de passe après la première connexion !"
echo ""
echo "🛑 Pour arrêter n8n :"
echo "   docker-compose down"
echo ""
