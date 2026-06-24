# 📋 Résumé de votre Configuration N8N

## ✅ Statut Actuel

### 🐳 Docker Local
- **URL** : http://localhost:5678
- **Version** : n8n 2.26.7
- **Base de données** : Supabase (Irlande) via Pooler
- **Statut** : ✅ En cours d'exécution
- **Performance** : ⚠️ Lente (latence réseau vers Supabase)

### ☁️ Render Cloud
- **URL** : https://n8n-ic76.onrender.com
- **Version** : n8n 2.26.7
- **Base de données** : Supabase (Irlande) via Pooler
- **Plan** : Free (512MB RAM)
- **Performance** : ⚠️ Lente (ressources limitées + latence Supabase)

### 🗄️ Base de Données
- **Provider** : Supabase
- **Région** : Europe West (Irlande)
- **Connexion** : Pooler (port 6543)
- **Host** : aws-0-eu-west-1.pooler.supabase.com
- **Utilisateur** : postgres.vtnqdcxaugstcxkmkpke

---

## 🎯 Les Deux Fonctionnent en Même Temps

✅ Vous pouvez utiliser :
- **Docker local** pour développer/tester (http://localhost:5678)
- **Render cloud** pour accéder depuis n'importe où (https://n8n-ic76.onrender.com)
- **Même base de données** : Les workflows sont synchronisés !

---

## ⚠️ Problème Actuel : LENTEUR

### Causes
1. **Latence réseau** : Supabase en Irlande = ~400ms depuis votre machine
2. **RAM limitée** : Plan Render Free = 512MB (insuffisant pour n8n 2.x)
3. **CPU partagé** : Render Free = ressources partagées

### Solutions

#### Solution 1 : PostgreSQL Local (Recommandé - Gratuit)
**Avantages** :
- ✅ Ultra rapide (latence < 5ms)
- ✅ Gratuit
- ✅ Fonctionne offline
- ✅ Même config pour Docker et peut être partagé avec Render

**Comment faire** :
```yaml
# Ajouter dans docker-compose.yml
services:
  postgres:
    image: postgres:15-alpine
    container_name: n8n-postgres
    environment:
      POSTGRES_USER: n8n
      POSTGRES_PASSWORD: n8n_secure_password
      POSTGRES_DB: n8n
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    restart: unless-stopped

  n8n:
    depends_on:
      - postgres
    environment:
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_USER=n8n
      - DB_POSTGRESDB_PASSWORD=n8n_secure_password
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_SSL=false

volumes:
  postgres_data:
  n8n_data:
```

#### Solution 2 : Upgrade Render ($7/mois)
- 512MB → 2GB RAM
- Plus rapide
- Pas de mise en veille

#### Solution 3 : Autres Hébergeurs
- **Railway.app** : 5$/mois, 8GB RAM
- **Fly.io** : Plus généreux que Render
- **VPS Hetzner** : 4€/mois, 4GB RAM

---

## 📊 Comparaison des Options

| Solution | Coût | Performance Local | Performance Cloud | Complexité |
|----------|------|-------------------|-------------------|------------|
| **Supabase actuel** | Gratuit | ⭐⭐ | ⭐⭐ | Facile |
| **PostgreSQL local** | Gratuit | ⭐⭐⭐⭐⭐ | ❌ | Moyenne |
| **Render Starter** | 7$/mois | ⭐⭐ | ⭐⭐⭐⭐ | Facile |
| **PostgreSQL local + Render** | 7$/mois | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Moyenne |

---

## 🔧 Commandes Utiles

### Docker Local
```cmd
# Démarrer
docker-compose --env-file .env.docker up -d

# Arrêter
docker-compose --env-file .env.docker down

# Voir les logs
docker logs n8n -f

# Redémarrer
docker-compose --env-file .env.docker restart

# Reconstruire l'image
docker-compose --env-file .env.docker build --no-cache
```

### Git/Render
```cmd
# Pousser les changements
git add .
git commit -m "Description"
git push origin main

# Render redéploie automatiquement après chaque push
```

---

## 📝 Identifiants

### Docker Local
- **URL** : http://localhost:5678
- **Utilisateur** : admin
- **Mot de passe** : admin123

### Render Cloud
- **URL** : https://n8n-ic76.onrender.com
- **Utilisateur** : admin
- **Mot de passe** : Voir dans Render Dashboard > Environment > `N8N_BASIC_AUTH_PASSWORD`

---

## 🚀 Recommandation

Pour une **meilleure expérience** :

1. **Court terme** : Continuez avec la config actuelle (fonctionne mais lent)

2. **Moyen terme** : Ajoutez PostgreSQL local pour Docker
   - Ultra rapide pour le développement
   - Gardez Render pour l'accès distant

3. **Long terme** : Si vous utilisez beaucoup, upgrade Render à 7$/mois
   - Meilleure expérience cloud
   - Pas de mise en veille

---

**Date** : 24 juin 2026  
**Version N8N** : 2.26.7  
**Repository** : https://github.com/kape27/N8N
