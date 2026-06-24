# Guide de Contribution

Merci de votre intérêt pour contribuer à ce projet ! 🎉

## Comment contribuer

### Signaler un bug

1. Vérifiez que le bug n'a pas déjà été signalé dans les Issues
2. Créez une nouvelle Issue avec :
   - Un titre clair et descriptif
   - Les étapes pour reproduire le problème
   - Le comportement attendu vs le comportement observé
   - Des captures d'écran si pertinent
   - Votre environnement (version de n8n, région Render, etc.)

### Proposer une amélioration

1. Créez une Issue pour discuter de votre idée
2. Attendez les retours avant de commencer le développement
3. Suivez les guidelines de code ci-dessous

### Soumettre une Pull Request

1. **Forkez** le repository
2. **Créez une branche** pour votre fonctionnalité :
   ```bash
   git checkout -b feature/ma-super-fonctionnalite
   ```
3. **Committez** vos changements :
   ```bash
   git commit -m "feat: ajout de ma super fonctionnalité"
   ```
4. **Poussez** vers votre fork :
   ```bash
   git push origin feature/ma-super-fonctionnalite
   ```
5. **Ouvrez une Pull Request** avec :
   - Une description claire des changements
   - Les raisons de ces changements
   - Les tests effectués

## Guidelines de code

### Commits

Utilisez le format [Conventional Commits](https://www.conventionalcommits.org/) :

- `feat:` Nouvelle fonctionnalité
- `fix:` Correction de bug
- `docs:` Documentation uniquement
- `style:` Formatage, point-virgules manquants, etc.
- `refactor:` Refactoring de code
- `test:` Ajout de tests
- `chore:` Maintenance, dépendances, etc.

Exemples :
```
feat: ajout de la configuration multi-région
fix: correction du WEBHOOK_URL automatique
docs: amélioration du README avec exemples
```

### Dockerfile

- Utilisez toujours une **version fixe** de n8n (pas `latest`)
- Ajoutez des commentaires pour les configurations complexes
- Testez localement avant de soumettre

### render.yaml

- Gardez la configuration compatible avec le plan gratuit
- Documentez les nouvelles variables d'environnement
- Testez le déploiement sur Render

### Documentation

- Mettez à jour le README si nécessaire
- Ajoutez une entrée dans CHANGELOG.md
- Utilisez un français clair et accessible
- Ajoutez des exemples quand c'est pertinent

## Tests

Avant de soumettre une PR :

1. **Testez localement** avec Docker :
   ```bash
   docker build -t n8n-test .
   docker run -p 5678:5678 n8n-test
   ```

2. **Testez sur Render** :
   - Déployez sur votre propre compte Render
   - Vérifiez que tout fonctionne correctement
   - Testez les webhooks et l'authentification

3. **Vérifiez la documentation** :
   - Relisez vos modifications
   - Vérifiez les liens
   - Testez les commandes

## Code de conduite

- Soyez respectueux et constructif
- Accueillez les nouveaux contributeurs
- Acceptez les critiques constructives
- Concentrez-vous sur ce qui est meilleur pour la communauté

## Questions ?

N'hésitez pas à :
- Ouvrir une Issue pour poser des questions
- Rejoindre les discussions existantes
- Demander de l'aide si vous êtes bloqué

## Licence

En contribuant, vous acceptez que vos contributions soient sous licence MIT.

---

Merci de contribuer à rendre ce projet meilleur ! 🚀
