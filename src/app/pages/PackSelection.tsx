import { Link } from 'react-router';
import { motion } from 'motion/react';
import { Lock, CheckCircle } from 'lucide-react';
import { useApp } from '../context/AppContext';
import type { Pack, User } from '../types';

export default function PackSelection() {
  const { packs, isPackUnlocked, user } = useApp();

  return (
    <div style={{ padding: '20px', maxWidth: '480px', margin: '0 auto' }}>
      <motion.div initial={{ opacity: 0, y: -20 }} animate={{ opacity: 1, y: 0 }}>
        <h1 style={{ fontSize: '24px', fontWeight: 800, color: '#F9FAFB', marginBottom: '8px' }}>
          Packs de Quiz
        </h1>
        <p style={{ color: '#9CA3AF', fontSize: '14px', marginBottom: '24px' }}>
          Choisis ton thème et teste tes connaissances
        </p>
      </motion.div>

      <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
        {packs.map((pack, i) => {
          const unlocked = isPackUnlocked(pack);
          return (
            <motion.div
              key={pack.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.08 }}
            >
              {unlocked ? (
                <Link to={`/solo/${pack.id}`} style={{ textDecoration: 'none' }}>
                  <PackCard pack={pack} unlocked />
                </Link>
              ) : (
                <PackCard pack={pack} unlocked={false} user={user} />
              )}
            </motion.div>
          );
        })}
      </div>
    </div>
  );
}

interface PackCardProps {
  pack: Pack;
  unlocked: boolean;
  user?: User;
}

function PackCard({ pack, unlocked, user }: PackCardProps) {
  return (
    <div style={{
      background: '#14141F',
      border: `1px solid ${unlocked ? pack.color + '40' : '#2D2D3D'}`,
      borderRadius: '16px',
      padding: '20px',
      opacity: unlocked ? 1 : 0.7,
      cursor: unlocked ? 'pointer' : 'default',
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
        <div style={{
          background: pack.color + '20',
          borderRadius: '14px',
          width: '56px',
          height: '56px',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontSize: '28px',
          flexShrink: 0,
        }}>
          {pack.emoji}
        </div>
        <div style={{ flex: 1 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '4px' }}>
            <h3 style={{ color: '#F9FAFB', fontWeight: 700, fontSize: '16px' }}>{pack.name}</h3>
            {unlocked
              ? <CheckCircle size={16} color="#10B981" />
              : <Lock size={16} color="#6B7280" />
            }
          </div>
          <p style={{ color: '#9CA3AF', fontSize: '13px', marginBottom: '8px' }}>{pack.description}</p>
          <div style={{ display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
            <span style={{
              background: pack.color + '20',
              color: pack.color,
              borderRadius: '100px',
              padding: '2px 10px',
              fontSize: '11px',
              fontWeight: 600,
            }}>
              {pack.category}
            </span>
            {pack.access === 'premium' && !unlocked && (
              <span style={{
                background: '#F59E0B20',
                color: '#F59E0B',
                borderRadius: '100px',
                padding: '2px 10px',
                fontSize: '11px',
                fontWeight: 600,
              }}>
                Premium
              </span>
            )}
            {pack.access === 'grind' && !unlocked && user && (
              <span style={{
                background: '#EF444420',
                color: '#EF4444',
                borderRadius: '100px',
                padding: '2px 10px',
                fontSize: '11px',
                fontWeight: 600,
              }}>
                {user.victories}/{pack.grindRequirements?.victories} victoires
              </span>
            )}
          </div>
        </div>
        {unlocked && (
          <div style={{ color: '#7C3AED', fontSize: '20px' }}>›</div>
        )}
      </div>
    </div>
  );
}
