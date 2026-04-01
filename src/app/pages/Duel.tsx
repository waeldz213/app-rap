import { useState } from 'react';
import { useNavigate } from 'react-router';
import { motion } from 'motion/react';
import { Swords, Copy, ArrowLeft } from 'lucide-react';

export default function Duel() {
  const navigate = useNavigate();
  const [mode, setMode] = useState<'menu' | 'create' | 'join'>('menu');
  const [inviteCode] = useState(() => Math.random().toString(36).substring(2, 8).toUpperCase());
  const [joinCode, setJoinCode] = useState('');
  const [copied, setCopied] = useState(false);

  const copyCode = () => {
    navigator.clipboard.writeText(inviteCode).catch(() => {});
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  if (mode === 'create') {
    return (
      <div style={{ padding: '20px', maxWidth: '480px', margin: '0 auto', minHeight: '100vh', background: '#0A0A0F' }}>
        <button onClick={() => setMode('menu')} style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#9CA3AF', marginBottom: '20px', display: 'flex', alignItems: 'center', gap: '8px' }}>
          <ArrowLeft size={20} /> Retour
        </button>
        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
          <h2 style={{ color: '#F9FAFB', fontSize: '22px', fontWeight: 700, marginBottom: '24px' }}>
            Créer un Duel
          </h2>
          <div style={{ background: '#14141F', borderRadius: '16px', padding: '32px', border: '1px solid #2D2D3D', textAlign: 'center' }}>
            <p style={{ color: '#9CA3AF', fontSize: '14px', marginBottom: '16px' }}>Code d'invitation</p>
            <div style={{ fontSize: '40px', fontWeight: 800, color: '#7C3AED', letterSpacing: '8px', marginBottom: '16px' }}>
              {inviteCode}
            </div>
            <button
              onClick={copyCode}
              style={{
                background: copied ? '#10B981' : '#7C3AED',
                color: 'white',
                border: 'none',
                borderRadius: '10px',
                padding: '12px 24px',
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                margin: '0 auto',
                fontWeight: 600,
              }}
            >
              <Copy size={16} /> {copied ? 'Copié!' : 'Copier le code'}
            </button>
          </div>
          <p style={{ color: '#6B7280', fontSize: '13px', textAlign: 'center', marginTop: '20px' }}>
            En attente d'un adversaire...
          </p>
        </motion.div>
      </div>
    );
  }

  if (mode === 'join') {
    return (
      <div style={{ padding: '20px', maxWidth: '480px', margin: '0 auto', minHeight: '100vh', background: '#0A0A0F' }}>
        <button onClick={() => setMode('menu')} style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#9CA3AF', marginBottom: '20px', display: 'flex', alignItems: 'center', gap: '8px' }}>
          <ArrowLeft size={20} /> Retour
        </button>
        <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}>
          <h2 style={{ color: '#F9FAFB', fontSize: '22px', fontWeight: 700, marginBottom: '24px' }}>
            Rejoindre un Duel
          </h2>
          <div style={{ background: '#14141F', borderRadius: '16px', padding: '24px', border: '1px solid #2D2D3D' }}>
            <p style={{ color: '#9CA3AF', fontSize: '14px', marginBottom: '12px' }}>Entrez le code d'invitation</p>
            <input
              type="text"
              value={joinCode}
              onChange={e => setJoinCode(e.target.value.toUpperCase())}
              placeholder="Ex: ABC123"
              maxLength={6}
              style={{
                width: '100%',
                background: '#1E1E2E',
                border: '2px solid #2D2D3D',
                borderRadius: '10px',
                padding: '16px',
                color: '#F9FAFB',
                fontSize: '24px',
                fontWeight: 700,
                letterSpacing: '6px',
                textAlign: 'center',
                outline: 'none',
                boxSizing: 'border-box',
                marginBottom: '16px',
              }}
            />
            <button
              disabled={joinCode.length !== 6}
              style={{
                background: joinCode.length === 6 ? '#7C3AED' : '#2D2D3D',
                color: 'white',
                border: 'none',
                borderRadius: '10px',
                padding: '14px',
                width: '100%',
                cursor: joinCode.length === 6 ? 'pointer' : 'default',
                fontWeight: 700,
                fontSize: '15px',
              }}
            >
              Rejoindre
            </button>
          </div>
        </motion.div>
      </div>
    );
  }

  return (
    <div style={{ padding: '20px', maxWidth: '480px', margin: '0 auto', minHeight: '100vh', background: '#0A0A0F' }}>
      <motion.div initial={{ opacity: 0, y: -20 }} animate={{ opacity: 1, y: 0 }}>
        <button onClick={() => navigate(-1)} style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#9CA3AF', marginBottom: '20px', display: 'flex', alignItems: 'center', gap: '8px' }}>
          <ArrowLeft size={20} /> Retour
        </button>
        <div style={{ textAlign: 'center', marginBottom: '40px' }}>
          <div style={{ fontSize: '64px', marginBottom: '16px' }}>⚔️</div>
          <h1 style={{ color: '#F9FAFB', fontSize: '28px', fontWeight: 800, marginBottom: '8px' }}>Duel 1v1</h1>
          <p style={{ color: '#9CA3AF', fontSize: '15px' }}>Défie un ami en temps réel</p>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
          <button
            onClick={() => setMode('create')}
            style={{
              background: 'linear-gradient(135deg, #7C3AED, #6366F1)',
              color: 'white',
              border: 'none',
              borderRadius: '16px',
              padding: '24px',
              cursor: 'pointer',
              textAlign: 'left',
              display: 'flex',
              alignItems: 'center',
              gap: '16px',
            }}
          >
            <Swords size={32} />
            <div>
              <div style={{ fontWeight: 700, fontSize: '17px', marginBottom: '4px' }}>Créer un duel</div>
              <div style={{ fontSize: '13px', opacity: 0.8 }}>Génère un code et invite un ami</div>
            </div>
          </button>
          <button
            onClick={() => setMode('join')}
            style={{
              background: '#14141F',
              color: '#F9FAFB',
              border: '2px solid #7C3AED',
              borderRadius: '16px',
              padding: '24px',
              cursor: 'pointer',
              textAlign: 'left',
              display: 'flex',
              alignItems: 'center',
              gap: '16px',
            }}
          >
            <Swords size={32} color="#7C3AED" />
            <div>
              <div style={{ fontWeight: 700, fontSize: '17px', marginBottom: '4px' }}>Rejoindre un duel</div>
              <div style={{ fontSize: '13px', color: '#9CA3AF' }}>Entre le code de ton adversaire</div>
            </div>
          </button>
        </div>
      </motion.div>
    </div>
  );
}
