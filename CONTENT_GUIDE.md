# Guide de Contenu — App Rap

Ce guide explique comment ajouter des packs, questions et cartes dans Firestore.

---

## Ajouter un Pack

Collection Firestore : `packs`

```json
{
  "id": "booba-2000s",
  "name": "Booba — Années 2000",
  "description": "Testez vos connaissances sur la discographie de Booba des années 2000",
  "imageUrl": "https://storage.example.com/packs/booba-2000s.jpg",
  "isPremium": false,
  "price": null,
  "questionCount": 20,
  "category": "artiste",
  "artist": "Booba",
  "era": "2000-2010",
  "difficulty": 3,
  "totalPlays": 0,
  "grindRequirement": null,
  "isActive": true,
  "createdAt": "Timestamp Firestore"
}
```

### Pack avec condition Grind

```json
{
  "grindRequirement": {
    "duelWinsRequired": 20,
    "soloCorrectRequired": 150
  }
}
```

---

## Ajouter des Questions

Collection Firestore : `questions`

### Question à choix multiples

```json
{
  "id": "q_booba_001",
  "packId": "booba-2000s",
  "type": "multipleChoice",
  "question": "En quelle année est sorti l'album 'Lunatic' de Booba ?",
  "options": ["1999", "2000", "2001", "2002"],
  "correctAnswer": "2000",
  "explanation": "L'album Lunatic est sorti le 19 septembre 2000 sous le label Roc La Familia.",
  "difficulty": 2,
  "mediaUrl": null,
  "isActive": true
}
```

### Question Vrai/Faux

```json
{
  "id": "q_booba_002",
  "packId": "booba-2000s",
  "type": "trueFalse",
  "question": "Booba est membre du groupe Lunatic avec Ali.",
  "options": ["Vrai", "Faux"],
  "correctAnswer": "Vrai",
  "explanation": "Booba (Élie Yaffa) et Ali (Régis Mwamba) forment le duo Lunatic.",
  "difficulty": 1,
  "mediaUrl": null,
  "isActive": true
}
```

### Question avec image

```json
{
  "mediaUrl": "https://storage.example.com/questions/pochette-0.9.jpg",
  "question": "À quel album appartient cette pochette ?"
}
```

---

## Ajouter des Cartes

Collection Firestore : `cards`

```json
{
  "id": "card_booba_legendary",
  "name": "Booba — Légende",
  "description": "Le Duc de Boulogne. Pionnier du rap français depuis les années 90.",
  "imageUrl": "https://storage.example.com/cards/booba-legendary.jpg",
  "rarity": "legendary",
  "artist": "Booba",
  "era": "1990-2024",
  "bonusType": "score",
  "bonusValue": 0.10,
  "packId": "booba-2000s"
}
```

### Raretés disponibles
| Valeur | Affichage | Taux de drop | Couleur |
|--------|-----------|--------------|---------|
| `commune` | Commune | 60% | Gris |
| `rare` | Rare | 25% | Bleu |
| `epic` | Épique | 12% | Violet |
| `legendary` | Légendaire | 3% | Or |

### Types de bonus
| `bonusType` | `bonusValue` | Effet |
|-------------|--------------|-------|
| `score` | `0.10` | +10% de score quand équipée |
| `xp` | `0.15` | +15% XP gagné |
| `coins` | `0.05` | +5% pièces gagnées |

---

## Assets Images

### Packs
- Format recommandé : JPG ou WebP
- Dimensions : **600×400px** (ratio 3:2)
- Max : 200 Ko
- Nommage : `{pack-id}.jpg`

### Cartes
- Format recommandé : JPG ou PNG avec fond
- Dimensions : **400×560px** (ratio portrait, similaire à une carte à jouer)
- Max : 150 Ko
- Nommage : `{card-id}.jpg`

### Questions (media optionnel)
- Format : JPG ou PNG
- Dimensions : **800×400px**
- Max : 300 Ko

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
  console.log('Import terminé!');
}

importData().catch(console.error);
```

---

## Défi Quotidien

Le défi quotidien est généré automatiquement chaque nuit à minuit (heure de Paris) par la Cloud Function `generateDailyChallenge`.

Pour créer un défi manuellement :

```javascript
// Collection: dailyChallenges
// Document ID: YYYY-MM-DD (ex: 2024-01-15)
{
  "id": "2024-01-15",
  "date": "2024-01-15",
  "questionIds": ["q_001", "q_002", ..., "q_010"],
  "completedByUserIds": [],
  "rewards": {
    "coins": 25,
    "xp": 50,
    "boosterChance": 0.30
  }
}
```
