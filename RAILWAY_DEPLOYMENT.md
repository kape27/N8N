# 🚂 Déployer N8N sur Railway.app

## 🎯 Pourquoi Railway ?

Railway offre de bien meilleures ressources que Render :

| Fonctionnalité | Railway | Render Free |
|----------------|---------|-------------|
| **RAM** | 8 GB | 512 MB |
| **CPU** | Shared, meilleur | Shared, limité |
| **Coût** | 5$/mois | Gratuit (limité) |
| **Mise en veille** | ❌ Non | ✅ Oui (15 min) |
| **Performance** | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| **Build time** | Plus rapide | Plus lent |

**💰 Crédit gratuit** : Railway offre 5$ de crédit gratuit pour tester !

---

## 📦 Étape 1 : Créer un compte Railway

1. Allez sur https://railway.app
2. Cliquez sur **"Login"** puis **"Login with GitHub"**
3. Autorisez Railway à accéder à votre GitHub
4. Vous recevez **5$ de crédit gratuit** ! 🎉

---

## 🚀 Étape 2 : Déployer N8N

### Option A : Deploy depuis GitHub (Recommandé)

1. Dans Railway, cliquez sur **"New Project"**
2. Sélectionnez **"Deploy from GitHub repo"**
3. Choisissez votre repo : **kape27/N8N**
4. Railway va automatiquement :
   - ✅ Détecter le Dockerfile
   - ✅ Builder l'image
   - ✅ Déployer

### Option B : Deploy via Railway CLI

```cmd
# Installer Railway CLI
npm install -g @railway/cli

# Se connecter
railway login

# Dans le dossier N8N
cd C:\Users\PLC\Documents\N8N

# Initialiser et déployer
railway init
railway up
```

---

## ⚙️ Étape 3 : Configurer les Variables d'Environnement

Dans le dashboard Railway, allez dans **Variables** et ajoutez :

### 🗄️ Base de Données (Supabase)

```env
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=aws-0-eu-west-1.pooler.supabase.com
DB_POSTGRESDB_DATABASE=postgres
DB_POSTGRESDB_PORT=6543
DB_POSTGRESDB_USER=postgres.vtnqdcxaugstcxkmkpke
DB_POSTGRESDB_PASSWORD=Cypla2705.mbg
DB_POSTGRESDB_SSL=false
DB_POSTGRESDB_POOL_SIZE=10
```

### 🔧 Configuration N8N

```env
PORT=5678
N8N_PORT=5678
N8N_PROTOCOL=https
N8N_HOST=${{RAILWAY_PUBLIC_DOMAIN}}
WEBHOOK_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}
```

**Note** : `${{RAILWAY_PUBLIC_DOMAIN}}` est automatiquement remplacé par Railway

### 🔐 Authentification

```env
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=VotreMotDePasseSecurise123!
N8N_ENCRYPTION_KEY=e4QdZxpFQoTWIN1yI8cxc1RzmV65AaYUvx864QXe5dY=
```

### 🌍 Localisation

```env
GENERIC_TIMEZONE=Europe/Paris
TZ=Europe/Paris
N8N_DEFAULT_LOCALE=fr
N8N_LOG_LEVEL=warn
```

### ⚡ Performance

```env
N8N_DIAGNOSTICS_ENABLED=false
N8N_PERSONALIZATION_ENABLED=false
N8N_METRICS=false
N8N_CONCURRENCY_PRODUCTION_LIMIT=10
EXECUTIONS_TIMEOUT=300
EXECUTIONS_DATA_PRUNE=true
EXECUTIONS_DATA_MAX_AGE=24
QUEUE_HEALTH_CHECK_ACTIVE=false
```

---

## 🌐 Étape 4 : Générer le Domaine Public

1. Dans Railway, allez dans **Settings**
2. Section **Networking**
3. Cliquez sur **"Generate Domain"**
4. Railway crée une URL comme : `n8n-production.up.railway.app`
5. **Copiez cette URL** !

---

## 🔄 Étape 5 : Mettre à Jour les Variables

Retournez dans **Variables** et mettez à jour :

```env
N8N_HOST=n8n-production.up.railway.app
WEBHOOK_URL=https://n8n-production.up.railway.app
```

Cliquez sur **"Save"** - Railway va redéployer automatiquement.

---

## ✅ Étape 6 : Vérifier le Déploiement

1. Allez dans **Deployments**
2. Cliquez sur le dernier déploiement
3. Regardez les **Logs** :
   - Attendez : `Editor is now accessible via:`
   - Vérifiez qu'il n'y a pas d'erreurs

