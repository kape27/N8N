# Guide de Mise à Jour N8N

## Version Actuelle → Nouvelle Version
- **Actuelle** : 1.68.0
- **Cible** : 2.26.7 (latest)

## ⚠️ Important : N8N 2.0 - Breaking Changes

La mise à jour vers n8n 2.0 inclut des **changements majeurs** :
- Améliorations de sécurité importantes
- Nouvelle interface utilisateur
- Nettoyage des fonctionnalités dépréciées
- Vulnérabilités de sécurité corrigées (versions 1.65-1.120.4 avaient des failles critiques)

**Documentation officielle** : https://docs.n8n.io/2-0-breaking-changes/

---

## 📋 Étapes de Mise à Jour

### 1. Backup de votre instance

```cmd
# Exporter tous vos workflows
# À faire manuellement dans l'interface N8N : Settings > Export

# Backup de la base de données Supabase
# Supabase fait des backups automatiques quotidiens (7 jours de rétention)
# Vous pouvez aussi faire un backup manuel via le dashboard Supabase
```

### 2. Arrêter N8N

```cmd
docker-compose --env-file .env.docker down
```

### 3. Mettre à jour le fichier docker-compose.yml

Changer la version de l'image de `n8nio/n8n:1.68.0` vers `n8nio/n8n:2.26.7` (ou `n8nio/n8n:latest`)

### 4. Télécharger la nouvelle image

```cmd
docker pull n8nio/n8n:2.26.7
```

### 5. Redémarrer N8N

```cmd
docker-compose --env-file .env.docker up -d
```

### 6. Vérifier les migrations

```cmd
docker logs -f n8n
```

Les migrations de la base de données se feront automatiquement. **Ne pas interrompre le processus !**

### 7. Tester votre instance

- Accéder à http://localhost:5678
- Vérifier que vos workflows fonctionnent
- Tester l'exécution d'un workflow

---

## 🔄 Rollback (si nécessaire)

Si vous rencontrez des problèmes :

```cmd
# 1. Arrêter N8N
docker-compose --env-file .env.docker down

# 2. Revenir à l'ancienne version
# Modifier docker-compose.yml pour remettre version 1.68.0

# 3. Redémarrer
docker-compose --env-file .env.docker up -d
```

**Note** : Les migrations de base de données peuvent rendre le rollback difficile. C'est pourquoi le backup est crucial !

---

## 📚 Ressources

- [N8N 2.0 Breaking Changes](https://docs.n8n.io/2-0-breaking-changes/)
- [Release Notes](https://docs.n8n.io/reference/release-notes.html)
- [GitHub Releases](https://github.com/n8n-io/n8n/releases)

---

**Date de mise à jour** : 23 juin 2026
