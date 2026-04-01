import { useState } from 'react';
import { useNavigate } from 'react-router';
import { motion, AnimatePresence } from 'motion/react';
import { CheckCircle, XCircle, ArrowLeft, Flame } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { DAILY_CHALLENGE, QUESTIONS } from '../data';
import type { Question } from '../types';

export default function DailyChallenge() {
  const navigate = useNavigate();
  const { addXP, addCoins, updateUser, user } = useApp();

  const questions = DAILY_CHALLENGE.questionIds
    .map(id => QUESTIONS.find(q => q.id === id))
    .filter((q): q is Question => q !== undefined);

  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<string | null>(null);
  const [score, setScore] = useState(0);
  const [finished, setFinished] = useState(false);

  const currentQuestion = questions[currentIndex];

  const handleAnswer = (answer: string) => {
    if (selectedAnswer !== null) return;
    setSelectedAnswer(answer);
    const correct = answer === currentQuestion?.correctAnswer;
    const newScore = correct ? score + 1 : score;
    if (correct) setScore(newScore);

    setTimeout(() => {
      if (currentIndex < questions.length - 1) {
        setCurrentIndex(i => i + 1);
        setSelectedAnswer(null);
      } else {
        setFinished(true);
        addXP(DAILY_CHALLENGE.reward.xp);
        addCoins(DAILY_CHALLENGE.reward.coins);
        updateUser({ streak: user.streak + 1 });
      }
    }, 1200);
  };

  if (finished) {
    return (
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        style={{
          minHeight: '100vh',
          background: '#0A0A0F',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          justifyContent: 'center',
          padding: '32px 20px',
          textAlign: 'center',
        }}
      >
        <div style={{ fontSize: '64px', marginBottom: '16px' }}>🏆</div>
        <h2 style={{ fontSize: '26px', fontWeight: 800, color: '#F9FAFB', marginBottom: '8px' }}>
          Défi Complété!
        </h2>
        <p style={{ color: '#9CA3AF', marginBottom: '8px' }}>{score}/{questions.length} bonnes réponses</p>
        <p style={{ color: '#F59E0B', fontWeight: 600, marginBottom: '32px' }}>
          Streak: {user.streak + 1} jours 🔥
        </p>
        <div style={{ display: 'flex', gap: '16px', marginBottom: '32px' }}>
          <div style={{ background: '#14141F', borderRadius: '12px', padding: '16px 24px', border: '1px solid #2D2D3D' }}>
            <div style={{ color: '#7C3AED', fontWeight: 700, fontSize: '20px' }}>+{DAILY_CHALLENGE.reward.xp} XP</div>
          </div>
          <div style={{ background: '#14141F', borderRadius: '12px', padding: '16px 24px', border: '1px solid #2D2D3D' }}>
            <div style={{ color: '#F59E0B', fontWeight: 700, fontSize: '20px' }}>+{DAILY_CHALLENGE.reward.coins} 🪙</div>
          </div>
        </div>
        <button
          onClick={() => navigate('/')}
          style={{
            background: '#7C3AED',
            color: 'white',
            border: 'none',
            borderRadius: '12px',
            padding: '16px 32px',
            fontSize: '16px',
            fontWeight: 700,
            cursor: 'pointer',
            width: '100%',
            maxWidth: '320px',
          }}
        >
          Retour à l'accueil
        </button>
      </motion.div>
    );
  }

  if (!currentQuestion) {
    return <div style={{ padding: '20px', color: '#F9FAFB' }}>Chargement...</div>;
  }

  return (
    <div style={{ minHeight: '100vh', background: '#0A0A0F', padding: '20px', maxWidth: '480px', margin: '0 auto' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '20px' }}>
        <button onClick={() => navigate('/')} style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#9CA3AF' }}>
          <ArrowLeft size={24} />
        </button>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <Flame size={18} color="#F59E0B" />
          <span style={{ color: '#F9FAFB', fontWeight: 700 }}>Défi du Jour</span>
        </div>
        <span style={{ color: '#9CA3AF', fontSize: '14px' }}>{currentIndex + 1}/{questions.length}</span>
      </div>

      <div style={{ background: '#1E1E2E', borderRadius: '100px', height: '6px', marginBottom: '24px', overflow: 'hidden' }}>
        <div style={{ background: '#F59E0B', height: '100%', width: `${(currentIndex / questions.length) * 100}%`, transition: 'width 0.3s' }} />
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={currentIndex}
          initial={{ opacity: 0, x: 40 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: -40 }}
        >
          <div style={{
            background: '#14141F',
            borderRadius: '16px',
            padding: '24px',
            marginBottom: '24px',
            border: '1px solid #2D2D3D',
          }}>
            <p style={{ color: '#F9FAFB', fontSize: '20px', fontWeight: 600, lineHeight: 1.5, fontStyle: 'italic' }}>
              {currentQuestion.questionText}
            </p>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
            {currentQuestion.choices.map((choice) => {
              const isSelected = selectedAnswer === choice;
              const isRight = choice === currentQuestion.correctAnswer;
              let bg = '#14141F';
              let border = '#2D2D3D';
              let color = '#F9FAFB';

              if (selectedAnswer !== null) {
                if (isRight) { bg = '#10B98120'; border = '#10B981'; color = '#10B981'; }
                else if (isSelected) { bg = '#EF444420'; border = '#EF4444'; color = '#EF4444'; }
              }

              return (
                <button
                  key={choice}
                  onClick={() => handleAnswer(choice)}
                  disabled={selectedAnswer !== null}
                  style={{
                    background: bg,
                    border: `2px solid ${border}`,
                    borderRadius: '12px',
                    padding: '16px',
                    color,
                    fontSize: '15px',
                    fontWeight: 600,
                    cursor: selectedAnswer !== null ? 'default' : 'pointer',
                    textAlign: 'left',
                    transition: 'all 0.2s',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                  }}
                >
                  {choice}
                  {selectedAnswer !== null && isRight && <CheckCircle size={18} />}
                  {selectedAnswer !== null && isSelected && !isRight && <XCircle size={18} />}
                </button>
              );
            })}
          </div>
        </motion.div>
      </AnimatePresence>
    </div>
  );
}
