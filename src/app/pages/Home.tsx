import { Link } from 'react-router';
import { motion } from 'motion/react';
import { Flame, Coins, Star, Trophy, Calendar } from 'lucide-react';
import { useApp } from '../context/AppContext';

export default function Home() {
  const { user } = useApp();
  const xpPercent = Math.round((user.xp / user.xpToNextLevel) * 100);

  return (
    <div style={{ padding: '20px', maxWidth: '480px', margin: '0 auto' }}>
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        style={{ marginBottom: '24px' }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <h1 style={{ fontSize: '24px', fontWeight: 800, color: '#F9FAFB' }}>
              Yo, {user.username} 👋
            </h1>
            <p style={{ color: '#9CA3AF', fontSize: '14px' }}>Niveau {user.level} • {user.streak} jours de streak</p>
          </div>
          <div style={{
            background: '#1E1E2E',
            borderRadius: '50%',
            width: '48px',
            height: '48px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: '24px',
          }}>
            🎤
          </div>
        </div>
      </motion.div>

      {/* Stats Row */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
        style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '12px', marginBottom: '20px' }}
      >
        {[
          { icon: Flame, label: 'Streak', value: `${user.streak}j`, color: '#F59E0B' },
          { icon: Coins, label: 'Coins', value: user.coins, color: '#F59E0B' },
          { icon: Trophy, label: 'Victoires', value: user.victories, color: '#10B981' },
        ].map(({ icon: Icon, label, value, color }) => (
          <div key={label} style={{
            background: '#14141F',
            borderRadius: '12px',
            padding: '16px 12px',
            border: '1px solid #2D2D3D',
            textAlign: 'center',
          }}>
            <Icon size={20} color={color} style={{ margin: '0 auto 6px' }} />
            <div style={{ fontSize: '20px', fontWeight: 700, color: '#F9FAFB' }}>{value}</div>
            <div style={{ fontSize: '11px', color: '#9CA3AF' }}>{label}</div>
          </div>
        ))}
      </motion.div>

      {/* XP Bar */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.15 }}
        style={{
          background: '#14141F',
          borderRadius: '12px',
          padding: '16px',
          border: '1px solid #2D2D3D',
          marginBottom: '20px',
        }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
          <span style={{ color: '#F9FAFB', fontWeight: 600, fontSize: '14px' }}>
            <Star size={14} style={{ display: 'inline', marginRight: '4px' }} />
            Niveau {user.level}
          </span>
          <span style={{ color: '#9CA3AF', fontSize: '12px' }}>{user.xp} / {user.xpToNextLevel} XP</span>
        </div>
        <div style={{ background: '#1E1E2E', borderRadius: '100px', height: '8px', overflow: 'hidden' }}>
          <motion.div
            initial={{ width: 0 }}
            animate={{ width: `${xpPercent}%` }}
            transition={{ delay: 0.3, duration: 0.6 }}
            style={{ background: '#7C3AED', height: '100%', borderRadius: '100px' }}
          />
        </div>
      </motion.div>

      {/* Daily Challenge */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
        style={{ marginBottom: '20px' }}
      >
        <Link to="/daily-challenge" style={{ textDecoration: 'none' }}>
          <div style={{
            background: 'linear-gradient(135deg, #7C3AED, #6366F1)',
            borderRadius: '16px',
            padding: '20px',
            display: 'flex',
            alignItems: 'center',
            gap: '16px',
          }}>
            <div style={{
              background: 'rgba(255,255,255,0.15)',
              borderRadius: '12px',
              width: '52px',
              height: '52px',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
            }}>
              <Calendar size={28} color="white" />
            </div>
            <div>
              <h3 style={{ color: 'white', fontWeight: 700, fontSize: '16px', marginBottom: '4px' }}>
                Défi du Jour 🔥
              </h3>
              <p style={{ color: 'rgba(255,255,255,0.8)', fontSize: '13px' }}>
                +100 coins • +200 XP
              </p>
            </div>
            <div style={{ marginLeft: 'auto', color: 'white', fontSize: '20px' }}>›</div>
          </div>
        </Link>
      </motion.div>

      {/* Quick Actions */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.25 }}
      >
        <h2 style={{ color: '#F9FAFB', fontWeight: 700, fontSize: '18px', marginBottom: '12px' }}>
          Actions Rapides
        </h2>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
          {[
            { to: '/packs', emoji: '🎮', label: 'Quiz Solo', color: '#7C3AED' },
            { to: '/duel/pack_classiques', emoji: '⚔️', label: 'Duel', color: '#EF4444' },
            { to: '/collection', emoji: '🃏', label: 'Collection', color: '#F59E0B' },
            { to: '/paywall', emoji: '💎', label: 'Premium', color: '#3B82F6' },
          ].map(({ to, emoji, label, color }) => (
            <Link key={to} to={to} style={{ textDecoration: 'none' }}>
              <div style={{
                background: '#14141F',
                border: `1px solid ${color}40`,
                borderRadius: '12px',
                padding: '20px',
                textAlign: 'center',
                transition: 'border-color 0.2s',
              }}>
                <div style={{ fontSize: '32px', marginBottom: '8px' }}>{emoji}</div>
                <div style={{ color: '#F9FAFB', fontWeight: 600, fontSize: '14px' }}>{label}</div>
              </div>
            </Link>
          ))}
        </div>
      </motion.div>
    </div>
  );
}
