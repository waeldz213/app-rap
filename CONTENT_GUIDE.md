# Guide de Contenu — App Rap

Ce guide explique comment ajouter des packs, questions et cartes dans Firestore.

---

## Ajouter un Pack

Collection Firestore : `packs`

```json
{
  "id": "classiques-absolus",
  "title": "Classiques Absolus",
  "subtitle": "Les hits incontournables",
  "description": "Hits incontournables, refrains et punchlines ultra connues",
  "theme": "Classiques",
  "isFree": true,
  "priceType": "free",
  "iapSkuAndroid": null,
  "iapSkuIos": null,
  "grindRequirement": null,
  "isActive": true,
  "sortOrder": 1,
  "coverImageUrl": "https://storage.example.com/packs/classiques-absolus.jpg",
  "gradientStart": "#7C3AED",
  "gradientEnd": "#3B82F6",
  "iconEmoji": "🎤"
}
```

### Pack Premium avec condition Grind

```json
{
  "id": "legendes-90s",
  "title": "Légendes 90s/2000s",
  "priceType": "grind",
  "grindRequirement": {
    "duelWinsRequired": 20,
    "soloCorrectRequired": 150
  }
}
```

### Types de prix (`priceType`)
| Valeur | Description |
|--------|-------------|
| `free` | Gratuit pour tous |
| `subscription` | Abonnement mensuel/annuel |
| `one_time` | Achat unique du pack |
| `grind` | Débloqué par progression |

---

## Ajouter des Questions

Collection Firestore : `questions`

> **⚠️ Note juridique** : Les citations doivent être courtes (droit de courte citation), accompagnées des métadonnées complètes (artiste + morceau + album + année). Faire valider par un juriste avant publication.

### Type 1 — "Qui a dit ça ?" (`whoSaidIt`)

L'utilisateur doit identifier l'artiste qui a dit la citation.

```json
{
  "id": "q_classiques_001",
  "packId": "classiques-absolus",
  "type": "whoSaidIt",
  "artistName": "Jul",
  "artistId": "jul",
  "quoteText": "Je veux pas d'ta pitié, garde tes larmes pour toi, j'ai le soleil dans ma vie et la force en moi",
  "missingWord": null,
  "choices": ["Jul", "SCH", "Alonzo", "Soso Maness"],
  "correctAnswer": "Jul",
  "difficulty": 1,
  "sourceTrack": "Titre fictif — à remplacer",
  "sourceAlbum": "Album fictif — à remplacer",
  "sourceYear": 2018,
  "citationLabel": "Jul — Titre fictif, Album fictif (2018)",
  "isActive": true
}
```

### Type 2 — "Complète la Punchline" (`completeThePunchline`)

L'utilisateur doit trouver le mot manquant (remplacé par `***`).

```json
{
  "id": "q_classiques_006",
  "packId": "classiques-absolus",
  "type": "completeThePunchline",
  "artistName": "Ninho",
  "artistId": "ninho",
  "quoteText": "J'suis né dans la *** mais j'ai grandi dans la lumière",
  "missingWord": "nuit",
  "choices": ["nuit", "pluie", "rue", "douleur"],
  "correctAnswer": "nuit",
  "difficulty": 2,
  "sourceTrack": "Titre fictif — à remplacer",
  "sourceAlbum": "Album fictif — à remplacer",
  "sourceYear": 2019,
  "citationLabel": "Ninho — Titre fictif, Album fictif (2019)",
  "isActive": true
}
```

### Règles de qualité pour les questions

1. **4 choix toujours** — jamais plus, jamais moins
2. **Crédibilité des mauvais choix** — les artistes ou mots proposés doivent être plausibles dans le contexte
3. **Métadonnées complètes** — `sourceTrack`, `sourceAlbum`, `sourceYear`, `citationLabel` obligatoires
4. **`citationLabel`** — format : `"Artiste — Morceau, Album (Année)"`
5. **Difficulty 1-5** : 1 = très facile (artiste très connu), 5 = expert
6. **`isActive: false`** pour les questions à valider/corriger

