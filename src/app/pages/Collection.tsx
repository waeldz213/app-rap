import { motion } from 'motion/react';
import { useApp } from '../context/AppContext';
import type { CardRarity } from '../types';

const rarityColors: Record<CardRarity, string> = {
  commune: '#6B7280',
  rare: '#3B82F6',
  epique: '#7C3AED',
  legendaire: '#F59E0B',
};

const rarityLabels: Record<CardRarity, string> = {
  commune: 'Commune',
  rare: 'Rare',
  epique: 'Épique',
  legendaire: 'Légendaire',
};

export default function Collection() {
  const { cards, allCards, user } = useApp();

  return (
    <div style={{ padding: '20px', maxWidth: '480px', margin: '0 auto' }}>
      <motion.div initial={{ opacity: 0, y: -20 }} animate={{ opacity: 1, y: 0 }}>
        <h1 style={{ fontSize: '24px', fontWeight: 800, color: '#F9FAFB', marginBottom: '4px' }}>
          Collection 🃏
        </h1>
        <p style={{ color: '#9CA3AF', fontSize: '14px', marginBottom: '24px' }}>
          {cards.length}/{allCards.length} cartes obtenues
        </p>
      </motion.div>

      {/* Progress */}
      <div style={{ background: '#14141F', borderRadius: '12px', padding: '16px', border: '1px solid #2D2D3D', marginBottom: '24px' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
          <span style={{ color: '#F9FAFB', fontSize: '14px', fontWeight: 600 }}>Progression</span>
          <span style={{ color: '#9CA3AF', fontSize: '12px' }}>{Math.round((cards.length / allCards.length) * 100)}%</span>
        </div>
        <div style={{ background: '#1E1E2E', borderRadius: '100px', height: '8px', overflow: 'hidden' }}>
          <div style={{ background: '#F59E0B', height: '100%', width: `${(cards.length / allCards.length) * 100}%`, transition: 'width 0.3s' }} />
        </div>
      </div>

      {/* Cards grid */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
        {allCards.map((card, i) => {
          const owned = user.collectedCardIds.includes(card.id);
          const color = rarityColors[card.rarity];
          return (
            <motion.div
              key={card.id}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: i * 0.06 }}
            >
              <div style={{
                background: '#14141F',
                border: `2px solid ${owned ? color : '#2D2D3D'}`,
                borderRadius: '16px',
                padding: '20px 16px',
                textAlign: 'center',
                opacity: owned ? 1 : 0.4,
                position: 'relative',
                overflow: 'hidden',
              }}>
                {owned && (
                  <div style={{
                    position: 'absolute',
                    top: 0, left: 0, right: 0,
                    height: '3px',
                    background: `linear-gradient(90deg, ${color}, transparent)`,
                  }} />
                )}
                <div style={{ fontSize: '40px', marginBottom: '8px' }}>
                  {owned ? '🎤' : '❓'}
                </div>
                <div style={{ color: owned ? '#F9FAFB' : '#6B7280', fontWeight: 700, fontSize: '14px', marginBottom: '4px' }}>
                  {owned ? card.artistName : '???'}
                </div>
                <div style={{
                  display: 'inline-block',
                  background: owned ? color + '20' : '#2D2D3D',
                  color: owned ? color : '#6B7280',
                  borderRadius: '100px',
                  padding: '2px 8px',
                  fontSize: '10px',
                  fontWeight: 600,
                }}>
                  {rarityLabels[card.rarity]}
                </div>
                {owned && (
                  <div style={{ marginTop: '12px', display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '4px' }}>
                    {Object.entries(card.stats).map(([stat, val]) => (
                      <div key={stat} style={{ textAlign: 'center' }}>
                        <div style={{ color: color, fontWeight: 700, fontSize: '14px' }}>{val}</div>
                        <div style={{ color: '#6B7280', fontSize: '9px', textTransform: 'uppercase' }}>{stat}</div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            </motion.div>
          );
        })}
      </div>
    </div>
  );
}
