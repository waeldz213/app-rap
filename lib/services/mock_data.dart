// Mock data — Firebase désactivé pour les tests en local
import '../models/user_model.dart';
import '../models/question_model.dart';
import '../models/card_model.dart';
import '../models/pack_model.dart';
import '../models/duel_model.dart';
import '../models/daily_challenge_model.dart';

class MockData {
  // Utilisateur mock connecté
  static final UserModel currentUser = UserModel(
    id: 'mock-user-1',
    email: 'test@mock.com',
    displayName: 'RapFan42',
    isPremium: false,
    xp: 3400,
    level: 7,
    coins: 250,
    stats: const UserStats(
      totalQuizzes: 20,
      totalCorrect: 85,
      totalQuestions: 100,
      currentStreak: 3,
      maxStreak: 7,
      totalDuels: 20,
      duelWins: 12,
      totalCards: 3,
      boostersOpened: 5,
      dailyChallengesCompleted: 8,
    ),
    equippedCardIds: ['card_pnl_chico'],
    createdAt: DateTime(2024, 1, 1),
    lastLoginAt: DateTime.now(),
  );

  // Questions mock
  static final List<QuestionModel> questions = [
    const QuestionModel(
      id: 'q1',
      packId: 'pack-1',
      type: QuestionType.whoSaidThis,
      questionText: 'Quel groupe de rap est formé par les frères Ademo et N.O.S ?',
      correctAnswer: 'PNL',
      choices: ['PNL', 'Sexion d\'Assaut', 'Kery James & Youssoupha', 'Mafia K\'1 Fry'],
      artistName: 'PNL',
      difficulty: 1,
    ),
    const QuestionModel(
      id: 'q2',
      packId: 'pack-1',
      type: QuestionType.whoSaidThis,
      questionText: 'Quel rappeur est originaire de Sevran et connu pour son style agressif ?',
      correctAnswer: 'Kaaris',
      choices: ['Kaaris', 'Booba', 'La Fouine', 'Rohff'],
      artistName: 'Kaaris',
      difficulty: 1,
    ),
    const QuestionModel(
      id: 'q3',
      packId: 'pack-2',
      type: QuestionType.whoSaidThis,
      questionText: 'Quel rappeur marseillais a sorti l\'album "JVLIVS" ?',
      correctAnswer: 'SCH',
      choices: ['SCH', 'Jul', 'IAM', 'Soprano'],
      artistName: 'SCH',
      difficulty: 2,
    ),
    const QuestionModel(
      id: 'q4',
      packId: 'pack-2',
      type: QuestionType.whoSaidThis,
      questionText: 'Quel rappeur ultra-productif est incontournable de la scène marseillaise ?',
      correctAnswer: 'Jul',
      choices: ['Jul', 'SCH', 'IAM', 'Soprano'],
      artistName: 'Jul',
      difficulty: 1,
    ),
    const QuestionModel(
      id: 'q5',
      packId: 'pack-2',
      type: QuestionType.whoSaidThis,
      questionText: 'Quel rappeur est le recordman de certifications en France ?',
      correctAnswer: 'Ninho',
      choices: ['Ninho', 'Jul', 'PNL', 'Booba'],
      artistName: 'Ninho',
      difficulty: 2,
    ),
    const QuestionModel(
      id: 'q6',
      packId: 'pack-3',
      type: QuestionType.completePunchline,
      questionText: 'Complète : "Au DD, au DD, au DD…"',
      correctAnswer: 'PNL',
      choices: ['PNL', 'Freeze Corleone', 'Nekfeu', 'Booba'],
      missingWord: 'DD',
      artistName: 'PNL',
      difficulty: 3,
    ),
  ];

