# Configuration Supabase pour n8n

## 🎯 Pourquoi Supabase ?

Utiliser Supabase comme base de données pour n8n offre plusieurs avantages :

- ✅ **Gratuit à vie** : 500 MB de stockage, pas de limite de temps
- ✅ **Backups automatiques** : Point-in-time recovery
- ✅ **Interface web** : Gérez vos données facilement
- ✅ **API REST automatique** : Accédez à vos données via API
- ✅ **Monitoring intégré** : Tableaux de bord et métriques
- ✅ **Sécurité** : SSL/TLS par défaut, Row Level Security
- ✅ **Pas de mise en veille** : Contrairement à Render Free

---

## 📦 Étape 1 : Créer un projet Supabase

### 1.1 Inscription

1. Allez sur [supabase.com](https://supabase.com)
2. Cliquez sur **"Start your project"**
3. Connectez-vous avec GitHub, Google ou email

### 1.2 Créer un nouveau projet

1. Cliquez sur **"New Project"**
2. Remplissez les informations :
   - **Name** : `n8n-database` (ou votre choix)
   - **Database Password** : Générez un mot de passe fort (sauvegardez-le !)
   - **Region** : Choisissez la plus proche (ex: `Europe West (Ireland)`)
   - **Pricing Plan** : Sélectionnez **Free**
3. Cliquez sur **"Create new project"**
4. Attendez 2-3 minutes que le projet soit créé

---

## 🔑 Étape 2 : Récupérer les informations de connexion

### 2.1 Accéder aux paramètres

1. Dans votre projet Supabase, cliquez sur l'icône **Settings** (⚙️) en bas à gauche
2. Allez dans **Database**
3. Scrollez jusqu'à **Connection string**

### 2.2 Informations nécessaires

Vous aurez besoin de ces informations :

```
Host: db.xxxxxxxxxxxxxx.supabase.co
Database: postgres
Port: 5432
User: postgres
Password: [le mot de passe que vous avez créé]
```

**Alternative : Connection String**

Vous pouvez aussi copier la **Connection String** complète :
```
postgresql://postgres:[YOUR-PASSWORD]@db.xxxxxxxxxxxxxx.supabase.co:5432/postgres
```

---

## ⚙️ Étape 3 : Configurer Render

### 3.1 Déployer sur Render

1. Cliquez sur le bouton **"Deploy to Render"** dans le README
2. Créez les ressources comme d'habitude

### 3.2 Configurer les variables d'environnement

Dans le dashboard Render, allez dans **Environment** et configurez :

| Variable | Valeur | Exemple |
|----------|--------|---------|
| `DB_POSTGRESDB_HOST` | Votre host Supabase | `db.xxxxxxxxxxxxxx.supabase.co` |
| `DB_POSTGRESDB_DATABASE` | `postgres` | `postgres` |
| `DB_POSTGRESDB_PORT` | `5432` | `5432` |
| `DB_POSTGRESDB_USER` | `postgres` | `postgres` |
| `DB_POSTGRESDB_PASSWORD` | Votre mot de passe Supabase | `votre_mot_de_passe` |

**Important** : Ces variables sont marquées `sync: false` dans `render.yaml`, vous devez les configurer manuellement.

### 3.3 Sauvegarder et redémarrer

1. Cliquez sur **"Save Changes"**
2. Attendez que le service redémarre (~1-2 minutes)
3. Vérifiez les logs pour confirmer la connexion

---

## ✅ Étape 4 : Vérifier la connexion

### 4.1 Vérifier les logs Render

Dans les logs, vous devriez voir :
```
Database connection successful
n8n ready on port 5678
```

### 4.2 Vérifier dans Supabase

1. Dans Supabase, allez dans **Table Editor**
2. Vous devriez voir les tables n8n créées automatiquement :
   - `credentials_entity`
   - `execution_entity`
   - `workflow_entity`
   - `webhook_entity`
   - etc.

### 4.3 Tester n8n

1. Accédez à votre instance n8n
2. Créez un workflow de test
3. Exécutez-le
4. Vérifiez dans Supabase > Table Editor > `execution_entity` que l'exécution est enregistrée

---

## 🔒 Sécurité Supabase

### Activer SSL (déjà configuré)

La configuration inclut déjà `DB_POSTGRESDB_SSL=true` pour une connexion sécurisée.

### Restreindre les accès

1. Dans Supabase, allez dans **Settings** > **Database**
2. Scrollez jusqu'à **Connection Pooling**
3. Notez l'IP de votre service Render
4. Ajoutez-la dans les restrictions si nécessaire

### Rotation du mot de passe

Pour changer le mot de passe de la base de données :

1. Dans Supabase : **Settings** > **Database** > **Reset database password**
2. Générez un nouveau mot de passe
3. Mettez à jour `DB_POSTGRESDB_PASSWORD` dans Render
4. Redémarrez le service

---

## 📊 Monitoring avec Supabase

### Tableau de bord

Supabase offre un tableau de bord complet :

1. **Database** : Taille, connexions actives, requêtes
2. **API** : Nombre de requêtes, latence
3. **Auth** : Utilisateurs (si vous utilisez Supabase Auth)
4. **Storage** : Utilisation du stockage

### Requêtes SQL personnalisées

Vous pouvez exécuter des requêtes SQL directement :

```sql
-- Voir le nombre de workflows
SELECT COUNT(*) FROM workflow_entity;

-- Voir les dernières exécutions
SELECT * FROM execution_entity 
ORDER BY "startedAt" DESC 
LIMIT 10;

-- Voir l'utilisation du stockage
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

---

## 💾 Backups

### Backups automatiques (Plan Free)

Supabase fait des backups automatiques :
- **Daily backups** : 7 jours de rétention
- **Point-in-time recovery** : Disponible sur plans payants

### Backup manuel

#### Via l'interface Supabase

1. Allez dans **Database** > **Backups**
2. Cliquez sur **"Download backup"**

#### Via pg_dump

```bash
# Installer PostgreSQL client
# Windows : https://www.postgresql.org/download/windows/
# Mac : brew install postgresql
# Linux : apt-get install postgresql-client

# Créer un backup
pg_dump -h db.xxxxxxxxxxxxxx.supabase.co \
  -U postgres \
  -d postgres \
  -F c \
  -f n8n_backup_$(date +%Y%m%d).dump

# Restaurer un backup
pg_restore -h db.xxxxxxxxxxxxxx.supabase.co \
  -U postgres \
  -d postgres \
  -c \
  n8n_backup_20260426.dump
```

---

## 🚀 Optimisations

### Connection Pooling

Pour de meilleures performances, utilisez le connection pooler de Supabase :

```yaml
# Dans render.yaml, utilisez le port 6543 au lieu de 5432
envVars:
  - key: DB_POSTGRESDB_PORT
    value: 6543
  - key: DB_POSTGRESDB_HOST
    value: db.xxxxxxxxxxxxxx.supabase.co  # Même host
```

### Indexes personnalisés

Créez des indexes pour améliorer les performances :

```sql
-- Dans Supabase SQL Editor
CREATE INDEX IF NOT EXISTS idx_workflow_active 
ON workflow_entity(active);

CREATE INDEX IF NOT EXISTS idx_execution_workflow_finished 
ON execution_entity(workflow_id, finished);

CREATE INDEX IF NOT EXISTS idx_execution_started_at 
ON execution_entity("startedAt" DESC);
```

### Nettoyage automatique

Le nettoyage est déjà configuré (7 jours), mais vous pouvez créer une fonction Supabase :

```sql
-- Fonction de nettoyage automatique
CREATE OR REPLACE FUNCTION cleanup_old_executions()
RETURNS void AS $$
BEGIN
  DELETE FROM execution_entity
  WHERE "stoppedAt" < NOW() - INTERVAL '7 days';
END;
$$ LANGUAGE plpgsql;

-- Créer un cron job (nécessite l'extension pg_cron sur plans payants)
-- SELECT cron.schedule('cleanup-executions', '0 2 * * *', 'SELECT cleanup_old_executions()');
```

---

## 💰 Limites du plan gratuit Supabase

### Quotas

- **Database** : 500 MB
- **Bandwidth** : 5 GB/mois
- **API Requests** : Illimité
- **Auth Users** : 50,000 MAU

### Que se passe-t-il si vous dépassez ?

- Le projet est mis en pause
- Vous recevez un email
- Vous pouvez upgrader vers un plan payant (25$/mois)

### Surveiller l'utilisation

1. Dashboard Supabase > **Settings** > **Billing**
2. Vérifiez régulièrement l'utilisation du stockage
3. Activez le nettoyage automatique des anciennes exécutions

---

## 🆘 Dépannage

### Erreur de connexion

```
Error: connect ECONNREFUSED
```

**Solutions** :
1. Vérifiez que toutes les variables sont correctement configurées
2. Vérifiez que le mot de passe ne contient pas de caractères spéciaux non échappés
3. Testez la connexion avec un client PostgreSQL

### Erreur SSL

```
Error: SSL connection required
```

**Solution** :
Assurez-vous que `DB_POSTGRESDB_SSL=true` est configuré.

### Timeout de connexion

```
Error: Connection timeout
```

**Solutions** :
1. Vérifiez que votre projet Supabase est actif (pas en pause)
2. Vérifiez la région (choisissez la plus proche de Render)
3. Utilisez le connection pooler (port 6543)

### Tables non créées

Si les tables n8n ne sont pas créées automatiquement :

```sql
-- Vérifiez les permissions
SELECT * FROM information_schema.table_privileges 
WHERE grantee = 'postgres';

-- Les tables devraient être créées automatiquement au premier démarrage
-- Si ce n'est pas le cas, vérifiez les logs Render
```

---

## 📚 Ressources

- [Documentation Supabase](https://supabase.com/docs)
- [Supabase Database](https://supabase.com/docs/guides/database)
- [Connection Pooling](https://supabase.com/docs/guides/database/connecting-to-postgres#connection-pooler)
- [n8n Database Configuration](https://docs.n8n.io/hosting/configuration/environment-variables/database/)

---

## 🎉 Avantages de cette configuration

✅ **Gratuit à vie** (dans les limites du plan free)  
✅ **Pas de limite de 90 jours** comme Render  
✅ **Interface de gestion** intuitive  
✅ **Backups automatiques**  
✅ **Monitoring intégré**  
✅ **Meilleure performance** avec connection pooling  
✅ **Évolutif** : facile d'upgrader si nécessaire  

Profitez de votre instance n8n avec Supabase ! 🚀
