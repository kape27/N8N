# Configuration Avancée

## 🚀 Optimisations et configurations avancées pour n8n sur Render

### 1. Multi-région

#### Déployer dans plusieurs régions

Pour une meilleure disponibilité et performance :

```yaml
# render.yaml
services:
  - type: web
    name: n8n-eu
    region: frankfurt
    # ... reste de la config

  - type: web
    name: n8n-us
    region: oregon
    # ... reste de la config
```

#### Load balancing
Utilisez un service comme Cloudflare pour distribuer le trafic entre régions.

### 2. Scaling

#### Augmenter les ressources

```yaml
# render.yaml
services:
  - type: web
    plan: standard  # Plus de CPU et RAM
    # ou
    plan: pro       # Encore plus de ressources
```

#### Auto-scaling (plans Pro+)

```yaml
services:
  - type: web
    autoDeploy: true
    scaling:
      minInstances: 1
      maxInstances: 5
      targetCPUPercent: 70
```

### 3. Base de données optimisée

#### Plan PostgreSQL performant

```yaml
databases:
  - name: n8nDB
    plan: standard  # 7$/mois, plus de stockage et connexions
    # ou
    plan: pro       # 20$/mois, haute performance
```

#### Connection pooling

```yaml
envVars:
  - key: DB_POSTGRESDB_POOL_SIZE
    value: 10
  - key: DB_POSTGRESDB_POOL_MIN
    value: 2
```

#### Indexes personnalisés

Connectez-vous à votre base et créez des indexes :

```sql
-- Améliore les performances des requêtes d'exécution
CREATE INDEX idx_execution_workflow_id ON execution_entity(workflow_id);
CREATE INDEX idx_execution_finished ON execution_entity(finished);
CREATE INDEX idx_execution_started_at ON execution_entity(started_at);
```

### 4. Variables d'environnement avancées

#### Performance

```yaml
envVars:
  # Nombre de workflows exécutés en parallèle
  - key: N8N_CONCURRENCY_PRODUCTION_LIMIT
    value: 10
  
  # Timeout des exécutions (en secondes)
  - key: EXECUTIONS_TIMEOUT
    value: 300
  
  # Timeout des requêtes HTTP (en millisecondes)
  - key: N8N_DEFAULT_TIMEOUT
    value: 30000
```

#### Sécurité avancée

```yaml
envVars:
  # Désactiver l'interface publique (API uniquement)
  - key: N8N_DISABLE_UI
    value: false
  
  # JWT pour l'authentification
  - key: N8N_JWT_AUTH_ACTIVE
    value: true
  - key: N8N_JWT_AUTH_HEADER
    value: Authorization
  - key: N8N_JWKS_URI
    value: https://your-auth-provider.com/.well-known/jwks.json
  
  # CORS
  - key: N8N_CORS_ORIGIN
    value: https://your-frontend.com
```

#### Monitoring

```yaml
envVars:
  # Métriques Prometheus
  - key: N8N_METRICS
    value: true
  - key: N8N_METRICS_PREFIX
    value: n8n_
  
  # Sentry pour le tracking d'erreurs
  - key: N8N_SENTRY_DSN
    value: https://your-sentry-dsn
```

### 5. Webhooks avancés

#### Configuration personnalisée

```yaml
envVars:
  # Chemin personnalisé pour les webhooks
  - key: N8N_PATH
    value: /automation/
  
  # Webhooks de test séparés
  - key: N8N_WEBHOOK_TEST_URL
    value: https://test.your-domain.com
  
  # Webhooks de production
  - key: WEBHOOK_URL
    value: https://prod.your-domain.com
```

#### Sécurité des webhooks

```javascript
// Dans vos workflows, ajoutez une validation
const crypto = require('crypto');

function validateWebhook(body, signature, secret) {
  const hash = crypto
    .createHmac('sha256', secret)
    .update(JSON.stringify(body))
    .digest('hex');
  
  return hash === signature;
}

// Utilisez dans un Function node
if (!validateWebhook($input.item.json, $input.item.json.signature, 'YOUR_SECRET')) {
  throw new Error('Invalid signature');
}
```

### 6. Domaine personnalisé

#### Configuration DNS

```bash
# Ajoutez un enregistrement CNAME dans votre DNS
CNAME n8n your-service.onrender.com
```

#### Dans Render

```bash
# Dashboard > Service > Settings > Custom Domain
# Ajoutez : n8n.your-domain.com
```

#### SSL automatique

Render génère automatiquement un certificat SSL Let's Encrypt.

### 7. Backup et restauration

#### Script de backup automatique

