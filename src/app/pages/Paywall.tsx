import { useNavigate } from 'react-router';
import { motion } from 'motion/react';
import { Check, Crown, ArrowLeft } from 'lucide-react';
import { useApp } from '../context/AppContext';

const premiumFeatures = [
  'Accès à tous les packs (5 packs)',
  'Duels illimités',
  'Boosters de cartes exclusifs',
  'Pas de pub',
  'Badges premium',
  'Statistiques avancées',
];

export default function Paywall() {
  const navigate = useNavigate();
  const { updateUser, user } = useApp();

  const handleSubscribe = () => {
    updateUser({ isPremium: true });
    navigate('/');
  };

  return (
    <div style={{ minHeight: '100vh', background: '#0A0A0F', padding: '20px', maxWidth: '480px', margin: '0 auto' }}>
      <button onClick={() => navigate(-1)} style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#9CA3AF', marginBottom: '20px', display: 'flex', alignItems: 'center', gap: '8px' }}>
        <ArrowLeft size={20} /> Retour
      </button>

      <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
        <div style={{ textAlign: 'center', marginBottom: '32px' }}>
          <div style={{ fontSize: '64px', marginBottom: '16px' }}>👑</div>
          <h1 style={{ color: '#F9FAFB', fontSize: '28px', fontWeight: 800, marginBottom: '8px' }}>
            App Rap Premium
          </h1>
          <p style={{ color: '#9CA3AF', fontSize: '15px' }}>
            Débloques tout le potentiel de l'app
          </p>
        </div>

        {/* Features */}
        <div style={{ background: '#14141F', borderRadius: '16px', padding: '24px', border: '1px solid #2D2D3D', marginBottom: '24px' }}>
          <h3 style={{ color: '#F9FAFB', fontWeight: 700, fontSize: '17px', marginBottom: '16px' }}>
            Ce qui est inclus
          </h3>
          {premiumFeatures.map(feature => (
            <div key={feature} style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '12px' }}>
              <div style={{ background: '#10B98120', borderRadius: '50%', width: '24px', height: '24px', display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0 }}>
                <Check size={14} color="#10B981" />
              </div>
              <span style={{ color: '#F9FAFB', fontSize: '15px' }}>{feature}</span>
            </div>
          ))}
        </div>

        {/* Pricing */}
        <div style={{ display: 'flex', gap: '12px', marginBottom: '24px' }}>
          <div style={{
            flex: 1,
            background: '#14141F',
            border: '2px solid #7C3AED',
            borderRadius: '16px',
            padding: '20px',
            textAlign: 'center',
          }}>
            <div style={{ color: '#9CA3AF', fontSize: '12px', marginBottom: '4px' }}>MENSUEL</div>
            <div style={{ color: '#F9FAFB', fontSize: '28px', fontWeight: 800 }}>4,99€</div>
            <div style={{ color: '#9CA3AF', fontSize: '12px' }}>/ mois</div>
          </div>
          <div style={{
            flex: 1,
            background: 'linear-gradient(135deg, #7C3AED20, #6366F120)',
            border: '2px solid #7C3AED',
            borderRadius: '16px',
            padding: '20px',
            textAlign: 'center',
            position: 'relative',
          }}>
            <div style={{ position: 'absolute', top: '-12px', left: '50%', transform: 'translateX(-50%)', background: '#7C3AED', color: 'white', borderRadius: '100px', padding: '2px 10px', fontSize: '11px', fontWeight: 700 }}>
              MEILLEUR PLAN
            </div>
            <div style={{ color: '#9CA3AF', fontSize: '12px', marginBottom: '4px' }}>ANNUEL</div>
            <div style={{ color: '#F9FAFB', fontSize: '28px', fontWeight: 800 }}>39,99€</div>
            <div style={{ color: '#9CA3AF', fontSize: '12px' }}>/ an (~3,33€/mois)</div>
          </div>
        </div>

        {user.isPremium ? (
          <div style={{ background: '#10B98120', borderRadius: '12px', padding: '16px', textAlign: 'center', color: '#10B981', fontWeight: 700 }}>
            ✅ Tu es déjà Premium!
          </div>
        ) : (
          <button
            onClick={handleSubscribe}
            style={{
              background: 'linear-gradient(135deg, #7C3AED, #6366F1)',
              color: 'white',
              border: 'none',
              borderRadius: '14px',
              padding: '18px',
              width: '100%',
              fontSize: '17px',
              fontWeight: 700,
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '10px',
            }}
          >
            <Crown size={20} />
            Devenir Premium (démo)
          </button>
        )}

        <p style={{ color: '#6B7280', fontSize: '12px', textAlign: 'center', marginTop: '16px' }}>
          Annulable à tout moment • Pas de frais cachés
        </p>
      </motion.div>
    </div>
  );
}
