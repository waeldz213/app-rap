# 🎤 App Rap — Culture Rap Français

Application mobile freemium de culture rap française. Quiz, collection de cartes, duels 1v1 en temps réel.

---

## 📱 Description

App Rap est une application interactive permettant aux fans de rap français de tester leurs connaissances, de défier leurs amis en duel et de collectionner des cartes d'artistes légendaires.

### Fonctionnalités MVP

- **Quiz Solo** : 5 packs thématiques, questions type "Qui a dit ça ?" et "Complète la punchline"
- **Duel 1v1** : Défis en temps réel via code d'invitation
- **Collection** : Cartes d'artistes avec 4 niveaux de rareté (Commune, Rare, Épique, Légendaire)
- **Boosters** : Ouverture dramatique de 3 cartes aléatoires
- **Défi du Jour** : Challenge quotidien généré automatiquement
- **Système de progression** : XP, niveaux, coins, streaks

---

## 🏗️ Stack Technique

| Technologie | Utilisation |
|-------------|-------------|
| Flutter (Dart) | Framework mobile cross-platform |
| Firebase Auth | Authentification utilisateurs |
| Cloud Firestore | Base de données temps réel |
| Cloud Functions | Logique serveur (duels, boosters, daily) |
| Firebase Messaging | Notifications push |
| Firebase Analytics | Événements utilisateurs |
| Riverpod | State management |
| GoRouter | Navigation |
| flutter_animate | Animations |
| Google Fonts (Poppins) | Typographie |

---

## 🚀 Installation & Setup

### Prérequis

- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- Un projet Firebase créé

### 1. Cloner et installer les dépendances

```bash
git clone <repo-url>
cd app-rap
flutter pub get
```

### 2. Configurer Firebase

```bash
# Installer FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurer votre projet Firebase
flutterfire configure
```

Cela génère `lib/firebase_options.dart` automatiquement. Supprime ensuite `lib/config/firebase_config.dart` et mets à jour l'import dans `lib/main.dart`.

### 3. Configurer les Cloud Functions

```bash
cd functions
npm install
```

### 4. Lancer les émulateurs Firebase (développement)

```bash
firebase emulators:start
```

### 5. Lancer l'application

```bash
flutter run
```

---

## 📁 Architecture

```
lib/
├── main.dart              # Entrée + Firebase init
├── app.dart               # Widget racine + GoRouter
├── config/
│   ├── theme.dart         # Couleurs, ThemeData
│   ├── routes.dart        # GoRouter + redirect auth
│   ├── constants.dart     # Constantes (scoring, timing, etc.)
│   └── firebase_config.dart  # Options Firebase (à remplacer)
├── models/                # Modèles de données (fromJson/toJson)
├── services/              # Logique Firebase (Auth, Firestore, etc.)
├── providers/             # État Riverpod
├── screens/               # UI par fonctionnalité
└── widgets/               # Composants réutilisables
```

---

## 📝 Ajouter du contenu

### Ajouter des questions

Voir `CONTENT_GUIDE.md` pour le format complet.

**Via Firebase Console** :
1. Aller dans Firestore > `packs/{packId}/questions`
2. Créer un nouveau document avec les champs requis

**Via seed (développement)** :
Les questions de seed sont dans `lib/services/pack_service.dart` → `_getSeedQuestions()`

⚠️ **IMPORTANT** : Tout le contenu actuel est FICTIF et doit être validé légalement avant publication.

### Ajouter des cartes

1. Ajouter dans `lib/services/collection_service.dart` → `_getSeedCards()`
2. Ou directement dans Firestore > `cards/{cardId}`

---

## 🎮 Packs disponibles

| Pack | Accès | Emoji |
|------|-------|-------|
| Classiques Absolus | Gratuit | 🎤 |
| Légendes 90s/2000s | Premium | 👑 |
| Nouvelle École | Grind (20 victoires + 150 bonnes réponses) | 🔥 |
| Plume & Mélodie | Premium | ✨ |
| Spécial PNL | Premium | 🌙 |

---

## 🗺️ Roadmap Post-MVP

### Ce qui reste à faire

1. ☐ Intégration IAP réelle (in_app_purchase package)
2. ☐ Contenu légalement validé (questions et citations)
3. ☐ Images/avatars pour les cartes
4. ☐ Système de leaderboard global
5. ☐ Mode tournoi (bracket)
6. ☐ Partage de score sur les réseaux sociaux
7. ☐ Système d'amis / liste de contacts
8. ☐ Notifications push configurées côté serveur
9. ☐ Analytics Firebase Events
10. ☐ Mode hors-ligne (cache Firestore)
11. ☐ Fonts Poppins locales (assets/fonts/)
12. ☐ Modération du contenu (admin panel)
13. ☐ Tests unitaires et d'intégration

---

## 🎨 Palette de couleurs

| Nom | Hex | Usage |
|-----|-----|-------|
| Background | `#0A0A0F` | Fond principal |
| Surface | `#14141F` | Cartes, bottom nav |
| Surface Variant | `#1E1E2E` | Inputs, tuiles |
| Primary | `#7C3AED` | Violet — actions principales |
| Secondary | `#3B82F6` | Bleu électrique |
| Accent | `#F59E0B` | Or/Ambre — coins, highlights |
| Success | `#10B981` | Bonnes réponses |
| Error | `#EF4444` | Mauvaises réponses, erreurs |

---

## ⚖️ Avertissement Légal

Les questions et citations incluses dans cette version de développement sont **entièrement fictives** et créées à des fins d'illustration. Elles ne représentent pas les paroles réelles des artistes mentionnés.

Avant toute publication :
- Faire valider chaque citation par un juriste spécialisé en droit de la propriété intellectuelle
- S'assurer du respect du droit de citation (article L122-5 du CPI)
- Obtenir les autorisations nécessaires auprès des ayants droit
