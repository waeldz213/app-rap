# 📝 Guide de Création de Contenu — App Rap

Ce guide explique comment créer et ajouter des questions et des cartes dans l'application.

---

## Types de Questions

### Type 1 — "Qui a dit ça ?" (`whoSaidThis`)

L'utilisateur doit identifier l'artiste qui a prononcé une citation.

**Format Firestore** :
```json
{
  "packId": "pack_classiques",
  "type": "whoSaidThis",
  "questionText": "\"Citation exacte de l'artiste...\"",
  "correctAnswer": "Nom de l'artiste",
  "choices": ["Artiste correct", "Artiste 2", "Artiste 3", "Artiste 4"],
  "artistName": "Nom de l'artiste",
  "sourceTrack": "Titre du morceau",
  "sourceAlbum": "Titre de l'album",
  "difficulty": 1,
  "isActive": true
}
```

**Niveaux de difficulté** :
- `1` — Facile : artistes très connus, citations iconiques
- `2` — Moyen : artistes populaires, citations moins évidentes
- `3` — Difficile : artistes underground, citations obscures

---

### Type 2 — "Complète la punchline" (`completePunchline`)

L'utilisateur doit trouver le mot manquant dans une citation.

**Format Firestore** :
```json
{
  "packId": "pack_classiques",
  "type": "completePunchline",
  "questionText": "\"Début de la phrase avec ___ et suite...\"",
  "correctAnswer": "mot_manquant",
  "choices": ["mot_manquant", "mauvais_choix_1", "mauvais_choix_2", "mauvais_choix_3"],
  "missingWord": "mot_manquant",
  "artistName": "Nom de l'artiste (optionnel)",
  "sourceTrack": "Titre du morceau",
  "sourceAlbum": "Titre de l'album",
  "difficulty": 1,
  "isActive": true
}
```

**Règles** :
- Remplacer le mot manquant par `___` dans `questionText`
- `correctAnswer` et `missingWord` doivent être identiques
- Les 3 mauvaises réponses doivent être plausibles mais clairement incorrectes

---

## Règles de Citation

### ✅ Ce qui est autorisé (Droit de citation — Art. L122-5 CPI)

- Citations courtes à des fins pédagogiques et culturelles
- Indication obligatoire : artiste + morceau + album
- Pas de reproduction intégrale d'une œuvre

### ❌ Ce qui est interdit

- Reproduire des paroles complètes d'un titre
- Utiliser des extraits à des fins commerciales sans autorisation
- Citer sans mentionner la source

### 📋 Checklist avant ajout d'une question

- [ ] La citation est-elle exacte ? (vérifier la source originale)
- [ ] L'artiste est-il correctement identifié ?
- [ ] Le morceau et l'album sont-ils mentionnés ?
- [ ] La citation est-elle suffisamment courte ? (< 2 vers)
- [ ] La question a-t-elle été validée juridiquement ?

---

## Format des Cartes

```json
{
  "artistName": "Nom de l'artiste",
  "rarity": "commune | rare | epique | legendaire",
  "title": "Nom de la carte (era, album, surnom)",
  "flavorText": "Description poétique courte (max 100 chars)",
  "imageUrl": "URL de l'image (optionnel)",
  "bonusType": "score_boost | time_bonus | coin_boost",
  "bonusValue": 0.05,
  "isActive": true
}
```

### Rarités et taux d'apparition

| Rareté | Taux | Bonus Score |
|--------|------|-------------|
| Commune | 60% | +5% |
| Rare | 25% | +8% |
| Épique | 12% | +10% |
| Légendaire | 3% | +15% |

---

## Bonnes Pratiques

1. **Diversité** : Inclure des artistes de toutes les régions et époques
2. **Inclusivité** : Varier les styles (conscient, drill, mélodique, etc.)
3. **Difficulté progressive** : Au moins 40% de questions faciles par pack
4. **4 choix équilibrés** : Les mauvaises réponses doivent être du même "niveau" que la bonne
5. **Pas de bias** : Éviter les questions avec des réponses évidentes par élimination

---

## Template de Question

```
Type: Qui a dit ça ?
Citation: "..."
Artiste: ...
Morceau: ...
Album: ...
Année: ...
Difficulté: 1/2/3
Choix incorrects: [A2], [A3], [A4]
Validation juridique: ☐ En attente / ✅ Validée
```

---

## Contacts Ayants Droit

Pour l'obtention d'autorisations, contacter :
- **SACEM** : Pour les droits d'auteur
- **SDRM** : Pour les droits mécaniques
- **Labels** : Directement pour les droits voisins

---

*Ce document est à usage interne. Toute question juridique doit être soumise à un juriste spécialisé en propriété intellectuelle.*
