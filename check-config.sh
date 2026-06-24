#!/bin/bash

# Script de vérification de configuration pour n8n Docker
# Usage: ./check-config.sh

set -e

echo "🔍 Vérification de la configuration n8n..."
echo ""

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Fonction pour afficher les erreurs
error() {
    echo -e "${RED}❌ $1${NC}"
    ERRORS=$((ERRORS + 1))
}

# Fonction pour afficher les warnings
warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    WARNINGS=$((WARNINGS + 1))
}

# Fonction pour afficher les succès
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# 1. Vérifier Docker
echo "📦 Docker..."
if command -v docker &> /dev/null; then
    success "Docker est installé"
    
    # Vérifier que Docker est lancé
    if docker info &> /dev/null; then
        success "Docker est lancé"
    else
        error "Docker n'est pas lancé. Lance Docker Desktop"
    fi
else
    error "Docker n'est pas installé"
fi

# 2. Vérifier docker-compose
echo ""
echo "🔧 Docker Compose..."
if command -v docker-compose &> /dev/null; then
    success "Docker Compose est installé"
else
    error "Docker Compose n'est pas installé"
fi

# 3. Vérifier le fichier .env.docker
echo ""
echo "⚙️  Configuration..."
if [ -f .env.docker ]; then
    success "Fichier .env.docker existe"
    
    # Vérifier le mot de passe Supabase
    if grep -q "your_supabase_password_here" .env.docker; then
        error "Mot de passe Supabase non configuré dans .env.docker"
        echo "   → Édite .env.docker et remplace DB_PASSWORD"
        echo "   → Récupère-le sur : https://supabase.com/dashboard/project/vtnqdcxaugstcxkmkpke/settings/database"
    else
        success "Mot de passe Supabase configuré"
    fi
    
    # Vérifier la clé de chiffrement
    if grep -q "your_random_encryption_key_here" .env.docker; then
        warning "Clé de chiffrement non configurée"
        echo "   → Génère-la avec : openssl rand -base64 32"
        echo "   → Ou laisse le script docker-run.sh la générer"
    else
        success "Clé de chiffrement configurée"
    fi
    
    # Vérifier le mot de passe n8n
    if grep -q "N8N_PASSWORD=admin123" .env.docker; then
        warning "Mot de passe n8n par défaut (change-le après la première connexion)"
    else
        success "Mot de passe n8n personnalisé"
    fi
else
    error "Fichier .env.docker introuvable"
fi

# 4. Vérifier le fichier docker-compose.yml
echo ""
echo "🐳 Docker Compose..."
if [ -f docker-compose.yml ]; then
    success "Fichier docker-compose.yml existe"
    
    # Vérifier la syntaxe
    if docker-compose config &> /dev/null; then
        success "Syntaxe docker-compose.yml valide"
    else
        error "Erreur de syntaxe dans docker-compose.yml"
    fi
else
    error "Fichier docker-compose.yml introuvable"
fi

# 5. Vérifier le port 5678
echo ""
echo "🔌 Port 5678..."
if lsof -i :5678 &> /dev/null || netstat -an | grep :5678 | grep LISTEN &> /dev/null; then
    warning "Le port 5678 est déjà utilisé"
    echo "   → Change le port dans docker-compose.yml"
    echo "   → Ou arrête le processus qui l'utilise"
else
    success "Port 5678 disponible"
fi

# 6. Vérifier la connexion Supabase
echo ""
echo "🗄️  Connexion Supabase..."
echo "   Teste la connexion (nécessite psql)..."

if command -v psql &> /dev/null; then
    # Extraire le mot de passe
    DB_PASSWORD=$(grep "^DB_PASSWORD=" .env.docker | cut -d '=' -f2)
    
    if [ "$DB_PASSWORD" != "your_supabase_password_here" ] && [ -n "$DB_PASSWORD" ]; then
        # Tester la connexion
        if PGPASSWORD="$DB_PASSWORD" psql -h db.vtnqdcxaugstcxkmkpke.supabase.co -U postgres -d postgres -c "SELECT 1" &> /dev/null; then
            success "Connexion Supabase OK"
        else
            error "Impossible de se connecter à Supabase"
            echo "   → Vérifie le mot de passe dans .env.docker"
        fi
    else
        warning "Impossible de tester (mot de passe non configuré)"
    fi
else
    warning "psql non installé (skip test de connexion)"
fi

# Résumé
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}🎉 Configuration parfaite ! Tu peux démarrer n8n${NC}"
    echo ""
    echo "Commande : ./docker-run.sh"
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  $WARNINGS warning(s) - Tu peux démarrer mais vérifie les warnings${NC}"
    echo ""
    echo "Commande : ./docker-run.sh"
else
    echo -e "${RED}❌ $ERRORS erreur(s) à corriger avant de démarrer${NC}"
    echo ""
    echo "Corrige les erreurs ci-dessus puis relance : ./check-config.sh"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exit $ERRORS
