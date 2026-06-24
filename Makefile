.PHONY: help setup start stop restart logs status clean update backup

# Variables
COMPOSE_FILE = docker-compose.yml
ENV_FILE = .env.docker

help: ## Affiche l'aide
	@echo "🚀 Commandes disponibles pour n8n Docker :"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

setup: ## Configuration initiale (génère la clé de chiffrement)
	@echo "🔧 Configuration initiale..."
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "❌ Fichier $(ENV_FILE) introuvable !"; \
		exit 1; \
	fi
	@if grep -q "your_random_encryption_key_here" $(ENV_FILE); then \
		echo "🔑 Génération de la clé de chiffrement..."; \
		ENCRYPTION_KEY=$$(openssl rand -base64 32); \
		if [[ "$$OSTYPE" == "darwin"* ]]; then \
			sed -i '' "s/N8N_ENCRYPTION_KEY=.*/N8N_ENCRYPTION_KEY=$$ENCRYPTION_KEY/" $(ENV_FILE); \
		else \
			sed -i "s/N8N_ENCRYPTION_KEY=.*/N8N_ENCRYPTION_KEY=$$ENCRYPTION_KEY/" $(ENV_FILE); \
		fi; \
		echo "✅ Clé générée !"; \
	else \
		echo "✅ Clé de chiffrement déjà configurée"; \
	fi
	@if grep -q "your_supabase_password_here" $(ENV_FILE); then \
		echo "⚠️  N'oublie pas de configurer DB_PASSWORD dans $(ENV_FILE) !"; \
	fi

start: ## Démarre n8n
	@echo "🚀 Démarrage de n8n..."
	@docker-compose --env-file $(ENV_FILE) up -d
	@echo "✅ n8n démarré !"
	@echo ""
	@echo "🌐 Accède à n8n sur : http://localhost:5678"
	@echo "📊 Voir les logs : make logs"

stop: ## Arrête n8n
	@echo "🛑 Arrêt de n8n..."
	@docker-compose down
	@echo "✅ n8n arrêté !"

restart: stop start ## Redémarre n8n

logs: ## Affiche les logs en temps réel
	@docker-compose logs -f n8n

status: ## Affiche le statut des conteneurs
	@docker-compose ps

clean: ## Supprime tout (conteneurs, volumes, données)
	@echo "⚠️  ATTENTION : Cela va supprimer TOUTES les données de n8n !"
	@read -p "Es-tu sûr ? (y/N) " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker-compose down -v; \
		echo "✅ Nettoyage terminé !"; \
	else \
		echo "❌ Annulé"; \
	fi

update: ## Met à jour n8n vers la dernière version
	@echo "📦 Mise à jour de n8n..."
	@docker-compose down
	@docker-compose pull
	@docker-compose --env-file $(ENV_FILE) up -d
	@echo "✅ n8n mis à jour !"

backup: ## Crée un backup des données n8n
	@echo "💾 Création du backup..."
	@mkdir -p backups
	@docker run --rm \
		-v n8n_n8n_data:/data \
		-v $$(pwd)/backups:/backup \
		ubuntu tar czf /backup/n8n-backup-$$(date +%Y%m%d-%H%M%S).tar.gz /data
	@echo "✅ Backup créé dans backups/"
	@ls -lh backups/

shell: ## Ouvre un shell dans le conteneur n8n
	@docker exec -it n8n sh

db-shell: ## Se connecte à la base de données Supabase
	@echo "🔑 Récupère le mot de passe dans $(ENV_FILE)"
	@DB_PASSWORD=$$(grep DB_PASSWORD $(ENV_FILE) | cut -d '=' -f2); \
	docker exec -it n8n sh -c "apk add postgresql-client && psql 'postgresql://postgres:$$DB_PASSWORD@db.vtnqdcxaugstcxkmkpke.supabase.co:5432/postgres?sslmode=require'"

healthcheck: ## Vérifie que n8n répond
	@echo "🏥 Health check..."
	@curl -f http://localhost:5678/healthz && echo "✅ n8n est en bonne santé !" || echo "❌ n8n ne répond pas"

stats: ## Affiche les stats d'utilisation
	@docker stats n8n --no-stream
