# Guide de Déploiement sur Render

## 🎯 Pourquoi Render ?

- ✅ **Performances** : Serveur en Europe (Frankfurt), proche de Supabase (Irlande)
- ✅ **Gratuit** : 750h/mois sur le plan free
- ✅ **HTTPS** : SSL automatique
- ✅ **Accessible partout** : URL publique
- ✅ **Pas de latence locale** : Plus de problèmes de connexion Supabase

---

## 📋 Méthode 1 : Déploiement via GitHub (Recommandé)

### Étape 1 : Créer un repo GitHub

1. Allez sur [github.com](https://github.com) et connectez-vous
2. Cliquez sur **"New repository"** (bouton vert)
3. Remplissez :
   - **Repository name** : `n8n-deployment` (ou votre choix)
   - **Visibility** : Public (ou Private si vous avez GitHub Pro)
4. **Ne pas** cocher "Add a README file"
5. Cliquez sur **"Create repository"**

### Étape 2 : Pousser votre code sur GitHub

```cmd
cd C:\Users\PLC\Documents\N8N

# Initialiser Git
git init

# Ajouter tous les fichiers
git add .

# Premier commit
git commit -m "Initial commit - n8n avec Supabase"

# Lier au repo GitHub (remplacez USERNAME par votre nom d'utilisateur GitHub)
git remote add origin https://github.com/USERNAME/n8n-deployment.git

# Renommer la branche en main
git branch -M main

# Pousser le code
git push -u origin main
```

**Note** : Si Git demande vos identifiants, utilisez :
- **Username** : Votre nom d'utilisateur GitHub
- **Password** : Un Personal Access Token (pas votre mot de passe) - [Créer un token](https://github.com/settings/tokens)

### Étape 3 : Déployer sur Render

1. Allez sur [render.com](https://render.com) et connectez-vous (ou créez un compte)
2. Cliquez sur **"New +"** > **"Blueprint"**
3. Connectez votre repo GitHub
4. Sélectionnez le repo `n8n-deployment`
5. Cliquez sur **"Apply"**

### Étape 4 : Configurer les variables Supabase

Dans le dashboard Render :

1. Cliquez sur votre service **n8n**
2. Allez dans **Environment**
3. Configurez ces variables :

```
DB_POSTGRESDB_HOST = aws-0-eu-west-1.pooler.supabase.com
DB_POSTGRESDB_USER = postgres.vtnqdcxaugstcxkmkpke
DB_POSTGRESDB_PASSWORD = Cypla2705.mbg
```

4. **Configurez l'URL** :
   - Copiez l'URL de votre service (en haut, lien violet)
   - Exemple : `https://n8n-xxxx.onrender.com`
   - Configurez :
     ```
     WEBHOOK_URL = https://n8n-xxxx.onrender.com
     N8N_HOST = n8n-xxxx.onrender.com
     ```

5. Cliquez sur **"Save Changes"**

### Étape 5 : Attendre le déploiement

- Le déploiement prend **5-10 minutes**
- Suivez les logs dans **"Logs"**
- Attendez le message : `n8n ready on port 5678`

### Étape 6 : Accéder à N8N

1. Cliquez sur l'URL en haut du dashboard
2. Connectez-vous avec :
   - **Utilisateur** : admin
   - **Mot de passe** : Récupérez-le dans Environment > `N8N_BASIC_AUTH_PASSWORD`

---

## 📋 Méthode 2 : Déploiement Direct (Sans GitHub)

Si vous ne voulez pas utiliser GitHub :

### Étape 1 : Créer le service manuellement

1. Allez sur [render.com](https://render.com)
2. Cliquez sur **"New +"** > **"Web Service"**
3. Sélectionnez **"Deploy an existing image from a registry"**
4. Image URL : `n8nio/n8n:2.26.7`
5. Région : **Frankfurt**
6. Plan : **Free**

### Étape 2 : Configurer les variables

Ajoutez toutes ces variables dans **Environment** :

```
# Database
DB_TYPE = postgresdb
DB_POSTGRESDB_HOST = aws-0-eu-west-1.pooler.supabase.com
DB_POSTGRESDB_DATABASE = postgres
DB_POSTGRESDB_PORT = 6543
DB_POSTGRESDB_USER = postgres.vtnqdcxaugstcxkmkpke
DB_POSTGRESDB_PASSWORD = Cypla2705.mbg
DB_POSTGRESDB_SSL = true

# n8n Configuration
PORT = 5678
N8N_PORT = 5678
N8N_PROTOCOL = https
WEBHOOK_URL = https://votre-url.onrender.com (à configurer après)
N8N_HOST = votre-url.onrender.com (à configurer après)

# Authentication
N8N_BASIC_AUTH_ACTIVE = true
N8N_BASIC_AUTH_USER = admin
N8N_BASIC_AUTH_PASSWORD = VotreMotDePasseSecurise123!

# Security
N8N_ENCRYPTION_KEY = e4QdZxpFQoTWIN1yI8cxc1RzmV65AaYUvx864QXe5dY=

# Localization
GENERIC_TIMEZONE = Europe/Paris
TZ = Europe/Paris
N8N_DEFAULT_LOCALE = fr

# Performance
N8N_LOG_LEVEL = warn
N8N_DIAGNOSTICS_ENABLED = false
N8N_PERSONALIZATION_ENABLED = false
N8N_METRICS = false
EXECUTIONS_DATA_PRUNE = true
EXECUTIONS_DATA_MAX_AGE = 24
```

### Étape 3 : Configurer le Health Check

Dans **Settings** :
- **Health Check Path** : `/healthz`

### Étape 4 : Déployer

1. Cliquez sur **"Create Web Service"**
2. Attendez le déploiement (5-10 minutes)
3. Récupérez votre URL et configurez `WEBHOOK_URL` et `N8N_HOST`
4. Sauvegardez et attendez le redémarrage

---

## 🎯 Avantages du Déploiement Render

| Aspect | Local (Docker) | Render Cloud |
|--------|----------------|--------------|
| **Performance** | ⭐⭐ (lent avec Supabase) | ⭐⭐⭐⭐⭐ |
| **Latence DB** | 400ms+ | < 50ms |
| **Accès** | Local uniquement | Partout |
| **HTTPS** | ❌ | ✅ |
| **Maintenance** | Manuelle | Automatique |
| **Coût** | Gratuit | Gratuit (750h/mois) |

---

## ⚠️ Limitations du Plan Gratuit Render

- **Mise en veille** : Après 15 min d'inactivité
- **Redémarrage** : ~30 secondes à la première requête
- **750 heures/mois** : Suffisant pour un usage personnel
- **Pas de domain custom** : Sur le plan free

---

## 🔄 Mise à Jour de l'Image

Pour mettre à jour vers une nouvelle version de n8n :

### Via GitHub (auto-deploy)
1. Modifiez `Dockerfile` avec la nouvelle version
2. Commitez et poussez
3. Render redéploie automatiquement

### Via Image Registry
1. Dans Render Dashboard > Settings
2. Changez l'image : `n8nio/n8n:NOUVELLE_VERSION`
3. Cliquez sur **"Save Changes"**

---

## 🆘 Dépannage

### Service ne démarre pas
- Vérifiez les logs dans **"Logs"**
- Vérifiez que toutes les variables sont configurées
- Vérifiez que le mot de passe Supabase est correct

### Erreur de connexion DB
- Utilisez le Connection Pooler : `aws-0-eu-west-1.pooler.supabase.com:6543`
- Format utilisateur : `postgres.PROJECT_ID`
- Vérifiez SSL=true

### Service en 503
- Normal pendant le démarrage (migrations DB)
- Attendez 2-3 minutes après le déploiement

---

## 📚 Ressources

- [Documentation Render](https://render.com/docs)
- [N8N Documentation](https://docs.n8n.io)
- [Support Render](https://render.com/docs/support)

---

**Date** : 23 juin 2026  
**Version N8N** : 2.26.7
