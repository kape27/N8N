# Déploiement Docker Local

Ce guide explique comment déployer n8n localement avec Docker et Supabase.

## 🎯 Avantages du déploiement Docker

- ✅ **Facile à installer** : Un seul fichier Docker Compose
- ✅ **Isolation complète** : Pas d'impact sur ton système
- ✅ **Portable** : Fonctionne sur Windows, Mac et Linux
- ✅ **Gratuit** : Aucun coût (Supabase Free + hébergement local)
- ✅ **Contrôle total** : Tu gères tout toi-même

---

## 📋 Prérequis

### 1. Docker Desktop

**Windows & Mac** :
- Télécharge [Docker Desktop](https://www.docker.com/products/docker-desktop)
- Installe et lance Docker Desktop

**Linux** :
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install docker.io docker-compose

# Démarre Docker
sudo systemctl start docker
sudo systemctl enable docker

# Ajoute ton utilisateur au groupe docker
sudo usermod -aG docker $USER
# Déconnecte-toi et reconnecte-toi pour appliquer
```

### 2. Projet Supabase

Tu as déjà créé ton projet Supabase ! Les infos sont dans `SUPABASE_CREDENTIALS.md`.

---

## 🚀 Installation Rapide

### Étape 1 : Récupérer le mot de passe Supabase

1. Va sur [Supabase Dashboard](https://supabase.com/dashboard/project/vtnqdcxaugstcxkmkpke)
2. Clique sur **Settings** (⚙️) > **Database**
3. Scrolle jusqu'à **Database Password**
4. Clique sur **Reset Database Password** si tu l'as perdu
5. **Copie le mot de passe** (tu en auras besoin !)

### Étape 2 : Configurer les variables d'environnement

Édite le fichier `.env.docker` et remplace :

```bash
# Remplace par ton mot de passe Supabase
DB_PASSWORD=ton_mot_de_passe_supabase_ici

# Génère une clé de chiffrement aléatoire
# Linux/Mac : openssl rand -base64 32
# Windows : https://generate-random.org/encryption-key-generator (256-bit)
N8N_ENCRYPTION_KEY=ta_cle_de_chiffrement_ici

# Optionnel : Change le mot de passe admin
N8N_PASSWORD=ton_mot_de_passe_admin
```

### Étape 3 : Démarrer n8n

**Windows** :
```cmd
docker-run.bat
```

**Linux/Mac** :
```bash
chmod +x docker-run.sh
./docker-run.sh
```

**Ou manuellement** :
```bash
docker-compose --env-file .env.docker up -d
```

### Étape 4 : Accéder à n8n

1. Attends 30 secondes que n8n démarre
2. Ouvre ton navigateur sur : **http://localhost:5678**
3. Connecte-toi avec :
   - **Utilisateur** : `admin`
   - **Mot de passe** : celui dans `.env.docker` (par défaut : `admin123`)

---

## 🔧 Commandes Utiles

### Voir les logs en temps réel
```bash
docker-compose logs -f n8n
```

### Arrêter n8n
```bash
docker-compose down
```

### Redémarrer n8n
```bash
docker-compose restart n8n
```

### Voir le statut
```bash
docker-compose ps
```

### Mettre à jour n8n
```bash
# Arrêter
docker-compose down

# Modifier la version dans docker-compose.yml
# FROM: image: n8nio/n8n:1.68.0
# TO:   image: n8nio/n8n:1.69.0

# Télécharger la nouvelle image
docker-compose pull

# Redémarrer
docker-compose --env-file .env.docker up -d
```

### Supprimer complètement n8n (y compris les données)
```bash
docker-compose down -v
```

---

## 🌐 Exposer n8n sur Internet

### Option 1 : ngrok (Gratuit, temporaire)

1. Installe [ngrok](https://ngrok.com/download)
2. Lance ngrok :
   ```bash
   ngrok http 5678
   ```
3. Copie l'URL HTTPS fournie (ex: `https://abc123.ngrok.io`)
4. Modifie `.env.docker` :
   ```bash
   N8N_HOST=abc123.ngrok.io
   WEBHOOK_URL=https://abc123.ngrok.io
   ```
5. Redémarre :
   ```bash
   docker-compose restart n8n
   ```

⚠️ **Attention** : L'URL change à chaque redémarrage de ngrok (gratuit).

### Option 2 : Cloudflare Tunnel (Gratuit, permanent)

1. Installe [Cloudflared](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/)
2. Connecte-toi :
   ```bash
   cloudflared tunnel login
   ```
3. Crée un tunnel :
   ```bash
   cloudflared tunnel create n8n
   ```
4. Configure le tunnel :
   ```bash
   cloudflared tunnel route dns n8n n8n.ton-domaine.com
   ```
5. Lance le tunnel :
   ```bash
   cloudflared tunnel run --url http://localhost:5678 n8n
   ```

### Option 3 : Serveur VPS avec nom de domaine

Si tu as un VPS (DigitalOcean, OVH, etc.) :

1. Configure ton domaine (ex: `n8n.ton-domaine.com`)
2. Installe un reverse proxy (Nginx, Caddy)
3. Configure HTTPS avec Let's Encrypt
4. Redirige vers `localhost:5678`

**Exemple Caddy** :
```
n8n.ton-domaine.com {
    reverse_proxy localhost:5678
}
```

---

## 🔒 Sécurité

### 1. Changement du mot de passe

Après la première connexion :
1. Modifie `.env.docker`
2. Change `N8N_PASSWORD`
3. Redémarre : `docker-compose restart n8n`

### 2. Clé de chiffrement

⚠️ **IMPORTANT** : Ne perds JAMAIS ta clé de chiffrement !

Si tu la perds :
- Tes credentials sauvegardés seront inutilisables
- Tu devras reconfigurer toutes tes connexions

**Sauvegarde ta clé** :
```bash
# Affiche ta clé actuelle
grep N8N_ENCRYPTION_KEY .env.docker
```

### 3. Firewall

Si tu exposes n8n sur internet :
```bash
# Autorise seulement le port 5678
sudo ufw allow 5678/tcp
```

---

## 📊 Monitoring

### Voir l'utilisation des ressources

```bash
# CPU, RAM, Network
docker stats n8n
```

### Espace disque utilisé

```bash
# Taille du volume
docker volume inspect n8n_n8n_data
```

### Health check

```bash
# Vérifier que n8n répond
curl http://localhost:5678/healthz
```

---

## 🐛 Dépannage

### Le conteneur ne démarre pas

```bash
# Voir les logs d'erreur
docker-compose logs n8n

# Vérifier la configuration
docker-compose config
```

### Erreur de connexion à Supabase

```bash
# Tester la connexion depuis le conteneur
docker exec -it n8n sh
apk add postgresql-client
psql "postgresql://postgres:PASSWORD@db.vtnqdcxaugstcxkmkpke.supabase.co:5432/postgres?sslmode=require"
```

### Port 5678 déjà utilisé

```bash
# Voir ce qui utilise le port
# Windows
netstat -ano | findstr :5678

# Linux/Mac
lsof -i :5678

# Change le port dans docker-compose.yml
ports:
  - "8080:5678"  # Utilise le port 8080 à la place
```

### Réinitialiser complètement

```bash
# Arrêter et supprimer tout
docker-compose down -v

# Supprimer l'image
docker rmi n8nio/n8n:1.68.0

# Nettoyer Docker
docker system prune -a

# Redémarrer
docker-compose --env-file .env.docker up -d
```

---

## 💾 Sauvegarde et Restauration

### Backup des workflows

#### Méthode 1 : Via l'interface n8n
1. Settings > Import/Export
2. Export workflows

#### Méthode 2 : Via le volume Docker
```bash
# Backup
docker run --rm -v n8n_n8n_data:/data -v $(pwd):/backup ubuntu tar czf /backup/n8n-backup-$(date +%Y%m%d).tar.gz /data

# Restauration
docker run --rm -v n8n_n8n_data:/data -v $(pwd):/backup ubuntu tar xzf /backup/n8n-backup-20260623.tar.gz -C /
```

### Backup de Supabase

Voir [SUPABASE_SETUP.md](SUPABASE_SETUP.md#-backups)

---

## 🚀 Optimisations

### Limiter la RAM utilisée

```yaml
# Dans docker-compose.yml, ajoute :
services:
  n8n:
    deploy:
      resources:
        limits:
          memory: 512M
```

### Augmenter les performances

```yaml
# Dans docker-compose.yml, ajoute :
environment:
  - N8N_CONCURRENCY_PRODUCTION_LIMIT=10
  - EXECUTIONS_TIMEOUT=300
```

### Logs rotatifs

```yaml
# Dans docker-compose.yml, ajoute :
services:
  n8n:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

---

## 📚 Ressources

- [Docker Documentation](https://docs.docker.com/)
- [n8n Docker Documentation](https://docs.n8n.io/hosting/installation/docker/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)

---

## ✅ Checklist

- [ ] Docker installé et lancé
- [ ] Mot de passe Supabase récupéré
- [ ] Clé de chiffrement générée
- [ ] `.env.docker` configuré
- [ ] n8n démarré avec `docker-compose up -d`
- [ ] Accès à http://localhost:5678
- [ ] Connexion réussie avec admin
- [ ] Mot de passe changé
- [ ] Premier workflow créé et testé

**Bravo ! Ton instance n8n Docker est opérationnelle ! 🎉**