  // Cartes mock
  static final List<CardModel> cards = [
    const CardModel(
      id: 'card_jul_flow',
      artistName: 'Jul',
      rarity: CardRarity.commune,
      title: 'Le Flow du Sud',
      flavorText: "L'incontournable du sud, prolifique et attachant.",
      bonusType: 'score_boost',
      bonusValue: 0.05,
    ),
    const CardModel(
      id: 'card_ninho_roi',
      artistName: 'Ninho',
      rarity: CardRarity.commune,
      title: 'Le Roi du Mélo',
      flavorText: 'Mélodies accrocheuses et authenticité.',
      bonusType: 'score_boost',
      bonusValue: 0.05,
    ),
    const CardModel(
      id: 'card_sch_archi',
      artistName: 'SCH',
      rarity: CardRarity.commune,
      title: "L'Architecte",
      flavorText: 'Constructeur de sonorités froides et tranchantes.',
      bonusType: 'score_boost',
      bonusValue: 0.05,
    ),
    const CardModel(
      id: 'card_pnl_chico',
      artistName: 'PNL',
      rarity: CardRarity.rare,
      title: 'Le Monde Chico Era',
      flavorText: "L'ascension des frères de Tarterêts.",
      bonusType: 'score_boost',
      bonusValue: 0.08,
    ),
    const CardModel(
      id: 'card_booba_temps_mort',
      artistName: 'Booba',
      rarity: CardRarity.rare,
      title: 'Temps Mort Era',
      flavorText: "L'album qui a tout changé.",
      bonusType: 'score_boost',
      bonusValue: 0.08,
    ),
    const CardModel(
      id: 'card_nekfeu_alpha',
      artistName: 'Nekfeu & Alpha Wann',
      rarity: CardRarity.epique,
      title: 'Feat Légendaire',
      flavorText: 'Quand deux génies se rencontrent.',
      bonusType: 'score_boost',
      bonusValue: 0.10,
    ),
    const CardModel(
      id: 'card_booba_duc',
      artistName: 'Booba',
      rarity: CardRarity.legendaire,
      title: 'Le Duc Ultime',
      flavorText: 'Le règne incontesté du Duc de Boulogne.',
      bonusType: 'score_boost',
      bonusValue: 0.15,
    ),
  ];

  // Cartes de l'utilisateur (les 3 premières)
  static List<CardModel> get userCards =>
      cards.take(3).toList();

  // Packs mock
  static final List<PackModel> packs = [
    const PackModel(
      id: 'pack-1',
      title: 'Classiques 90s',
      subtitle: 'Les pionniers du rap français',
      description: 'Les figures incontournables qui ont fondé la scène rap française.',
      theme: 'histoire',
      isFree: true,
      priceType: 'free',
      isActive: true,
      sortOrder: 1,
      coverImageUrl: '',
      gradientStart: '#7C3AED',
      gradientEnd: '#3B82F6',
      iconEmoji: '🎤',
      questionCount: 2,
    ),
    const PackModel(
      id: 'pack-2',
      title: 'Nouvelle Vague',
      subtitle: 'Les artistes des années 2010',
      description: 'Les artistes qui ont tout changé dans les années 2010.',
      theme: 'moderne',
      isFree: true,
      priceType: 'free',
      isActive: true,
      sortOrder: 2,
      coverImageUrl: '',
      gradientStart: '#EC4899',
      gradientEnd: '#F59E0B',
      iconEmoji: '🔥',
      questionCount: 3,
    ),
    const PackModel(
      id: 'pack-3',
      title: 'Pack Premium',
      subtitle: 'Pour les vrais connaisseurs',
      description: 'Questions ultra-dures pour les vrais connaisseurs du rap français.',
      theme: 'premium',
      isFree: false,
      priceType: 'subscription',
      isActive: true,
      sortOrder: 3,
      coverImageUrl: '',
      gradientStart: '#F59E0B',
      gradientEnd: '#EF4444',
      iconEmoji: '👑',
      questionCount: 1,
    ),
  ];

  // Défi du jour mock
  static final DailyChallengeModel dailyChallenge = DailyChallengeModel(
    id: '2026-04-01',
    date: '2026-04-01',
    packId: 'pack-1',
    packTitle: 'Classiques 90s',
    questionIds: ['q1', 'q2', 'q3'],
    bonusCoins: 50,
    bonusXp: 100,
    createdAt: DateTime(2026, 4, 1),
  );

  // Duels mock
  static final List<DuelModel> duels = [
    DuelModel(
      id: 'duel-1',
      packId: 'pack-1',
      packTitle: 'Classiques 90s',
      inviteCode: 'MOCK42',
      initiatorUserId: 'mock-user-1',
      initiatorDisplayName: 'RapFan42',
      opponentUserId: 'mock-user-2',
      opponentDisplayName: 'KingRap',
      status: DuelStatus.waiting,
      questionIds: ['q1', 'q2', 'q3'],
      createdAt: DateTime.now(),
    ),
  ];
}
