# n8n-render (easy mode)

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy)

## 🚀 Qu'est-ce que n8n ?

**n8n** est une plateforme d'automatisation de workflows open-source et extensible. Elle vous permet de connecter différentes applications et services pour automatiser vos tâches répétitives, sans avoir besoin de coder (ou avec du code si vous le souhaitez).

### ✨ Fonctionnalités principales
- 🔗 Plus de 400 intégrations natives
- 🎨 Interface visuelle intuitive
- 🔒 Auto-hébergé (vos données restent chez vous)
- 💻 Possibilité d'ajouter du code JavaScript
- 🔄 Workflows conditionnels et complexes
- 📊 Historique d'exécution détaillé

---

## 📦 Installation

Tu as **deux options** pour déployer n8n :

### Option 1 : Déploiement sur Render (Cloud, Gratuit)
Idéal pour un accès depuis n'importe où, sans gérer de serveur.

### Option 2 : Déploiement Docker Local (Gratuit)
Idéal pour un contrôle total et des tests en local.
📖 **[Guide complet Docker](docs/DOCKER_DEPLOYMENT.md)**

---

## 🌐 Option 1 : Installation sur Render.com

### Prérequis : Créer une base de données Supabase

**Cette configuration utilise Supabase comme base de données (gratuit à vie !)**

📖 **[Guide complet de configuration Supabase](docs/SUPABASE_SETUP.md)**

**Résumé rapide** :
1. Créez un compte sur [supabase.com](https://supabase.com)
2. Créez un nouveau projet (plan Free)
3. Notez les informations de connexion (host, password)

### Étapes d'installation

1. **Cliquez sur le bouton "Deploy to Render"** ci-dessus
2. Choisissez un nom pour votre blueprint (ex: "n8n")
3. Cliquez sur **"Create New Resources"**
4. Cliquez sur **"Apply"**
5. **Configurez la base de données Supabase** :
   - Allez dans Dashboard > n8n (votre service) > Environment
   - Configurez ces variables avec vos informations Supabase :
     - `DB_POSTGRESDB_HOST` : `db.xxxxxx.supabase.co`
     - `DB_POSTGRESDB_USER` : `postgres`
     - `DB_POSTGRESDB_PASSWORD` : votre mot de passe Supabase
   - Sauvegardez les changements
6. **Configurez l'URL des webhooks** :
   - Copiez l'URL de votre service (lien violet dans l'en-tête)
   - Collez cette URL comme valeur pour `WEBHOOK_URL` et `N8N_HOST`
   - Sauvegardez les changements
7. **Récupérez vos identifiants** :
   - Dans Environment, cherchez `N8N_BASIC_AUTH_PASSWORD`
   - Notez le mot de passe généré automatiquement
   - Nom d'utilisateur par défaut : `admin`
8. Attendez 1-2 minutes que l'instance redémarre
9. **Connectez-vous et profitez !** 🎉

---

## 🔒 Sécurité

Cette configuration inclut :
- ✅ **Authentification basique activée** par défaut
- ✅ **Clé de chiffrement** générée automatiquement
- ✅ **HTTPS** activé
- ✅ **Mot de passe** généré aléatoirement
- ✅ **Connexion SSL** à Supabase

**⚠️ Important** : Changez le mot de passe après la première connexion !

---

## 💰 Tarification

### Avec Supabase (recommandé)

- **Gratuit à vie** ! 🎉
  - Service Render : Gratuit (750h/mois)
  - Base de données Supabase : Gratuit (500 MB)
- **Pas de limite de 90 jours**
- **Backups automatiques inclus**

### Limites du plan gratuit

**Render** :
- Service en veille après 15 minutes d'inactivité
- Redémarrage automatique à la première requête (~30 secondes)
- 750 heures d'exécution par mois

**Supabase** :
- 500 MB de stockage
- 5 GB de bande passante/mois
- Requêtes API illimitées

---

## ⚙️ Configuration

### Variables d'environnement principales

| Variable | Description | Valeur par défaut |
|----------|-------------|-------------------|
| `DB_POSTGRESDB_HOST` | Host Supabase | À configurer |
| `DB_POSTGRESDB_USER` | Utilisateur DB | `postgres` |
| `DB_POSTGRESDB_PASSWORD` | Mot de passe DB | À configurer |
| `N8N_BASIC_AUTH_USER` | Nom d'utilisateur | `admin` |
| `N8N_BASIC_AUTH_PASSWORD` | Mot de passe | Généré automatiquement |
| `GENERIC_TIMEZONE` | Fuseau horaire | `Europe/Paris` |
| `N8N_DEFAULT_LOCALE` | Langue de l'interface | `fr` |
| `WEBHOOK_URL` | URL pour les webhooks | À configurer manuellement |

