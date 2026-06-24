# 🚀 Démarrage Rapide avec Docker

## En 3 minutes chrono ! ⏱️

### 1️⃣ Configure ton mot de passe Supabase

Édite `.env.docker` et remplace **UNE SEULE** ligne :

```bash
DB_PASSWORD=your_supabase_password_here
```

👉 **Où trouver ton mot de passe ?**
- Ouvre [ton projet Supabase](https://supabase.com/dashboard/project/vtnqdcxaugstcxkmkpke/settings/database)
- Copie le mot de passe (ou réinitialise-le si tu l'as perdu)

### 2️⃣ Démarre n8n

**Windows** :
```cmd
docker-run.bat
```

**Linux/Mac** :
```bash
chmod +x docker-run.sh
./docker-run.sh
```

**Avec Make (Linux/Mac)** :
```bash
make start
```

### 3️⃣ Connecte-toi !

Ouvre ton navigateur sur : **http://localhost:5678**

**Identifiants** :
- Utilisateur : `admin`
- Mot de passe : `admin123`

---

## ✅ C'est tout !

Tu as maintenant n8n qui tourne localement avec Supabase ! 🎉

### Commandes utiles

```bash
# Voir les logs
make logs
# ou
docker-compose logs -f n8n

# Arrêter n8n
make stop
# ou
docker-compose down

# Redémarrer
make restart

# Voir le statut
make status
```

---

## 🆘 Problèmes ?

### n8n ne démarre pas

```bash
# Voir les logs d'erreur
docker-compose logs n8n
```

Les erreurs communes :
- ❌ **Mot de passe Supabase incorrect** → Vérifie dans `.env.docker`
- ❌ **Port 5678 déjà utilisé** → Change le port dans `docker-compose.yml`
- ❌ **Docker n'est pas lancé** → Lance Docker Desktop

### Réinitialiser complètement

```bash
# Arrêter et tout supprimer
docker-compose down -v

# Redémarrer
docker-compose --env-file .env.docker up -d
```

---

## 📚 Documentation complète

- [Guide Docker complet](docs/DOCKER_DEPLOYMENT.md)
- [Configuration Supabase](docs/SUPABASE_SETUP.md)
- [Guide de sécurité](docs/SECURITY.md)

---

**Profite bien de n8n ! 🎊**
