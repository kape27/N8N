# Guide d'Optimisation des Performances N8N

## 🐌 Problème : N8N est trop lent

### Causes Identifiées

1. **Latence réseau** : Supabase en Irlande (eu-west-1) → ~400ms de latence
2. **Timeouts de base de données** : Connexions lentes et instables
3. **Télémétrie PostHog** : Ralentit l'interface
4. **Logs verbeux** : Impact sur les performances

---

## ✅ Optimisations Appliquées

### 1. **Configuration de la Base de Données**

```yaml
# Pool de connexions optimisé
DB_POSTGRESDB_POOL_SIZE=10

# Utilisation du Connection Pooler (port 6543)
# Plus stable que la connexion directe (port 5432)
```

### 2. **Désactivation de la Télémétrie**

```yaml
# PostHog analytics (ralentit l'interface)
N8N_DIAGNOSTICS_ENABLED=false
N8N_PERSONALIZATION_ENABLED=false
N8N_METRICS=false
```

### 3. **Optimisation des Logs**

```yaml
# Réduire le niveau de log
N8N_LOG_LEVEL=warn  # Au lieu de 'info'
```

### 4. **Nettoyage Automatique Plus Agressif**

```yaml
# Nettoyer les exécutions après 24h au lieu de 168h
EXECUTIONS_DATA_MAX_AGE=24
```

### 5. **Ressources Docker**

```yaml
deploy:
  resources:
    limits:
      memory: 2G      # Limite max
    reservations:
      memory: 512M    # Réservé minimum
```

---

## 🚀 Optimisations Supplémentaires Possibles

### Option 1 : Utiliser une Base de Données Locale

**Avantages** :
- ✅ Latence quasi-nulle
- ✅ Pas de dépendance réseau
- ✅ Performances maximales

**Inconvénients** :
- ❌ Pas de backup automatique
- ❌ Données uniquement locales
- ❌ Configuration supplémentaire

**Comment faire** :

```yaml
# docker-compose.yml - ajouter un service PostgreSQL
services:
  postgres:
    image: postgres:15-alpine
    container_name: n8n-postgres
    environment:
      - POSTGRES_USER=n8n
      - POSTGRES_PASSWORD=n8n_password
      - POSTGRES_DB=n8n
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
  
  n8n:
    # ...
    depends_on:
      - postgres
    environment:
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_USER=n8n
      - DB_POSTGRESDB_PASSWORD=n8n_password
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_SSL=false

volumes:
  postgres_data:
  n8n_data:
```

### Option 2 : Augmenter les Ressources Docker Desktop

1. Ouvrir **Docker Desktop**
2. **Settings** > **Resources**
3. Augmenter :
   - **CPUs** : 4+ cores
   - **Memory** : 6+ GB
   - **Disk** : 50+ GB
4. Cliquer sur **Apply & Restart**

### Option 3 : Désactiver les Fonctionnalités Non Utilisées

```yaml
# Désactiver les Task Runners (si non utilisés)
N8N_RUNNERS_DISABLED=true

# Désactiver les webhooks de test
N8N_SKIP_WEBHOOK_DEREGISTRATION_SHUTDOWN=true

# Mode production
NODE_ENV=production
```

### Option 4 : Utiliser un CDN Local pour les Assets

Si votre connexion Internet est lente, N8N charge des assets externes qui ralentissent l'interface.

---

## 🔍 Diagnostics de Performance

### Vérifier la latence de la base de données

```cmd
docker exec n8n sh -c "time nc -zv aws-0-eu-west-1.pooler.supabase.com 6543"
```

**Bon** : < 100ms  
**Acceptable** : 100-300ms  
**Problématique** : > 300ms

### Monitorer l'utilisation des ressources

```cmd
docker stats n8n --no-stream
```

### Vérifier les logs pour les timeouts

```cmd
docker logs n8n | findstr /C:"timeout" /C:"slow" /C:"failed"
```

---

## 📊 Comparaison des Solutions

| Solution | Performance | Complexité | Backup | Coût |
|----------|------------|-----------|--------|------|
| **Supabase (actuel)** | ⭐⭐ | Facile | ✅ Auto | Gratuit |
| **PostgreSQL local** | ⭐⭐⭐⭐⭐ | Moyenne | ❌ Manuel | Gratuit |
| **SQLite** | ⭐⭐⭐⭐ | Facile | ⚠️ Fichier | Gratuit |
| **Augmenter ressources** | ⭐⭐⭐ | Facile | - | Gratuit |

---

## 🎯 Recommandation

**Pour votre cas** (développement local avec lenteur) :

1. **Court terme** : Les optimisations sont déjà appliquées ✅
2. **Moyen terme** : Passer à PostgreSQL local pour des performances maximales
3. **Long terme** : Si vous déployez en production, utiliser un provider proche géographiquement

---

## 🔄 Appliquer les Changements

```cmd
# Redémarrer avec les nouvelles optimisations
docker-compose --env-file .env.docker down
docker-compose --env-file .env.docker up -d

# Vérifier les performances
docker stats n8n --no-stream
```

---

## 📝 Notes Importantes

- **Cache du navigateur** : Vider le cache améliore souvent les performances (Ctrl + Shift + R)
- **Navigation privée** : Tester en mode incognito pour éliminer les problèmes de cache
- **Extensions du navigateur** : Désactiver les extensions qui peuvent ralentir (bloqueurs de pub, etc.)

---

**Date** : 23 juin 2026  
**Version N8N** : 2.26.7
