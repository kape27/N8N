# Changelog

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/lang/fr/).

### Version 2.2 (2026-06-23)

### Ajouté
- Déploiement Docker local complet
- Scripts de démarrage automatique (Windows et Linux/Mac)
- Makefile avec commandes utiles
- Guide complet Docker (docs/DOCKER_DEPLOYMENT.md)
- QUICK_START.md pour démarrage rapide
- Scripts de vérification de configuration (check-config)
- Clé de chiffrement pré-générée
- Support pour ngrok et Cloudflare Tunnel
- Commandes de backup et restauration

### Modifié
- README restructuré avec 2 options de déploiement
- Documentation Docker ajoutée

## [2.1.0] - 2026-04-26

### Modifié
- Migration de la base de données vers Supabase (gratuit à vie)
- Configuration SSL activée pour la connexion PostgreSQL
- Variables d'environnement adaptées pour Supabase
- README mis à jour avec les instructions Supabase

### Ajouté
- Guide complet de configuration Supabase (docs/SUPABASE_SETUP.md)
- Instructions pour le monitoring avec Supabase
- Guide de backup avec Supabase
- Optimisations avec connection pooling

### Supprimé
- Dépendance à la base de données Render (plus de limite de 90 jours)

## [2.0.0] - 2026-04-26

### Ajouté
- Authentification basique activée par défaut pour la sécurité
- Génération automatique du mot de passe admin
- Health checks dans le Dockerfile
- Nettoyage automatique des anciennes exécutions (7 jours)
- Variables d'environnement pour WEBHOOK_URL et N8N_HOST
- Configuration HTTPS par défaut
- Documentation enrichie dans le README
- Fichier .env.example pour le développement local
- FAQ dans le README
- Section sécurité dans le README
- CHANGELOG.md pour suivre les versions
- CONTRIBUTING.md pour guider les contributions

### Modifié
- Version fixe de n8n (1.68.0) au lieu de latest
- Dockerfile optimisé avec health checks
- README complètement restructuré et traduit en français
- Configuration render.yaml avec plus de variables d'environnement

### Sécurité
- Authentification obligatoire par défaut
- Mot de passe généré automatiquement
- Utilisation de l'utilisateur non-root dans Docker
- HTTPS activé par défaut

## [1.0.0] - Date initiale

### Ajouté
- Configuration initiale pour déployer n8n sur Render
- Dockerfile basique avec n8n:latest
- Configuration render.yaml avec PostgreSQL
- README avec instructions d'installation
- Support de la région Frankfurt
- Configuration timezone Europe/Paris
- Locale française par défaut
