# 🌐 Exposer N8N sur Internet avec ngrok

## 📋 Qu'est-ce que ngrok ?

ngrok crée un tunnel sécurisé qui expose votre N8N local sur Internet via une URL publique HTTPS.

**Avantages** :
- ✅ URL publique HTTPS gratuite
- ✅ Pas besoin de configurer le routeur/firewall
- ✅ Webhooks accessibles depuis Internet
- ✅ Partager votre N8N temporairement

---

## 🚀 Installation et Configuration

### Étape 1 : Créer un compte ngrok (Gratuit)

1. Allez sur https://dashboard.ngrok.com/signup
2. Inscrivez-vous gratuitement
3. Connectez-vous

### Étape 2 : Récupérer votre Authtoken

1. Allez sur https://dashboard.ngrok.com/get-started/your-authtoken
2. Copiez votre authtoken (exemple : `2abc123def456...`)

### Étape 3 : Configurer le token

Ouvrez le fichier `.env.docker` et ajoutez votre token :

```env
NGROK_AUTHTOKEN=VOTRE_TOKEN_ICI
```

### Étape 4 : Démarrer N8N avec ngrok

```cmd
docker-compose --env-file .env.docker up -d
```

### Étape 5 : Récupérer votre URL publique

Deux méthodes :

#### Méthode 1 : Interface web ngrok
Ouvrez http://localhost:4040 dans votre navigateur pour voir :
- L'URL publique ngrok (exemple : `https://abc123.ngrok.io`)
- Les requêtes en temps réel
- Les statistiques

#### Méthode 2 : Via les logs
```cmd
docker logs n8n-ngrok
```

Cherchez une ligne comme :
```
Forwarding https://abc123.ngrok.io -> http://n8n:5678
```

### Étape 6 : Accéder à N8N

Utilisez l'URL publique ngrok : `https://abc123.ngrok.io`

---

## 🔧 Commandes Utiles

```cmd
# Démarrer avec ngrok
docker-compose --env-file .env.docker up -d

# Voir l'URL publique
docker logs n8n-ngrok

# Interface web ngrok (voir les requêtes en direct)
# Ouvrir : http://localhost:4040

# Arrêter
docker-compose --env-file .env.docker down

# Voir les logs
docker logs n8n-ngrok -f
```

---

## 📊 Limitations du Plan Gratuit ngrok

| Fonctionnalité | Plan Gratuit |
|----------------|--------------|
| **Tunnels simultanés** | 1 |
| **Connexions/min** | 40 |
| **URLs** | Aléatoires (changent à chaque redémarrage) |
| **HTTPS** | ✅ Inclus |
| **Domaine personnalisé** | ❌ (payant) |

---

## 🎯 Configuration Avancée

### URL personnalisée (Plan payant)

Si vous avez un plan payant ngrok, modifiez `ngrok.yml` :

```yaml
version: "2"
authtoken: ${NGROK_AUTHTOKEN}
tunnels:
  n8n:
    proto: http
    addr: n8n:5678
    hostname: mon-n8n.ngrok.io  # Votre domaine réservé
    schemes:
      - https
    inspect: true
```

### Authentification basique

Pour ajouter une protection supplémentaire :

```yaml
version: "2"
authtoken: ${NGROK_AUTHTOKEN}
tunnels:
  n8n:
    proto: http
    addr: n8n:5678
    schemes:
      - https
    inspect: true
    auth: "user:password"  # Ajouter auth basique ngrok
```

Note : N8N a déjà son authentification (admin/admin123)

---

## 🔒 Sécurité

### Recommandations

1. ✅ **Gardez l'authentification N8N active** (déjà configuré)
2. ✅ **Changez le mot de passe par défaut** (admin123)
3. ✅ **N'exposez que temporairement** (pour tests, webhooks)
4. ⚠️ **URL change à chaque redémarrage** (plan gratuit)
5. ✅ **Surveillez les requêtes** via http://localhost:4040

### Changer le mot de passe N8N

Modifiez `.env.docker` :
```env
N8N_PASSWORD=VotreMotDePasseSecurise123!
```

Puis redémarrez :
```cmd
docker-compose --env-file .env.docker restart n8n
```

---

## 🆚 Comparaison : ngrok vs Render

| Aspect | ngrok (Local) | Render (Cloud) |
|--------|---------------|----------------|
| **Performance** | ⚠️ Lente (Supabase distant) | ⚠️ Lente (RAM limitée) |
| **Uptime** | Dépend de votre PC | 24/7 |
| **URL** | Change à chaque restart | Fixe |
| **Coût** | Gratuit | Gratuit (512MB) |
| **Configuration** | Simple | Déjà fait |

---

## 🔄 Workflow Recommandé

1. **Développement** : 
   - Utilisez http://localhost:5678 (pas de ngrok)
   - Rapide, pas de latence

2. **Tests de Webhooks** :
   - Lancez ngrok temporairement
   - Utilisez l'URL publique pour les webhooks
   - Arrêtez ngrok après les tests

3. **Production** :
   - Utilisez Render : https://n8n-ic76.onrender.com
   - Toujours accessible

---

## 🆘 Dépannage

### ngrok ne démarre pas

```cmd
# Vérifier les logs
docker logs n8n-ngrok

# Vérifier que le token est configuré
cat .env.docker | grep NGROK
```

### URL ngrok introuvable

1. Ouvrez http://localhost:4040
2. Ou vérifiez les logs : `docker logs n8n-ngrok`

### "Failed to start tunnel"

- Vérifiez que votre authtoken est correct
- Un seul tunnel gratuit à la fois (fermez les autres)

### N8N inaccessible via ngrok

- Vérifiez que N8N fonctionne : http://localhost:5678
- Vérifiez que ngrok pointe vers `n8n:5678`
- Redémarrez les conteneurs

---

## 📚 Ressources

- [Documentation ngrok](https://ngrok.com/docs)
- [Dashboard ngrok](https://dashboard.ngrok.com)
- [Pricing ngrok](https://ngrok.com/pricing)

---

**Date** : 24 juin 2026
