import { createContext, useContext, useState, type ReactNode } from 'react';
import type { User, Card, Pack } from '../types';
import { INITIAL_USER, PACKS, CARDS } from '../data';

interface AppContextType {
  user: User;
  packs: Pack[];
  cards: Card[];
  allCards: Card[];
  updateUser: (updates: Partial<User>) => void;
  addCoins: (amount: number) => void;
  addXP: (amount: number) => void;
  unlockPack: (packId: string) => void;
  collectCard: (cardId: string) => void;
  isPackUnlocked: (pack: Pack) => boolean;
}

const AppContext = createContext<AppContextType | null>(null);

export function AppProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User>(INITIAL_USER);

  const updateUser = (updates: Partial<User>) => {
    setUser(prev => ({ ...prev, ...updates }));
  };

  const addCoins = (amount: number) => {
    setUser(prev => ({ ...prev, coins: prev.coins + amount }));
  };

  const addXP = (amount: number) => {
    setUser(prev => {
      const newXP = prev.xp + amount;
      const newLevel = newXP >= prev.xpToNextLevel ? prev.level + 1 : prev.level;
      const newXPToNext = newXP >= prev.xpToNextLevel ? prev.xpToNextLevel * 1.5 : prev.xpToNextLevel;
      return {
        ...prev,
        xp: newXP >= prev.xpToNextLevel ? newXP - prev.xpToNextLevel : newXP,
        level: newLevel,
        xpToNextLevel: Math.floor(newXPToNext),
      };
    });
  };

  const unlockPack = (packId: string) => {
    setUser(prev => ({
      ...prev,
      unlockedPackIds: [...prev.unlockedPackIds, packId],
    }));
  };

  const collectCard = (cardId: string) => {
    setUser(prev => ({
      ...prev,
      collectedCardIds: [...prev.collectedCardIds, cardId],
    }));
  };

  const isPackUnlocked = (pack: Pack): boolean => {
    if (pack.access === 'free') return true;
    if (user.isPremium) return true;
    return user.unlockedPackIds.includes(pack.id);
  };

  const userCards = CARDS.filter(card => user.collectedCardIds.includes(card.id));

  return (
    <AppContext.Provider value={{
      user,
      packs: PACKS,
      cards: userCards,
      allCards: CARDS,
      updateUser,
      addCoins,
      addXP,
      unlockPack,
      collectCard,
      isPackUnlocked,
    }}>
      {children}
    </AppContext.Provider>
  );
}

export function useApp() {
  const context = useContext(AppContext);
  if (!context) throw new Error('useApp must be used within AppProvider');
  return context;
}

