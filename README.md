# App Rap 🎤

> Application mobile de culture rap français — Quiz, Duels 1v1, Collection de cartes

---

## Description

**App Rap** est une application Flutter dédiée à la culture rap français. Les utilisateurs peuvent tester leurs connaissances via des quiz, s'affronter en duel 1v1 en temps réel, et collectionner des cartes de leurs artistes préférés.

---

## Stack Technique

| Technologie | Usage |
|-------------|-------|
| Flutter 3.x | Framework mobile (iOS & Android) |
| Firebase Auth | Authentification |
| Cloud Firestore | Base de données temps réel |
| Firebase Cloud Messaging | Notifications push |
| Firebase Analytics | Analyse d'usage |
| Riverpod 2.x | Gestion d'état |
| GoRouter 12.x | Navigation |
| Flutter Animate | Animations fluides |
| Google Fonts (Poppins) | Typographie |

---

## Fonctionnalités

### 🎯 Quiz Solo
- Packs de questions par artiste/ère
- Système de streak et multiplicateur de score
- Timer de 15 secondes par question
- Bonus vitesse (+50pts < 3s, +25pts < 6s, +10pts < 9s)
- Score multiplié x1.5 à partir de 5 réponses correctes consécutives, x2.0 à partir de 10

### ⚔️ Duel 1v1
- Créer ou rejoindre un duel via code
- Questions simultanées en temps réel (Firestore streams)
- Score duel : 200pts de base par bonne réponse
- Récompenses : +30 pts de rang + 50 pièces (victoire), -15 pts + 10 pièces (défaite)

### 🃏 Collection de Cartes
- 4 raretés : Commune (60%), Rare (25%), Épique (12%), Légendaire (3%)
- Ouverture de boosters animée
- Carte équipée : +10% bonus de score
- Glow visuel selon la rareté

### 🏆 Système de Progression
- XP et niveaux (formule : niveau × 500 XP)
- Rang : Bronze → Silver → Gold → Platinum → Diamond → Master
- Streak journalier
- Défi quotidien (25 pièces + 50 XP + 30% de chance de booster)

### 🛒 Boutique
- Abonnement Premium (4.99€/mois ou 39.99€/an)
- Packs de pièces
- Boosters à l'unité

---

## Architecture

```
lib/
├── config/          # Thème, routes, constantes, Firebase
├── models/          # Modèles de données (fromJson/toJson)
├── services/        # Services Firebase (Auth, Firestore, etc.)
├── providers/       # Providers Riverpod
├── screens/         # Écrans par fonctionnalité
│   ├── splash/
│   ├── onboarding/
│   ├── auth/
│   ├── home/
│   ├── packs/
│   ├── quiz/
│   ├── duel/
│   ├── collection/
│   ├── shop/
│   ├── profile/
│   └── settings/
├── widgets/         # Widgets réutilisables
└── main.dart
functions/           # Firebase Cloud Functions (Node.js)
```

---

## Installation

### Prérequis
- Flutter SDK ≥ 3.0.0
- Firebase CLI
- Node.js ≥ 16 (pour les Cloud Functions)

### Étapes

```bash
# 1. Cloner le repo
git clone https://github.com/votre-org/app-rap.git
cd app-rap

# 2. Installer les dépendances Flutter
flutter pub get

# 3. Configurer Firebase
dart pub global activate flutterfire_cli
flutterfire configure

# 4. Lancer l'app
flutter run

# 5. Déployer les Cloud Functions
cd functions && npm install && cd ..
firebase deploy --only functions

# 6. Déployer les règles Firestore
firebase deploy --only firestore
```

---

## Système de Score

```
Score = (correctAnswers × 100 + speedBonus) × streakMultiplier × cardBonus

speedBonus:  < 3s → +50pts | < 6s → +25pts | < 9s → +10pts
streakMultiplier: ≥5 → ×1.5 | ≥10 → ×2.0
cardBonus (carte équipée): ×1.10
```

---

## Licence

Propriétaire — Tous droits réservés.