4. Accédez à votre URL : `https://n8n-production.up.railway.app`

### Identifiants :
- **Utilisateur** : admin
- **Mot de passe** : Le mot de passe que vous avez défini

---

## 💰 Coûts Railway

### Plan Gratuit (5$ de crédit)
- **Durée** : Environ 2-3 semaines avec n8n
- **RAM** : 8 GB
- **Pas de carte bancaire** requise pour commencer

### Plan Hobby (5$/mois)
- **Inclus** : 5$ de crédit/mois
- **RAM** : 8 GB
- **Parfait pour** : Usage personnel/petit business
- **Dépassement** : Pay-as-you-go (~0.50$/GB RAM supplémentaire)

### Estimation pour n8n
- **Usage typique** : 1-3$/mois
- **Usage intensif** : 3-5$/mois
- **Très abordable** comparé aux performances !

---

## 📊 Monitoring

Railway offre des outils de monitoring intégrés :

1. **Metrics** : CPU, RAM, Network
2. **Logs** : En temps réel
3. **Deployments** : Historique complet
4. **Observability** : Gratuit et puissant

---

## 🔄 Mise à Jour

### Auto-deploy depuis GitHub

Railway peut redéployer automatiquement à chaque push :

1. Dans **Settings** > **Triggers**
2. Activez **"Enable GitHub Auto Deploy"**
3. Choisissez la branche : `main`

Maintenant, chaque `git push` redéploie automatiquement ! 🚀

### Deploy manuel

```cmd
railway up
```

---

## 🆚 Comparaison : Railway vs Render vs Local

| Aspect | Railway | Render Free | Docker Local |
|--------|---------|-------------|--------------|
| **RAM** | 8 GB | 512 MB | Dépend de votre PC |
| **Performance** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ (Supabase lent) |
| **Coût** | 5$/mois | Gratuit | Gratuit |
| **Uptime** | 99.9% | 99% | Dépend du PC |
| **Mise en veille** | ❌ | ✅ (15 min) | ❌ |
| **Build time** | ~3 min | ~8 min | ~2 min |
| **Complexité** | Facile | Facile | Moyenne |

---

## 🎯 Recommandation

**Pour votre cas** (n8n 2.26.7 + Supabase) :

1. ✅ **Railway** : Meilleure option cloud
   - Performance excellente
   - Pas de problème de mémoire
   - Auto-deploy depuis GitHub
   - 5$ de crédit gratuit pour tester

2. ⚠️ **Render** : Trop limité
   - Out of memory fréquents
   - Mise en veille
   - Gratuit mais frustrant

3. 🏠 **Docker Local** : Développement uniquement
   - Lent avec Supabase distant
   - Pas accessible depuis Internet (sans ngrok)

---

## 🆘 Dépannage Railway

### Build échoue

Vérifiez les logs de build :
- Dockerfile correct ?
- Toutes les dépendances présentes ?

### Service crash au démarrage

1. Vérifiez les logs
2. Variables d'environnement correctes ?
3. Connexion Supabase OK ?

### "Out of memory"

Improbable avec 8GB, mais si ça arrive :
- Réduisez `N8N_CONCURRENCY_PRODUCTION_LIMIT`
- Réduisez `DB_POSTGRESDB_POOL_SIZE`

### Connexion DB timeout

- Utilisez le pooler Supabase (port 6543)
- SSL=false pour éviter les problèmes
- Augmentez le timeout si nécessaire

---

## 📚 Ressources

- [Documentation Railway](https://docs.railway.app)
- [Railway Discord](https://discord.gg/railway)
- [Railway Templates](https://railway.app/templates)
- [Railway CLI](https://docs.railway.app/develop/cli)

---

## 🎉 Avantages Railway pour N8N

✅ **8GB RAM** : n8n 2.x fonctionne parfaitement  
✅ **Pas de mise en veille** : Toujours disponible  
✅ **Build rapide** : 3-5 minutes au lieu de 8-10  
✅ **Auto-deploy** : Push = Deploy automatique  
✅ **Monitoring inclus** : Logs, metrics, alertes  
✅ **5$ gratuit** : Testez pendant 2-3 semaines  
✅ **Excellent rapport qualité/prix** : 5$/mois pour une vraie app cloud  

---

**Date** : 24 juin 2026  
**Version N8N** : 2.26.7  
**Repository** : https://github.com/kape27/N8N