---

## Ajouter des Cartes

Collection Firestore : `cards`

```json
{
  "id": "card_booba_legendary",
  "artistName": "Booba",
  "artistId": "booba",
  "rarity": "legendaire",
  "packId": "legendes-90s",
  "title": "Booba — Le Duc Ultime",
  "imageUrl": "https://storage.example.com/cards/booba-legendary.jpg",
  "bonusType": "score_boost",
  "bonusValue": 0.10,
  "flavorText": "Le Duc de Boulogne. Pionnier depuis les 90s.",
  "sourceTrack": null,
  "sourceAlbum": "Temps Mort",
  "isLimited": false
}
```

### Raretés disponibles
| Valeur Firestore | Affichage | Taux de drop | Couleur |
|-----------------|-----------|--------------|---------|
| `commune` | Commune | 60% | Gris |
| `rare` | Rare | 25% | Bleu |
| `epique` | Épique | 12% | Violet |
| `legendaire` | Légendaire | 3% | Or |

### Bonus de carte (`bonusType`)
| `bonusType` | `bonusValue` | Effet |
|-------------|--------------|-------|
| `score_boost` | `0.10` | +10% de score en solo si carte équipée |
| `null` | `null` | Purement collectible |

---

## Exemples de cartes par rareté

### Commune (~60%)
- "Jul - Le Flow du Sud"
- "Ninho - Le Roi du Mélo"
- "SCH - L'Architecte"

### Rare (~25%)
- "PNL - Le Monde Chico Era"
- "Booba - Temps Mort Era"
- "Sefyu - Molotov 4"

### Épique (~12%)
- "Feat Légendaire - Nekfeu x Alpha Wann"
- "Album Culte - Suprême NTM"

### Légendaire (~3%)
- "Booba - Le Duc Ultime"
- "IAM - L'École du Micro d'Argent"
- "Oxmo Puccino - Le Poète"

---

## Assets Images

### Packs
- Format recommandé : JPG ou WebP
- Dimensions : **600×400px** (ratio 3:2)
- Max : 200 Ko
- Nommage : `{pack-id}.jpg`

### Cartes
- Format recommandé : JPG ou PNG
- Dimensions : **400×560px** (ratio portrait, similaire à une carte à jouer)
- Max : 150 Ko
- Nommage : `{card-id}.jpg`

---

## Script d'import Firestore (Node.js)

```javascript
const admin = require('firebase-admin');
admin.initializeApp();
const db = admin.firestore();

const packs = require('./data/packs.json');
const questions = require('./data/questions.json');
const cards = require('./data/cards.json');

async function importData() {
  const batch = db.batch();
  
  packs.forEach(pack => {
    const ref = db.collection('packs').doc(pack.id);
    batch.set(ref, { ...pack, createdAt: admin.firestore.FieldValue.serverTimestamp() });
  });
  
  questions.forEach(q => {
    const ref = db.collection('questions').doc(q.id);
    batch.set(ref, q);
  });
  
  cards.forEach(card => {
    const ref = db.collection('cards').doc(card.id);
    batch.set(ref, card);
  });
  
  await batch.commit();
  console.log('Import terminé !');
}

importData().catch(console.error);
```

---

## Défi Quotidien

Le défi quotidien est généré automatiquement chaque jour à 6h00 (heure de Paris) par la Cloud Function `generateDailyChallenge`.

Pour créer un défi manuellement :

```javascript
// Collection: dailyChallenges
// Document ID: YYYY-MM-DD (ex: 2024-01-15)
{
  "id": "2024-01-15",
  "date": "2024-01-15",
  "packId": "classiques-absolus",
  "questionId": "q_classiques_001",
  "rewardCoins": 25,
  "rewardXp": 50,
  "rewardBoosterChance": 0.30,
  "isActive": true
}
```

