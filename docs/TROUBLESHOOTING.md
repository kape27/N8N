# Guide de Dépannage

## 🔧 Problèmes courants et solutions

### 1. Le service ne démarre pas

#### Symptômes
- Erreur 503 ou 502
- "Service Unavailable"
- Le service redémarre en boucle

#### Solutions

**A. Vérifiez les logs**
```bash
# Dans le dashboard Render :
# 1. Cliquez sur votre service
# 2. Onglet "Logs"
# 3. Cherchez les erreurs
```

**B. Vérifiez les variables d'environnement**
- `WEBHOOK_URL` et `N8N_HOST` doivent être configurés
- `DB_POSTGRESDB_*` doivent pointer vers votre base de données
- `N8N_ENCRYPTION_KEY` doit être défini

**C. Vérifiez la base de données**
- La base de données est-elle active ?
- Les credentials sont-ils corrects ?
- Y a-t-il des erreurs de connexion dans les logs ?

### 2. Le service est lent ou ne répond pas

#### Symptômes
- Temps de chargement très long (>30 secondes)
- Timeouts fréquents
- Interface qui ne charge pas

#### Solutions

**A. Plan gratuit - Service en veille**
C'est normal ! Le plan gratuit met le service en veille après 15 minutes d'inactivité.
- Premier accès : ~30 secondes de démarrage
- Accès suivants : instantané
- Solution : passez à un plan payant pour éviter la mise en veille

**B. Workflows lourds**
```javascript
// Optimisez vos workflows :
// - Limitez les boucles
// - Utilisez des filtres en amont
// - Évitez les requêtes inutiles
```

**C. Base de données saturée**
- Vérifiez l'utilisation du stockage dans Render
- Activez le nettoyage automatique (déjà configuré : 7 jours)
- Exportez et supprimez les anciennes exécutions

### 3. Erreur d'authentification

#### Symptômes
- "Invalid credentials"
- Impossible de se connecter
- Mot de passe refusé

#### Solutions

**A. Récupérez le mot de passe**
```bash
# Dans Render Dashboard :
# 1. Environment variables
# 2. Cherchez N8N_BASIC_AUTH_PASSWORD
# 3. Cliquez sur "Reveal" pour voir la valeur
```

**B. Réinitialisez le mot de passe**
```bash
# Dans Render Dashboard :
# 1. Environment variables
# 2. Modifiez N8N_BASIC_AUTH_PASSWORD
# 3. Sauvegardez (le service redémarre automatiquement)
```

**C. Vérifiez le nom d'utilisateur**
- Par défaut : `admin`
- Vérifiez `N8N_BASIC_AUTH_USER` dans les variables

### 4. Les webhooks ne fonctionnent pas

#### Symptômes
- Webhooks qui retournent 404
- Pas de déclenchement des workflows
- Erreur "Webhook not found"

#### Solutions

**A. Configurez WEBHOOK_URL**
```bash
# WEBHOOK_URL doit être votre URL Render complète
# Exemple : https://n8n-xxxx.onrender.com
```

**B. Vérifiez N8N_HOST**
```bash
# N8N_HOST doit être identique (sans https://)
# Exemple : n8n-xxxx.onrender.com
```

**C. Testez le webhook**
```bash
# Utilisez curl pour tester
curl -X POST https://votre-instance.onrender.com/webhook-test/votre-webhook-id
```

**D. Vérifiez le workflow**
- Le workflow est-il activé ?
- Le webhook node est-il correctement configuré ?
- Le chemin du webhook est-il correct ?

### 5. Erreurs de base de données

#### Symptômes
- "Connection refused"
- "Database error"
- "ECONNREFUSED"

#### Solutions

**A. Vérifiez que la base de données est active**
```bash
# Dans Render Dashboard :
# 1. Allez dans "Databases"
# 2. Vérifiez le statut de n8nDB
# 3. Regardez les logs de la base
```

**B. Vérifiez les variables de connexion**
Toutes ces variables doivent être définies :
- `DB_POSTGRESDB_HOST`
- `DB_POSTGRESDB_DATABASE`
- `DB_POSTGRESDB_PORT`
- `DB_POSTGRESDB_USER`
- `DB_POSTGRESDB_PASSWORD`

**C. Redémarrez les services**
```bash
# 1. Redémarrez la base de données
# 2. Attendez qu'elle soit "Available"
# 3. Redémarrez le service n8n
```

### 6. Workflows qui échouent

