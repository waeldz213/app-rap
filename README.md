# App Rap 🎤

> Application mobile de culture rap français — Quiz, Duels 1v1, Collection de cartes

---

## Description

**App Rap** est une application Flutter dédiée à la culture rap français. Les utilisateurs peuvent tester leurs connaissances via des quiz, s'affronter en duel 1v1 en temps réel, et collectionner des cartes virtuelles de leurs artistes préférés.

**Modèle freemium** : un pack gratuit + packs premium (abonnement ou achat unique) + option de déblocage par grind.

---

## Stack Technique

| Technologie | Usage |
|-------------|-------|
| Flutter 3.x | Framework mobile cross-platform (iOS & Android) |
| Firebase Auth | Authentification (email + Google) |
| Cloud Firestore | Base de données temps réel |
| Firebase Cloud Messaging | Notifications push |
| Firebase Analytics | Analyse d'usage |
| Riverpod 2.x | Gestion d'état |
| GoRouter 12.x | Navigation déclarative |
| Flutter Animate | Animations fluides |
| Google Fonts (Poppins) | Typographie |

---

## Fonctionnalités MVP

### 🎤 Système de Packs Thématiques
- **Pack 1 — Classiques Absolus** 🎤 (Gratuit) — hits incontournables, difficulté faible à moyenne
- **Pack 2 — Légendes 90s/2000s** 👑 (Premium) — IAM, Booba, Médine, Kery James, Oxmo…
- **Pack 3 — Nouvelle École** 🔥 (Premium) — Drill FR, nouvelle vague
- **Pack 4 — Plume & Mélodie** ✨ (Premium) — rap introspectif, mélodique, cloud
- **Pack 5 — Spécial PNL** 🌙 (Premium) — tout l'univers PNL

### 🎯 Quiz Solo
- **Type 1 — "Qui a dit ça ?"** : identifier l'artiste d'une citation parmi 4 choix
- **Type 2 — "Complète la Punchline"** : trouver le mot manquant (`***`) parmi 4 options
- Système de streak et multiplicateur de score
- Timer de 15 secondes par question
- Bonus vitesse : +50pts < 3s, +25pts < 6s, +10pts < 9s
- Streak x1.5 à partir de 5 consécutives, x2.0 à partir de 10
- Bonus carte équipée : +10% de score (solo uniquement)

### ⚔️ Duel 1v1
- Créer ou rejoindre un duel via code
- Questions simultanées via Firestore streams
- Score duel : 200pts de base par bonne réponse + bonus vitesse
- Récompenses : +30 pts de rang + 50 pièces (victoire), -15 pts + 10 pièces (défaite)

### 🃏 Collection de Cartes
- 4 raretés : Commune (60%), Rare (25%), Épique (12%), Légendaire (3%)
- Obtenir des boosters : victoire 1v1, série de 10 bonnes réponses, défi quotidien
- 1 booster = 3 cartes avec tirage pondéré côté serveur
- Animation d'ouverture de booster
- Carte équipée : +10% bonus de score (solo)

### 🏆 Progression
- XP et niveaux (formule : niveau × 500 XP)
- Rang : Bronze → Silver → Gold → Platinum → Diamond → Master
- Streak journalier
- Défi quotidien : 25 pièces + 50 XP + 30% de chance de booster

### 🛒 Boutique
- Abonnement Premium mensuel/annuel (IAP)
- Achat de pièces virtuelles
- Déblocage pack par grind : 20 victoires 1v1 OU 150 bonnes réponses solo

---

## Architecture

```
lib/
├── config/
│   ├── theme.dart              # Dark mode, couleurs, gradients, typographie Poppins
│   ├── routes.dart             # GoRouter — toutes les routes
│   ├── constants.dart          # Scores, durées, taux de drop, etc.
│   └── firebase_config.dart    # Options Firebase (à configurer via FlutterFire CLI)
├── models/
│   ├── user_model.dart         # UserModel + UserStats
│   ├── pack_model.dart         # PackModel + GrindRequirement
│   ├── question_model.dart     # QuestionType (whoSaidIt / completeThePunchline)
│   ├── card_model.dart         # CardModel + CardRarity
│   ├── duel_model.dart         # DuelModel + DuelAnswer + DuelStatus
│   ├── daily_challenge_model.dart
│   ├── booster_model.dart
│   └── transaction_model.dart
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── pack_service.dart
│   ├── quiz_service.dart
│   ├── duel_service.dart
│   ├── collection_service.dart
│   ├── daily_challenge_service.dart
│   ├── scoring_service.dart    # Logique de score complète
│   ├── iap_service.dart        # Abstraction In-App Purchase
│   └── notification_service.dart
├── providers/                  # Riverpod 2.x providers
├── screens/
│   ├── splash/ onboarding/ auth/ home/ packs/ quiz/ duel/
│   ├── collection/ shop/ profile/ settings/
│   └── quiz/widgets/           # question_card, answer_button, timer, streak
├── widgets/                    # Composants réutilisables
│   ├── glass_card.dart         # Glassmorphism
│   ├── gradient_button.dart
│   ├── rarity_badge.dart
│   └── ...
└── main.dart / app.dart
functions/
├── index.js                    # Cloud Functions: validateDuelResult, generateDailyChallenge,
│                               #   validatePurchase, openBooster
firestore.rules                 # Règles de sécurité Firestore
firestore.indexes.json          # Index composites
```