### Personnalisation

Vous pouvez modifier ces valeurs dans le dashboard Render :
- **Région** : Frankfurt par défaut (modifiable dans `render.yaml`)
- **Timezone** : Europe/Paris (modifiable)
- **Locale** : Français (modifiable)

---

## 🔧 Maintenance

### Mise à jour de n8n

1. Modifiez la version dans le `Dockerfile`
2. Commitez et poussez les changements
3. Render redéploiera automatiquement

### Sauvegardes

- **Supabase** : Backups automatiques quotidiens (7 jours de rétention)
- **Workflows** : Exportez régulièrement (Settings > Export)
- 📖 [Guide complet des backups](docs/SUPABASE_SETUP.md#-backups)

### Nettoyage automatique

- Les anciennes exécutions sont supprimées après **7 jours** (168 heures)
- Modifiable via `EXECUTIONS_DATA_MAX_AGE`

---

## 🐳 Option 2 : Installation Docker Locale

### Démarrage rapide

1. **Récupère ton mot de passe Supabase** (voir SUPABASE_CREDENTIALS.md)
2. **Configure `.env.docker`** avec tes credentials
3. **Démarre n8n** :

**Windows** :
```cmd
docker-run.bat
```

**Linux/Mac** :
```bash
chmod +x docker-run.sh
./docker-run.sh
```

4. **Accède à n8n** : http://localhost:5678

📖 **[Guide complet Docker](docs/DOCKER_DEPLOYMENT.md)** avec :
- Installation détaillée
- Exposition sur internet (ngrok, Cloudflare)
- Monitoring et optimisations
- Dépannage

---

## 📚 Documentation

- 🐳 **[Déploiement Docker](docs/DOCKER_DEPLOYMENT.md)** - Guide complet pour Docker local
- 📖 **[Configuration Supabase](docs/SUPABASE_SETUP.md)** - Guide complet pour configurer Supabase
- 🔒 **[Guide de Sécurité](docs/SECURITY.md)** - Bonnes pratiques et sécurisation
- 🔧 **[Dépannage](docs/TROUBLESHOOTING.md)** - Solutions aux problèmes courants
- ⚡ **[Configuration Avancée](docs/ADVANCED.md)** - Optimisations et fonctionnalités avancées

---

## 📚 FAQ

### Pourquoi Supabase au lieu de Render Database ?

- ✅ Gratuit à vie (pas de limite de 90 jours)
- ✅ Interface de gestion intuitive
- ✅ Backups automatiques
- ✅ Monitoring intégré
- ✅ Plus de fonctionnalités (API REST, Auth, Storage)

### Comment accéder à mon instance ?
Votre URL est visible dans le dashboard Render (lien violet en haut de la page du service).

### Mon service ne répond pas
Le plan gratuit met le service en veille après 15 minutes. Attendez ~30 secondes au premier accès.

### Comment changer le mot de passe ?
Modifiez la variable `N8N_BASIC_AUTH_PASSWORD` dans les Environment Variables.

### Puis-je utiliser un nom de domaine personnalisé ?
Oui ! Render permet d'ajouter des domaines personnalisés dans les paramètres du service.

### Comment voir les logs ?
Dans le dashboard Render, cliquez sur votre service puis sur l'onglet "Logs".

### Comment gérer ma base de données ?
Connectez-vous à [supabase.com](https://supabase.com) et accédez au Table Editor pour voir vos données n8n.

---

## 🆘 Support

- [Documentation officielle n8n](https://docs.n8n.io/)
- [Forum communautaire n8n](https://community.n8n.io/)
- [Documentation Render](https://render.com/docs)
- [Documentation Supabase](https://supabase.com/docs)

---

## 📝 Changelog

### Version 2.1 (2026-04-26)
- ✅ Migration vers Supabase (gratuit à vie !)
- ✅ Guide complet de configuration Supabase
- ✅ Connexion SSL activée
- ✅ Documentation enrichie

### Version 2.0 (2026)
- ✅ Authentification activée par défaut
- ✅ Version fixe de n8n (1.68.0)
- ✅ Health checks améliorés
- ✅ Nettoyage automatique des anciennes exécutions
- ✅ Documentation enrichie

### Version 1.0
- 🎉 Version initiale

---

## 👥 Crédits

Créé par **Antoine Deschamps** pour **La Machine**  
Inspiré par ready4mars  
Amélioré par la communauté

---

## 📄 Licence

MIT License - Libre d'utilisation et de modification
