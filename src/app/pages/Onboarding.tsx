import { useState } from 'react';
import { useNavigate } from 'react-router';
import { motion, AnimatePresence } from 'motion/react';

const steps = [
  {
    emoji: '🎤',
    title: 'Bienvenue sur App Rap',
    description: 'Teste tes connaissances sur la culture rap française avec des punchlines légendaires.',
  },
  {
    emoji: '🃏',
    title: 'Collecte des Cartes',
    description: "Gagne des cartes d'artistes en jouant. 4 niveaux de rareté: Commune, Rare, Épique, Légendaire.",
  },
  {
    emoji: '⚔️',
    title: 'Défie tes Amis',
    description: 'Lance des duels 1v1 à tes amis et prouve que tu es le meilleur connaisseur du rap.',
  },
  {
    emoji: '🔥',
    title: 'Défi du Jour',
    description: "Un nouveau défi chaque jour pour gagner des coins et de l'XP bonus.",
  },
];

export default function Onboarding() {
  const [step, setStep] = useState(0);
  const navigate = useNavigate();

  const next = () => {
    if (step < steps.length - 1) setStep(step + 1);
    else navigate('/');
  };

  const current = steps[step];

  return (
    <div style={{
      minHeight: '100vh',
      background: '#0A0A0F',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '32px 20px',
    }}>
      <AnimatePresence mode="wait">
        <motion.div
          key={step}
          initial={{ opacity: 0, x: 50 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: -50 }}
          style={{ textAlign: 'center', maxWidth: '380px', width: '100%' }}
        >
          <div style={{ fontSize: '80px', marginBottom: '32px' }}>{current.emoji}</div>
          <h1 style={{ fontSize: '28px', fontWeight: 800, color: '#F9FAFB', marginBottom: '16px' }}>
            {current.title}
          </h1>
          <p style={{ fontSize: '16px', color: '#9CA3AF', lineHeight: 1.6, marginBottom: '40px' }}>
            {current.description}
          </p>
        </motion.div>
      </AnimatePresence>

      {/* Dots */}
      <div style={{ display: 'flex', gap: '8px', marginBottom: '32px' }}>
        {steps.map((_, i) => (
          <div
            key={i}
            style={{
              width: i === step ? '24px' : '8px',
              height: '8px',
              borderRadius: '100px',
              background: i === step ? '#7C3AED' : '#2D2D3D',
              transition: 'all 0.3s',
            }}
          />
        ))}
      </div>

      <button
        onClick={next}
        style={{
          background: '#7C3AED',
          color: 'white',
          border: 'none',
          borderRadius: '12px',
          padding: '16px 40px',
          fontSize: '16px',
          fontWeight: 700,
          cursor: 'pointer',
          width: '100%',
          maxWidth: '320px',
        }}
      >
        {step < steps.length - 1 ? 'Suivant →' : 'Commencer 🎤'}
      </button>
    </div>
  );
}