---

## Système de Score

```
Solo
  score = (réponses_correctes × 100 + bonus_vitesse) × multiplicateur_streak × bonus_carte

Duel
  score = (réponses_correctes × 200 + bonus_vitesse) × multiplicateur_streak

bonus_vitesse : < 3s → +50pts | < 6s → +25pts | < 9s → +10pts
multiplicateur_streak : ≥5 réponses → ×1.5 | ≥10 réponses → ×2.0
bonus_carte (équipée, solo uniquement) : ×1.10
```

---

## Installation

### Prérequis
- Flutter SDK ≥ 3.0.0
- Firebase CLI (`npm install -g firebase-tools`)
- Node.js ≥ 16 (Cloud Functions)

### Étapes

```bash
# 1. Cloner le repo
git clone https://github.com/votre-org/app-rap.git
cd app-rap

# 2. Installer les dépendances Flutter
flutter pub get

# 3. Configurer Firebase (crée google-services.json et GoogleService-Info.plist)
dart pub global activate flutterfire_cli
flutterfire configure

# 4. Lancer en développement
flutter run

# 5. Déployer les Cloud Functions
cd functions && npm install && cd ..
firebase deploy --only functions

# 6. Déployer les règles et index Firestore
firebase deploy --only firestore
```

### Comment ajouter du contenu (questions, cartes)

Voir [CONTENT_GUIDE.md](./CONTENT_GUIDE.md) pour le format détaillé et les scripts d'import.

---

## Thème UI

| Couleur | Hex | Usage |
|---------|-----|-------|
| Background | `#0A0A0F` | Fond principal |
| Surface | `#14141F` | Cartes, composants |
| Primary | `#7C3AED` | Violet vif — actions principales |
| Secondary | `#3B82F6` | Bleu électrique — accents |
| Accent | `#F59E0B` | Or/ambre — récompenses |
| Success | `#10B981` | Bonne réponse |
| Error | `#EF4444` | Mauvaise réponse |

Gradients : `premiumGradient` (violet→bleu), `goldGradient` (or→orange), `fireGradient` (rouge→orange)

---

## Roadmap Post-MVP

- [ ] Widget iOS (WidgetKit) — punchline du jour sur l'écran d'accueil
- [ ] Widget Android (App Widget)
- [ ] Tournois multi-joueurs
- [ ] Classement mondial et par région
- [ ] Mode "Blindtest" (extraits audio si droits obtenus)
- [ ] Profils publics et abonnements entre joueurs
- [ ] Packs saisonniers et collaborations artistes

---

## ⚠️ À faire après cette PR (configuration manuelle requise)

Les éléments suivants **ne peuvent pas être automatisés** et doivent être faits manuellement :

1. **Créer un projet Firebase** et le connecter via FlutterFire CLI  
   ```bash
   flutterfire configure
   ```
   Cela génère `lib/firebase_options.dart` et les fichiers `google-services.json` / `GoogleService-Info.plist`.

2. **Configurer les comptes développeur**
   - Apple Developer Program ($99/an) — pour publier sur l'App Store
   - Google Play Console ($25 one-time) — pour publier sur le Play Store

3. **Créer les produits In-App Purchase**
   - App Store Connect : abonnement mensuel, annuel, packs de pièces
   - Google Play Console : mêmes produits avec les mêmes SKUs

4. **Remplacer les citations fictives** par de vraies citations validées juridiquement  
   *(les exemples actuels sont génériques pour éviter les problèmes de droits)*

5. **Créer les visuels des cartes** — illustrations / design graphique pour chaque carte  
   Format : 400×560px, voir `CONTENT_GUIDE.md`

6. **Créer les assets visuels des packs** — covers et icônes  
   Format : 600×400px, placer dans Firebase Storage

7. **Review juridique** — droit de citation pour les punchlines (courte citation, attribution obligatoire)

8. **Configurer les notifications push**
   - Certificats APNs (Apple) dans Firebase Console
   - Clé FCM pour Android déjà incluse dans `google-services.json`

9. **Déployer les Cloud Functions** sur Firebase  
   ```bash
   cd functions && npm install
   firebase deploy --only functions
   ```

10. **Tester les achats in-app en sandbox** avant soumission

11. **Soumettre l'app sur les stores** avec captures d'écran et description

12. **Widget iOS** — nécessite du code Swift natif (WidgetKit), hors Flutter

13. **Widget Android** — nécessite du code Kotlin natif (App Widget), hors Flutter

---

## Licence

Propriétaire — Tous droits réservés.