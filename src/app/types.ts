export interface Pack {
  id: string;
  name: string;
  description: string;
  emoji: string;
  totalQuestions: number;
  access: 'free' | 'premium' | 'grind';
  grindRequirements?: {
    victories: number;
    correctAnswers: number;
  };
  color: string;
  category: string;
}

export interface Question {
  id: string;
  packId: string;
  type: 'whoSaidThis' | 'completePunchline';
  questionText: string;
  correctAnswer: string;
  choices: string[];
  artistName?: string;
  sourceTrack?: string;
  sourceAlbum?: string;
  difficulty: 1 | 2 | 3;
  missingWord?: string;
}

export type CardRarity = 'commune' | 'rare' | 'epique' | 'legendaire';

export interface Card {
  id: string;
  artistName: string;
  packId: string;
  rarity: CardRarity;
  imageUrl?: string;
  description: string;
  stats: {
    flow: number;
    texte: number;
    impact: number;
  };
}

export interface User {
  id: string;
  username: string;
  level: number;
  xp: number;
  xpToNextLevel: number;
  coins: number;
  streak: number;
  victories: number;
  correctAnswers: number;
  totalAnswers: number;
  collectedCardIds: string[];
  unlockedPackIds: string[];
  isPremium: boolean;
}

export interface DuelState {
  id: string;
  packId: string;
  status: 'waiting' | 'in_progress' | 'completed';
  player1Score: number;
  player2Score: number;
  currentQuestion: number;
  inviteCode: string;
}

export interface DailyChallenge {
  id: string;
  date: string;
  packId: string;
  questionIds: string[];
  reward: {
    coins: number;
    xp: number;
  };
}

export interface QuizResult {
  correctAnswers: number;
  totalQuestions: number;
  timeSpent: number;
  xpEarned: number;
  coinsEarned: number;
  cardUnlocked?: Card;
}