#### Symptômes
- Exécutions en erreur
- Nodes qui ne s'exécutent pas
- Données manquantes

#### Solutions

**A. Vérifiez les logs d'exécution**
```bash
# Dans n8n :
# 1. Cliquez sur "Executions"
# 2. Sélectionnez l'exécution en erreur
# 3. Regardez les détails de chaque node
```

**B. Testez les credentials**
```bash
# Dans n8n :
# 1. Credentials
# 2. Sélectionnez le credential
# 3. Cliquez sur "Test"
```

**C. Vérifiez les permissions API**
- Les tokens ont-ils les bonnes permissions ?
- Les credentials sont-ils expirés ?
- Les quotas API sont-ils dépassés ?

### 7. Problèmes de performance

#### Symptômes
- Workflows très lents
- Timeouts
- CPU à 100%

#### Solutions

**A. Optimisez vos workflows**
```javascript
// ❌ Mauvais : boucle sur 10000 items
items.forEach(item => {
  // traitement lourd
});

// ✅ Bon : traitement par batch
const batchSize = 100;
for (let i = 0; i < items.length; i += batchSize) {
  const batch = items.slice(i, i + batchSize);
  // traitement du batch
}
```

**B. Utilisez le cache**
```javascript
// Mettez en cache les données fréquemment utilisées
// Utilisez le node "Set" pour stocker temporairement
```

**C. Limitez les requêtes**
```javascript
// Utilisez des filtres côté API plutôt que côté n8n
// Exemple : filtrez dans la requête SQL plutôt qu'après
```

### 8. Erreurs de déploiement

#### Symptômes
- "Build failed"
- "Deploy failed"
- Erreurs Docker

#### Solutions

**A. Vérifiez le Dockerfile**
```dockerfile
# La version de n8n existe-t-elle ?
# Vérifiez sur : https://hub.docker.com/r/n8nio/n8n/tags
FROM n8nio/n8n:1.68.0
```

**B. Vérifiez render.yaml**
```yaml
# La syntaxe est-elle correcte ?
# Utilisez un validateur YAML en ligne
```

**C. Regardez les logs de build**
```bash
# Dans Render Dashboard :
# 1. Events
# 2. Cliquez sur le déploiement échoué
# 3. Lisez les logs complets
```

### 9. Problèmes de mise à jour

#### Symptômes
- Workflows cassés après mise à jour
- Erreurs de migration
- Données perdues

#### Solutions

**A. Sauvegardez avant de mettre à jour**
```bash
# Dans n8n :
# Settings > Import/Export > Export
# Téléchargez tous vos workflows
```

**B. Lisez les notes de version**
```bash
# Vérifiez les breaking changes :
# https://github.com/n8n-io/n8n/releases
```

**C. Rollback si nécessaire**
```bash
# Dans le Dockerfile, revenez à l'ancienne version
FROM n8nio/n8n:1.67.0  # version précédente
```

### 10. Erreurs de région

#### Symptômes
- Latence élevée
- Timeouts vers certains services
- Problèmes de connexion

#### Solutions

**A. Changez la région**
```yaml
# Dans render.yaml
services:
  - type: web
    region: oregon  # ou frankfurt, singapore, etc.
```

**B. Rapprochez-vous de vos services**
- Si vos APIs sont en Europe : utilisez Frankfurt
- Si vos APIs sont aux USA : utilisez Oregon
- Si vos APIs sont en Asie : utilisez Singapore

## 🆘 Besoin d'aide supplémentaire ?

### Ressources

1. **Documentation officielle**
   - [n8n Docs](https://docs.n8n.io/)
   - [Render Docs](https://render.com/docs)

2. **Communauté**
   - [Forum n8n](https://community.n8n.io/)
   - [Discord n8n](https://discord.gg/n8n)

3. **Support Render**
   - [Render Support](https://render.com/support)
   - [Status Page](https://status.render.com/)

### Créer un rapport de bug

Si vous pensez avoir trouvé un bug :

1. Vérifiez qu'il n'est pas déjà signalé
2. Collectez les informations :
   - Version de n8n
   - Logs d'erreur complets
   - Étapes pour reproduire
   - Comportement attendu vs observé
3. Créez une Issue sur GitHub

### Logs utiles

```bash
# Activez les logs détaillés temporairement
# Dans Environment variables :
N8N_LOG_LEVEL=debug

# Après diagnostic, remettez à "info"
N8N_LOG_LEVEL=info
```

---

**Conseil** : Gardez toujours une sauvegarde de vos workflows ! 💾