```bash
#!/bin/bash
# backup-n8n.sh

# Variables
RENDER_API_KEY="your_api_key"
SERVICE_ID="your_service_id"
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)

# Créer le dossier de backup
mkdir -p $BACKUP_DIR

# Exporter les workflows via l'API n8n
curl -X GET \
  https://your-instance.onrender.com/api/v1/workflows \
  -H "X-N8N-API-KEY: $N8N_API_KEY" \
  -o "$BACKUP_DIR/workflows_$DATE.json"

# Backup de la base de données (via Render API)
curl -X POST \
  "https://api.render.com/v1/services/$SERVICE_ID/backups" \
  -H "Authorization: Bearer $RENDER_API_KEY"

echo "Backup completed: $DATE"
```

#### Automatisation avec GitHub Actions

```yaml
# .github/workflows/backup.yml
name: Backup n8n

on:
  schedule:
    - cron: '0 2 * * *'  # Tous les jours à 2h du matin

jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Backup workflows
        run: |
          curl -X GET \
            ${{ secrets.N8N_URL }}/api/v1/workflows \
            -H "X-N8N-API-KEY: ${{ secrets.N8N_API_KEY }}" \
            -o workflows_backup.json
      
      - name: Upload to S3
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: eu-west-1
      
      - run: |
          aws s3 cp workflows_backup.json \
            s3://your-bucket/backups/$(date +%Y%m%d)/
```

### 8. Monitoring avancé

#### Healthcheck personnalisé

```yaml
# render.yaml
services:
  - type: web
    healthCheckPath: /healthz
    healthCheckInterval: 30
    healthCheckTimeout: 10
```

#### Alertes Render

```bash
# Dashboard > Service > Notifications
# Configurez des alertes pour :
# - Deploy failures
# - Health check failures
# - High CPU/Memory usage
```

#### Monitoring externe

```javascript
// Script de monitoring (à exécuter via cron)
const axios = require('axios');

async function checkHealth() {
  try {
    const response = await axios.get('https://your-instance.onrender.com/healthz');
    
    if (response.status !== 200) {
      // Envoyer une alerte (email, Slack, etc.)
      await sendAlert('n8n health check failed');
    }
  } catch (error) {
    await sendAlert(`n8n is down: ${error.message}`);
  }
}

setInterval(checkHealth, 60000); // Toutes les minutes
```

### 9. CI/CD

#### Déploiement automatique

```yaml
# .github/workflows/deploy.yml
name: Deploy to Render

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Trigger Render deploy
        run: |
          curl -X POST \
            "https://api.render.com/v1/services/${{ secrets.RENDER_SERVICE_ID }}/deploys" \
            -H "Authorization: Bearer ${{ secrets.RENDER_API_KEY }}" \
            -H "Content-Type: application/json" \
            -d '{"clearCache": false}'
```

#### Tests avant déploiement

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Build Docker image
        run: docker build -t n8n-test .
      
      - name: Run tests
        run: |
          docker run -d -p 5678:5678 n8n-test
          sleep 30
          curl -f http://localhost:5678/healthz || exit 1
```

### 10. Intégrations avancées

#### Redis pour le cache (plans payants)

```yaml
# render.yaml
services:
  - type: redis
    name: n8n-cache
    plan: starter

  - type: web
    name: n8n
    envVars:
      - key: QUEUE_BULL_REDIS_HOST
        fromService:
          name: n8n-cache
          type: redis
          property: host
```

#### S3 pour le stockage de fichiers

```yaml
envVars:
  - key: N8N_BINARY_DATA_MODE
    value: filesystem
  - key: N8N_BINARY_DATA_TTL
    value: 60
  
  # Ou utilisez S3
  - key: N8N_BINARY_DATA_MODE
    value: s3
  - key: N8N_BINARY_DATA_S3_BUCKET
    value: your-bucket-name
  - key: AWS_ACCESS_KEY_ID
    value: your-access-key
  - key: AWS_SECRET_ACCESS_KEY
    value: your-secret-key
```

### 11. Mode Queue (haute disponibilité)

Pour les charges importantes :

```yaml
# Service principal
services:
  - type: web
    name: n8n-main
    envVars:
      - key: EXECUTIONS_MODE
        value: queue
      - key: QUEUE_BULL_REDIS_HOST
        value: your-redis-host

# Workers
  - type: worker
    name: n8n-worker
    dockerCommand: n8n worker
    envVars:
      - key: EXECUTIONS_MODE
        value: queue
      - key: QUEUE_BULL_REDIS_HOST
        value: your-redis-host
```

### 12. Logs centralisés

#### Intégration avec services externes

```yaml
envVars:
  # Logstash
  - key: N8N_LOG_OUTPUT
    value: json
  
  # Datadog
  - key: DD_API_KEY
    value: your-datadog-key
  - key: DD_SITE
    value: datadoghq.eu
```

## 📚 Ressources

- [n8n Advanced Configuration](https://docs.n8n.io/hosting/configuration/)
- [Render Advanced Features](https://render.com/docs/advanced)
- [PostgreSQL Optimization](https://www.postgresql.org/docs/current/performance-tips.html)

---

**Ces configurations sont pour des cas d'usage avancés. Testez toujours sur une instance de staging !** ⚡
