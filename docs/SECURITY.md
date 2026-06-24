# Guide de Sécurité

## 🔒 Bonnes pratiques de sécurité pour n8n

### 1. Authentification

#### Changez le mot de passe par défaut
Après le premier déploiement :
1. Connectez-vous avec les identifiants par défaut
2. Allez dans **Settings** > **Users**
3. Changez le mot de passe admin

#### Utilisez des mots de passe forts
- Minimum 16 caractères
- Mélange de majuscules, minuscules, chiffres et symboles
- Utilisez un gestionnaire de mots de passe

#### Activez l'authentification à deux facteurs (si disponible)
Vérifiez dans les paramètres de n8n si la 2FA est disponible dans votre version.

### 2. Variables d'environnement sensibles

#### Ne commitez JAMAIS
- Mots de passe
- Clés API
- Tokens d'accès
- Clés de chiffrement

#### Utilisez les secrets Render
Dans le dashboard Render, les variables marquées comme "secret" sont :
- Chiffrées au repos
- Masquées dans l'interface
- Non exposées dans les logs

### 3. HTTPS

#### Toujours utiliser HTTPS
- Render fournit HTTPS automatiquement
- Ne désactivez jamais `N8N_PROTOCOL=https` en production
- Vérifiez que vos webhooks utilisent HTTPS

### 4. Webhooks

#### Sécurisez vos webhooks
```javascript
// Dans vos workflows, validez toujours les données entrantes
if (!$input.item.json.signature) {
  throw new Error('Signature manquante');
}
```

#### Utilisez des tokens de vérification
- Ajoutez des paramètres secrets dans vos URLs de webhook
- Exemple : `https://votre-instance.onrender.com/webhook/abc123?token=secret`

### 5. Permissions et accès

#### Principe du moindre privilège
- Ne donnez que les permissions nécessaires aux intégrations
- Utilisez des tokens avec scope limité
- Révoquez les accès inutilisés

#### Auditez régulièrement
- Vérifiez les workflows actifs
- Contrôlez les connexions aux services externes
- Supprimez les credentials non utilisés

### 6. Base de données

#### Sauvegardes régulières
```bash
# Exportez vos workflows régulièrement
# Dans n8n : Settings > Import/Export > Export
```

#### Chiffrement
- La clé `N8N_ENCRYPTION_KEY` chiffre les credentials
- Ne la partagez JAMAIS
- Sauvegardez-la dans un endroit sûr (gestionnaire de mots de passe)

### 7. Mises à jour

#### Restez à jour
1. Surveillez les [releases de n8n](https://github.com/n8n-io/n8n/releases)
2. Lisez les notes de version
3. Testez sur une instance de staging si possible
4. Mettez à jour le `Dockerfile` avec la nouvelle version

#### Changelog de sécurité
Abonnez-vous aux alertes de sécurité :
- [GitHub Security Advisories](https://github.com/n8n-io/n8n/security/advisories)
- [n8n Community](https://community.n8n.io/)

### 8. Logs et monitoring

#### Ne loggez pas de données sensibles
```javascript
// ❌ Mauvais
console.log('Password:', password);

// ✅ Bon
console.log('Authentication successful');
```

#### Surveillez les accès
- Consultez régulièrement les logs Render
- Cherchez des patterns d'accès suspects
- Configurez des alertes pour les erreurs d'authentification

### 9. Réseau

#### Limitez l'exposition
- N'exposez que les endpoints nécessaires
- Utilisez des webhooks avec tokens
- Considérez un VPN pour les accès admin (plans payants)

#### Validez les entrées
Toujours valider et nettoyer les données externes :
```javascript
const sanitize = (input) => {
  return String(input).replace(/[<>]/g, '');
};
```

### 10. Conformité

#### RGPD
Si vous traitez des données personnelles :
- Documentez les workflows qui traitent des données personnelles
- Implémentez le droit à l'oubli
- Chiffrez les données sensibles
- Limitez la rétention des données

#### Données sensibles
- Ne stockez pas de données de carte bancaire
- Chiffrez les données de santé
- Respectez les réglementations locales

## 🚨 En cas de compromission

### Actions immédiates

1. **Changez tous les mots de passe**
   - Compte admin n8n
   - Base de données
   - Tous les services connectés

2. **Révoquez les accès**
   - Tokens API
   - Clés OAuth
   - Webhooks

3. **Régénérez les secrets**
   ```bash
   # Dans Render, régénérez :
   # - N8N_ENCRYPTION_KEY (attention : perte des credentials existants)
   # - N8N_BASIC_AUTH_PASSWORD
   ```

4. **Auditez les workflows**
   - Vérifiez les modifications récentes
   - Cherchez des workflows suspects
   - Contrôlez l'historique d'exécution

5. **Analysez les logs**
   - Identifiez le point d'entrée
   - Tracez les actions effectuées
   - Documentez l'incident

### Prévention future

- Activez l'authentification à deux facteurs
- Mettez en place des alertes de sécurité
- Effectuez des audits réguliers
- Formez les utilisateurs

## 📞 Signaler une vulnérabilité

Si vous découvrez une vulnérabilité de sécurité :

1. **NE PAS** créer d'issue publique
2. Contactez les mainteneurs en privé
3. Donnez le temps de corriger avant divulgation publique
4. Suivez les principes de divulgation responsable

## 📚 Ressources

- [n8n Security Best Practices](https://docs.n8n.io/hosting/security/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Render Security](https://render.com/docs/security)

---

**La sécurité est un processus continu, pas une destination.** 🛡️
