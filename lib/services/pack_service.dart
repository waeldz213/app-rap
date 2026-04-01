import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pack_model.dart';
import '../models/question_model.dart';
import '../config/constants.dart';

class PackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PackModel>> getPacks() async {
    final snap = await _firestore
        .collection(AppConstants.packsCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('sortOrder')
        .get();
    return snap.docs
        .map((doc) => PackModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<PackModel?> getPackById(String packId) async {
    final doc = await _firestore
        .collection(AppConstants.packsCollection)
        .doc(packId)
        .get();
    if (!doc.exists) return null;
    return PackModel.fromJson(doc.data()!, doc.id);
  }

  Future<List<QuestionModel>> getQuestionsForPack(
    String packId, {
    int limit = AppConstants.questionsPerSession,
  }) async {
    final snap = await _firestore
        .collection(AppConstants.packsCollection)
        .doc(packId)
        .collection(AppConstants.questionsCollection)
        .where('isActive', isEqualTo: true)
        .limit(limit * 3) // Fetch more to shuffle
        .get();

    final questions = snap.docs
        .map((doc) => QuestionModel.fromJson(doc.data(), doc.id))
        .toList();

    questions.shuffle();
    return questions.take(limit).toList();
  }

  Future<bool> userHasAccess(
    String userId,
    PackModel pack,
    bool isPremium,
    int duelWins,
    int soloCorrect,
  ) async {
    if (pack.isFree) return true;
    if (isPremium && pack.priceType == 'subscription') return true;
    if (pack.priceType == 'grind' && pack.grindRequirement != null) {
      final req = pack.grindRequirement!;
      return duelWins >= req.duelWinsRequired &&
          soloCorrect >= req.soloCorrectRequired;
    }
    return false;
  }

  /// Seed initial packs to Firestore (call once from admin)
  Future<void> seedInitialPacks() async {
    final packs = _getSeedPacks();
    final batch = _firestore.batch();

    for (final pack in packs) {
      final ref =
          _firestore.collection(AppConstants.packsCollection).doc(pack.id);
      batch.set(ref, pack.toJson(), SetOptions(merge: true));
    }

    await batch.commit();

    // Seed questions for each pack
    for (final pack in packs) {
      await _seedQuestionsForPack(pack.id);
    }
  }

  List<PackModel> _getSeedPacks() {
    return [
      PackModel(
        id: 'pack_classiques',
        title: 'Classiques Absolus',
        subtitle: 'Les hits que tout le monde connaît',
        description:
            'Les punchlines incontournables du rap français. Refrains légendaires, flows mythiques.',
        theme: 'classics',
        isFree: true,
        priceType: 'free',
        isActive: true,
        sortOrder: 1,
        coverImageUrl: '',
        gradientStart: '#7C3AED',
        gradientEnd: '#3B82F6',
        iconEmoji: '🎤',
      ),
      PackModel(
        id: 'pack_legendes',
        title: 'Légendes 90s/2000s',
        subtitle: 'IAM, NTM, Booba, Médine et plus',
        description:
            "L'âge d'or du rap FR. IAM, Assassin, Kery James, Booba, Médine, Rohff, La Cliqua, Oxmo.",
        theme: 'oldschool',
        isFree: false,
        priceType: 'subscription',
        isActive: true,
        sortOrder: 2,
        coverImageUrl: '',
        gradientStart: '#F59E0B',
        gradientEnd: '#F97316',
        iconEmoji: '👑',
      ),
      PackModel(
        id: 'pack_nouvelle_ecole',
        title: 'Nouvelle École',
        subtitle: 'Drill FR & nouvelle vague',
        description:
            'Le rap de maintenant. Drill française, codes actuels, flow contemporains.',
        theme: 'newschool',
        isFree: false,
        priceType: 'grind',
        isActive: true,
        sortOrder: 3,
        coverImageUrl: '',
        gradientStart: '#EF4444',
        gradientEnd: '#F97316',
        iconEmoji: '🔥',
        grindRequirement: const GrindRequirement(
          duelWinsRequired: 20,
          soloCorrectRequired: 150,
        ),
      ),
      PackModel(
        id: 'pack_plume_melodie',
        title: 'Plume & Mélodie',
        subtitle: 'Introspection, écriture & cloud rap',
        description:
            'Le rap poétique et mélodique. Écriture soignée, introspection, sons planants.',
        theme: 'melodic',
        isFree: false,
        priceType: 'subscription',
        isActive: true,
        sortOrder: 4,
        coverImageUrl: '',
        gradientStart: '#3B82F6',
        gradientEnd: '#7C3AED',
        iconEmoji: '✨',
      ),
      PackModel(
        id: 'pack_pnl',
        title: 'Spécial PNL',
        subtitle: "Tout l'univers PNL",
        description:
            "L'univers unique des frères de Tarterêts. Atmosphère, profondeur, identité.",
        theme: 'pnl',
        isFree: false,
        priceType: 'subscription',
        isActive: true,
        sortOrder: 5,
        coverImageUrl: '',
        gradientStart: '#1a1a2e',
        gradientEnd: '#7C3AED',
        iconEmoji: '🌙',
      ),
    ];
  }

  Future<void> _seedQuestionsForPack(String packId) async {
    final questions = _getSeedQuestions(packId);
    if (questions.isEmpty) return;

    final batch = _firestore.batch();
    for (final q in questions) {
      final ref = _firestore
          .collection(AppConstants.packsCollection)
          .doc(packId)
          .collection(AppConstants.questionsCollection)
          .doc(q.id);
      batch.set(ref, q.toJson(), SetOptions(merge: true));
    }
    await batch.commit();
  }

  // IMPORTANT: These questions use fictional/generic citations inspired by
  // French rap style. Final content MUST be legally validated before
  // publishing. Ensure proper droit de citation compliance.
  List<QuestionModel> _getSeedQuestions(String packId) {
    switch (packId) {
      case 'pack_classiques':
        return _classiquesQuestions();
      case 'pack_legendes':
        return _legendesQuestions();
      case 'pack_nouvelle_ecole':
        return _nouvelleEcoleQuestions();
      case 'pack_plume_melodie':
        return _plumeMelodieQuestions();
      case 'pack_pnl':
        return _pnlQuestions();
      default:
        return [];
    }
  }

  // FICTIONAL content - to be replaced with legally validated content
  List<QuestionModel> _classiquesQuestions() {
    return [
      QuestionModel(
        id: 'q_classiques_001',
        packId: 'pack_classiques',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Le monde est à nous, les étoiles aussi, même si la route est longue on ira jusqu\'ici"',
        correctAnswer: 'Rohff',
        choices: ['Rohff', 'Booba', 'La Fouine', 'Awa Imani'],
        artistName: 'Rohff',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_classiques_002',
        packId: 'pack_classiques',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Je suis né dans la rue, j\'ai grandi dans la nuit, le béton était mon école, la musique ma vie"',
        correctAnswer: 'Kaaris',
        choices: ['Kaaris', 'SCH', 'Jul', 'Ninho'],
        artistName: 'Kaaris',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_classiques_003',
        packId: 'pack_classiques',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Mon stylo est une arme, mes rimes sont des balles, je tire sur les faux semblants depuis la capitale"',
        correctAnswer: 'Nekfeu',
        choices: ['Nekfeu', 'Alpha Wann', 'Vald', 'Lomepal'],
        artistName: 'Nekfeu',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_classiques_004',
        packId: 'pack_classiques',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Le flow coule comme une rivière, les mots sont des pierres précieuses, chaque rime est sincère"',
        correctAnswer: 'Oxmo Puccino',
        choices: ['Oxmo Puccino', 'Médine', 'Kery James', 'Rocé'],
        artistName: 'Oxmo Puccino',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_classiques_005',
        packId: 'pack_classiques',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Dans ma cité on n\'attend pas la chance, on la crée, le soleil brille même sous la pluie ici"',
        correctAnswer: 'Jul',
        choices: ['Jul', 'Soprano', 'Alonzo', 'Naps'],
        artistName: 'Jul',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_classiques_006',
        packId: 'pack_classiques',
        type: QuestionType.completePunchline,
        questionText: '"Je suis le roi de ma rue, le ___ de mon quartier"',
        correctAnswer: 'maître',
        choices: ['maître', 'frère', 'père', 'fils'],
        missingWord: 'maître',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_classiques_007',
        packId: 'pack_classiques',
        type: QuestionType.completePunchline,
        questionText:
            '"Les nuages passent mais le ___ reste, comme les vraies amitiés"',
        correctAnswer: 'soleil',
        choices: ['soleil', 'vent', 'bruit', 'temps'],
        missingWord: 'soleil',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_classiques_008',
        packId: 'pack_classiques',
        type: QuestionType.completePunchline,
        questionText: '"Mon flow est liquide comme l\'___, il coule partout"',
        correctAnswer: 'eau',
        choices: ['eau', 'air', 'feu', 'sang'],
        missingWord: 'eau',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_classiques_009',
        packId: 'pack_classiques',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Chaque jour je me lève avec la rage au ventre, la haine me propulse, la musique me centre"',
        correctAnswer: 'Booba',
        choices: ['Booba', 'Rohff', 'Sefyu', 'Alkpote'],
        artistName: 'Booba',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_classiques_010',
        packId: 'pack_classiques',
        type: QuestionType.whoSaidThis,
        questionText:
            '"La nuit je compte mes étoiles, le matin je compte mes billets, la vie est belle quand tu travailles"',
        correctAnswer: 'Ninho',
        choices: ['Ninho', 'Alonzo', 'Lartiste', 'Gradur'],
        artistName: 'Ninho',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
    ];
  }

  // FICTIONAL content - to be replaced with legally validated content
  List<QuestionModel> _legendesQuestions() {
    return [
      QuestionModel(
        id: 'q_legendes_001',
        packId: 'pack_legendes',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Depuis les pyramides jusqu\'aux tours HLM, notre histoire traverse les siècles et les systèmes"',
        correctAnswer: 'IAM',
        choices: ['IAM', 'Assassin', 'NTM', 'Alliance Ethnik'],
        artistName: 'IAM',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_legendes_002',
        packId: 'pack_legendes',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Paris est à nous, la cité brûle, les flics reculent, c\'est notre rue"',
        correctAnswer: 'Suprême NTM',
        choices: ['Suprême NTM', 'MC Solaar', 'IAM', 'Assassin'],
        artistName: 'Suprême NTM',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_legendes_003',
        packId: 'pack_legendes',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Je porte la parole des sans-voix, des oubliés, des exilés dans leur propre pays"',
        correctAnswer: 'Kery James',
        choices: ['Kery James', 'Médine', 'Rocé', 'Casey'],
        artistName: 'Kery James',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_legendes_004',
        packId: 'pack_legendes',
        type: QuestionType.whoSaidThis,
        questionText:
            '"B2OBA, le duc de Boulogne, mon cartel domine, les autres s\'éloignent"',
        correctAnswer: 'Booba',
        choices: ['Booba', 'Rim-K', 'Ali', 'Maska'],
        artistName: 'Booba',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_legendes_005',
        packId: 'pack_legendes',
        type: QuestionType.whoSaidThis,
        questionText:
            '"La plume comme une épée, la vérité comme un bouclier, je bats en retraite jamais"',
        correctAnswer: 'Médine',
        choices: ['Médine', 'Youssoupha', 'Kery James', 'Oxmo Puccino'],
        artistName: 'Médine',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_legendes_006',
        packId: 'pack_legendes',
        type: QuestionType.completePunchline,
        questionText: '"On est là depuis le ___, nos racines sont profondes"',
        correctAnswer: 'début',
        choices: ['début', 'fin', 'bas', 'haut'],
        missingWord: 'début',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_legendes_007',
        packId: 'pack_legendes',
        type: QuestionType.completePunchline,
        questionText: '"Le mic est ma ___, les mots sont mes munitions"',
        correctAnswer: 'arme',
        choices: ['arme', 'vie', 'joie', 'croix'],
        missingWord: 'arme',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_legendes_008',
        packId: 'pack_legendes',
        type: QuestionType.whoSaidThis,
        questionText:
            '"La cité dortoir se réveille au son des sirènes, les enfants courent, les mères prient en silence"',
        correctAnswer: 'Oxmo Puccino',
        choices: ['Oxmo Puccino', 'Rocé', 'Démocrite', 'Lino'],
        artistName: 'Oxmo Puccino',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 3,
      ),
    ];
  }

  // FICTIONAL content - to be replaced with legally validated content
  List<QuestionModel> _nouvelleEcoleQuestions() {
    return [
      QuestionModel(
        id: 'q_nouvelle_001',
        packId: 'pack_nouvelle_ecole',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Drill dans la ville, les sons tranchent comme des lames, chaque barre est une cicatrice"',
        correctAnswer: 'SCH',
        choices: ['SCH', 'Hamza', 'Freeze Corleone', 'Niska'],
        artistName: 'SCH',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_nouvelle_002',
        packId: 'pack_nouvelle_ecole',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Je compte les zéros sur mon compte, les ennemis comptent leurs dettes"',
        correctAnswer: 'Niska',
        choices: ['Niska', 'Gambi', 'Leto', 'Alonzo'],
        artistName: 'Niska',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_nouvelle_003',
        packId: 'pack_nouvelle_ecole',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Les étoiles s\'alignent quand je rap, l\'univers conspire pour que j\'arrive au sommet"',
        correctAnswer: 'Freeze Corleone',
        choices: ['Freeze Corleone', 'Ninho', 'DA Uzi', 'Le Motif'],
        artistName: 'Freeze Corleone',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_nouvelle_004',
        packId: 'pack_nouvelle_ecole',
        type: QuestionType.completePunchline,
        questionText: '"On vient de loin mais on va encore plus ___ maintenant"',
        correctAnswer: 'loin',
        choices: ['loin', 'haut', 'fort', 'vite'],
        missingWord: 'loin',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_nouvelle_005',
        packId: 'pack_nouvelle_ecole',
        type: QuestionType.whoSaidThis,
        questionText:
            '"La trap c\'est ma fondation, le rap c\'est ma religion, le studio c\'est ma confession"',
        correctAnswer: 'Hamza',
        choices: ['Hamza', 'Tion Wayne', 'Guy2Bezbar', 'Tiakola'],
        artistName: 'Hamza',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_nouvelle_006',
        packId: 'pack_nouvelle_ecole',
        type: QuestionType.completePunchline,
        questionText: '"Mon flow est ___ comme une lame de rasoir"',
        correctAnswer: 'tranchant',
        choices: ['tranchant', 'doux', 'lent', 'chaud'],
        missingWord: 'tranchant',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_nouvelle_007',
        packId: 'pack_nouvelle_ecole',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Tous les soirs je compte mes blessures, chaque cicatrice me rappelle d\'où je viens"',
        correctAnswer: 'Leto',
        choices: ['Leto', 'Zola', 'DA Uzi', 'Kerchak'],
        artistName: 'Leto',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_nouvelle_008',
        packId: 'pack_nouvelle_ecole',
        type: QuestionType.whoSaidThis,
        questionText:
            '"La rue m\'a façonné, le son m\'a sauvé, maintenant c\'est moi qui sauve les autres"',
        correctAnswer: 'Ninho',
        choices: ['Ninho', 'Lefa', 'Rim-K', 'Joke'],
        artistName: 'Ninho',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
    ];
  }

  // FICTIONAL content - to be replaced with legally validated content
  List<QuestionModel> _plumeMelodieQuestions() {
    return [
      QuestionModel(
        id: 'q_plume_001',
        packId: 'pack_plume_melodie',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Les mots s\'envolent comme des oiseaux migrateurs, ils reviennent toujours à la saison des douleurs"',
        correctAnswer: 'Lomepal',
        choices: ['Lomepal', 'Eddy de Pretto', 'Roméo Elvis', 'Orelsan'],
        artistName: 'Lomepal',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_plume_002',
        packId: 'pack_plume_melodie',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Je suis fait de contradictions, de lumière et d\'ombre, de silence et de bruit"',
        correctAnswer: 'Orelsan',
        choices: ['Orelsan', 'Gringe', 'Lomepal', 'Vald'],
        artistName: 'Orelsan',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_plume_003',
        packId: 'pack_plume_melodie',
        type: QuestionType.completePunchline,
        questionText: '"La mélodie de ma vie est triste mais je continue à ___"',
        correctAnswer: 'chanter',
        choices: ['chanter', 'pleurer', 'courir', 'mentir'],
        missingWord: 'chanter',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_plume_004',
        packId: 'pack_plume_melodie',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Je peins mes émotions avec des mots, chaque album est une nouvelle toile"',
        correctAnswer: 'Vald',
        choices: ['Vald', 'Dinos', 'Nekfeu', 'JoeyStarr'],
        artistName: 'Vald',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_plume_005',
        packId: 'pack_plume_melodie',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Dans mes rêves je cours sans m\'arrêter, la réalité me rattrape toujours au réveil"',
        correctAnswer: 'Dinos',
        choices: ['Dinos', 'Lomepal', 'Benjamin Epps', 'Zed Yun Pavarotti'],
        artistName: 'Dinos',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 3,
      ),
      QuestionModel(
        id: 'q_plume_006',
        packId: 'pack_plume_melodie',
        type: QuestionType.completePunchline,
        questionText: '"Les ___ de mon âme résonnent dans chaque note"',
        correctAnswer: 'vibrations',
        choices: ['vibrations', 'douleurs', 'joies', 'peurs'],
        missingWord: 'vibrations',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_plume_007',
        packId: 'pack_plume_melodie',
        type: QuestionType.whoSaidThis,
        questionText:
            '"L\'amour et la haine sont les deux faces d\'une même pièce que je lance en l\'air"',
        correctAnswer: 'Roméo Elvis',
        choices: ['Roméo Elvis', 'Lomepal', 'Caballero', 'JeanJass'],
        artistName: 'Roméo Elvis',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_plume_008',
        packId: 'pack_plume_melodie',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Le cloud au-dessus de ma tête est fait de mes pensées, il pleut quand je pleure"',
        correctAnswer: 'Lomepal',
        choices: ['Lomepal', 'Hamza', 'Soolking', 'Amine'],
        artistName: 'Lomepal',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
    ];
  }

  // FICTIONAL content - to be replaced with legally validated content
  List<QuestionModel> _pnlQuestions() {
    return [
      QuestionModel(
        id: 'q_pnl_001',
        packId: 'pack_pnl',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Les tours de ma cité touchent les nuages, mais moi j\'ai appris à voler plus haut"',
        correctAnswer: 'PNL',
        choices: ['PNL', 'Lefa', 'Hamza', 'Freeze Corleone'],
        artistName: 'PNL',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_pnl_002',
        packId: 'pack_pnl',
        type: QuestionType.whoSaidThis,
        questionText:
            '"La lune nous guide, les étoiles nous protègent, Tarterêts dans nos cœurs pour toujours"',
        correctAnswer: 'PNL',
        choices: ['PNL', 'DA Uzi', 'Ninho', 'Soolking'],
        artistName: 'PNL',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_pnl_003',
        packId: 'pack_pnl',
        type: QuestionType.completePunchline,
        questionText: '"On a grandi dans l\'___, aujourd\'hui on vit dans les nuages"',
        correctAnswer: 'ombre',
        choices: ['ombre', 'bruit', 'froid', 'béton'],
        missingWord: 'ombre',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_pnl_004',
        packId: 'pack_pnl',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Les deux frères, deux âmes, une seule vision, le monde entier à nos pieds"',
        correctAnswer: 'PNL',
        choices: ['PNL', 'Bigflo & Oli', 'Sofiane', 'Awa Imani'],
        artistName: 'PNL',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_pnl_005',
        packId: 'pack_pnl',
        type: QuestionType.completePunchline,
        questionText: '"Le ___ de nos pères est devenu notre force"',
        correctAnswer: 'sang',
        choices: ['sang', 'rêve', 'nom', 'passé'],
        missingWord: 'sang',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_pnl_006',
        packId: 'pack_pnl',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Leurs sons planent au-dessus des nuages, portés par des mélodies hantées et des flows hypnotiques"',
        correctAnswer: 'PNL',
        choices: ['PNL', 'Hamza', 'Tiakola', 'Guy2Bezbar'],
        artistName: 'PNL',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 2,
      ),
      QuestionModel(
        id: 'q_pnl_007',
        packId: 'pack_pnl',
        type: QuestionType.completePunchline,
        questionText: '"Dans nos ___, on trouve la vérité de nos vies"',
        correctAnswer: 'sons',
        choices: ['sons', 'yeux', 'mains', 'rêves'],
        missingWord: 'sons',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
      QuestionModel(
        id: 'q_pnl_008',
        packId: 'pack_pnl',
        type: QuestionType.whoSaidThis,
        questionText:
            '"Partir loin, mais revenir toujours, car les racines sont plus fortes que le vent"',
        correctAnswer: 'PNL',
        choices: ['PNL', 'Soolking', 'Abou Tall', 'Zola'],
        artistName: 'PNL',
        sourceTrack: '(fictif - à valider légalement)',
        difficulty: 1,
      ),
    ];
  }
}
