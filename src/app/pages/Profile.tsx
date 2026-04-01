import { motion } from 'motion/react';
import { Link } from 'react-router';
import { Trophy, Star, Zap, Target, Crown } from 'lucide-react';
import { useApp } from '../context/AppContext';

export default function Profile() {
  const { user, cards } = useApp();
  const accuracy = user.totalAnswers > 0 ? Math.round((user.correctAnswers / user.totalAnswers) * 100) : 0;
  const xpPercent = Math.round((user.xp / user.xpToNextLevel) * 100);

  return (
    <div style={{ padding: '20px', maxWidth: '480px', margin: '0 auto' }}>
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        style={{ textAlign: 'center', marginBottom: '28px' }}
      >
        <div style={{
          width: '80px',
          height: '80px',
          borderRadius: '50%',
          background: 'linear-gradient(135deg, #7C3AED, #6366F1)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontSize: '36px',
          margin: '0 auto 16px',
        }}>
          🎤
        </div>
        <h1 style={{ color: '#F9FAFB', fontSize: '22px', fontWeight: 800 }}>{user.username}</h1>
        <p style={{ color: '#9CA3AF', fontSize: '14px' }}>Niveau {user.level} • {user.streak} jours de streak 🔥</p>
        {user.isPremium && (
          <span style={{ background: '#F59E0B20', color: '#F59E0B', borderRadius: '100px', padding: '4px 12px', fontSize: '12px', fontWeight: 700, display: 'inline-block', marginTop: '8px' }}>
            👑 Premium
          </span>
        )}
      </motion.div>

      {/* XP */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
        style={{ background: '#14141F', borderRadius: '16px', padding: '20px', border: '1px solid #2D2D3D', marginBottom: '16px' }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '10px' }}>
          <span style={{ color: '#F9FAFB', fontWeight: 600 }}>
            <Star size={14} style={{ display: 'inline', marginRight: '6px', verticalAlign: 'middle' }} />
            Expérience
          </span>
          <span style={{ color: '#9CA3AF', fontSize: '13px' }}>{user.xp} / {user.xpToNextLevel} XP</span>
        </div>
        <div style={{ background: '#1E1E2E', borderRadius: '100px', height: '10px', overflow: 'hidden' }}>
          <motion.div
            initial={{ width: 0 }}
            animate={{ width: `${xpPercent}%` }}
            transition={{ delay: 0.4, duration: 0.8 }}
            style={{ background: 'linear-gradient(90deg, #7C3AED, #6366F1)', height: '100%', borderRadius: '100px' }}
          />
        </div>
      </motion.div>

      {/* Stats grid */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.15 }}
        style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '16px' }}
      >
        {[
          { icon: Trophy, label: 'Victoires', value: user.victories, color: '#10B981' },
          { icon: Target, label: 'Précision', value: `${accuracy}%`, color: '#3B82F6' },
          { icon: Zap, label: 'Coins', value: user.coins, color: '#F59E0B' },
          { icon: Star, label: 'Cartes', value: `${cards.length}`, color: '#7C3AED' },
        ].map(({ icon: Icon, label, value, color }) => (
          <div key={label} style={{
            background: '#14141F',
            borderRadius: '12px',
            padding: '18px',
            border: '1px solid #2D2D3D',
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
          }}>
            <Icon size={22} color={color} />
            <div>
              <div style={{ color: '#F9FAFB', fontWeight: 700, fontSize: '18px' }}>{value}</div>
              <div style={{ color: '#9CA3AF', fontSize: '12px' }}>{label}</div>
            </div>
          </div>
        ))}
      </motion.div>

      {/* Premium CTA */}
      {!user.isPremium && (
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.25 }}
        >
          <Link to="/paywall" style={{ textDecoration: 'none' }}>
            <div style={{
              background: 'linear-gradient(135deg, #F59E0B, #D97706)',
              borderRadius: '16px',
              padding: '20px',
              display: 'flex',
              alignItems: 'center',
              gap: '16px',
            }}>
              <Crown size={28} color="white" />
              <div>
                <div style={{ color: 'white', fontWeight: 700, fontSize: '16px' }}>Passer Premium</div>
                <div style={{ color: 'rgba(255,255,255,0.8)', fontSize: '13px' }}>Débloque tous les packs</div>
              </div>
              <div style={{ marginLeft: 'auto', color: 'white', fontSize: '20px' }}>›</div>
            </div>
          </Link>
        </motion.div>
      )}
    </div>
  );
}
