import { useState, useEffect, useRef } from 'react';
import { useParams, useNavigate } from 'react-router';
import { motion, AnimatePresence } from 'motion/react';
import { X, CheckCircle, XCircle, Clock } from 'lucide-react';
import { useApp } from '../context/AppContext';
import { QUESTIONS, PACKS } from '../data';

export default function SoloQuiz() {
  const { packId } = useParams();
  const navigate = useNavigate();
  const { addXP, addCoins } = useApp();

  const pack = PACKS.find(p => p.id === packId);
  const questions = QUESTIONS.filter(q => q.packId === packId);
  const quizQuestions = questions.slice(0, 5);

  const [currentIndex, setCurrentIndex] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<string | null>(null);
  const [score, setScore] = useState(0);
  const [timeLeft, setTimeLeft] = useState(15);
  const [finished, setFinished] = useState(false);

  const scoreRef = useRef(score);
  scoreRef.current = score;

  const currentQuestion = quizQuestions[currentIndex];

  const handleAnswer = (answer: string) => {
    if (selectedAnswer !== null) return;
    setSelectedAnswer(answer);
    const correct = answer === currentQuestion?.correctAnswer;
    const newScore = correct ? scoreRef.current + 1 : scoreRef.current;
    if (correct) setScore(newScore);

    setTimeout(() => {
      if (currentIndex < quizQuestions.length - 1) {
        setCurrentIndex(i => i + 1);
        setSelectedAnswer(null);
        setTimeLeft(15);
      } else {
        setFinished(true);
        addXP(newScore * 50 + 100);
        addCoins(newScore * 20);
      }
    }, 1200);
  };

  useEffect(() => {
    if (selectedAnswer !== null || finished) return;
    const timer = setInterval(() => {
      setTimeLeft(t => {
        if (t <= 1) {
          clearInterval(timer);
          handleAnswer('');
          return 0;
        }
        return t - 1;
      });
    }, 1000);
    return () => clearInterval(timer);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [currentIndex, selectedAnswer, finished]);

  if (!pack || quizQuestions.length === 0) {
    return (
      <div style={{ padding: '20px', color: '#F9FAFB', textAlign: 'center' }}>
        <p>Pack non trouvé.</p>
        <button onClick={() => navigate('/packs')} style={{ marginTop: '16px', color: '#7C3AED', background: 'none', border: 'none', cursor: 'pointer', fontSize: '15px' }}>
          Retour aux packs
        </button>
      </div>
    );
  }

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
        <div style={{ fontSize: '64px', marginBottom: '24px' }}>
          {score >= 4 ? '🏆' : score >= 2 ? '👍' : '💪'}
        </div>
        <h2 style={{ fontSize: '28px', fontWeight: 800, color: '#F9FAFB', marginBottom: '8px' }}>
          Quiz Terminé!
        </h2>
        <p style={{ color: '#9CA3AF', fontSize: '16px', marginBottom: '32px' }}>
          {score} / {quizQuestions.length} bonnes réponses
        </p>
        <div style={{ display: 'flex', gap: '16px', marginBottom: '32px' }}>
          <div style={{ background: '#14141F', borderRadius: '12px', padding: '16px 24px', border: '1px solid #2D2D3D' }}>
            <div style={{ color: '#7C3AED', fontWeight: 700, fontSize: '20px' }}>+{score * 50 + 100} XP</div>
          </div>
          <div style={{ background: '#14141F', borderRadius: '12px', padding: '16px 24px', border: '1px solid #2D2D3D' }}>
            <div style={{ color: '#F59E0B', fontWeight: 700, fontSize: '20px' }}>+{score * 20} 🪙</div>
          </div>
        </div>
        <button
          onClick={() => navigate('/packs')}
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
          Retour aux Packs
        </button>
      </motion.div>
    );
  }

  return (
    <div style={{ minHeight: '100vh', background: '#0A0A0F', padding: '20px', maxWidth: '480px', margin: '0 auto' }}>
      {/* Header */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '20px' }}>
        <button
          onClick={() => navigate('/packs')}
          style={{ background: 'none', border: 'none', cursor: 'pointer', color: '#9CA3AF' }}
        >
          <X size={24} />
        </button>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', color: '#9CA3AF' }}>
          <Clock size={16} />
          <span style={{ fontWeight: 700, color: timeLeft <= 5 ? '#EF4444' : '#F9FAFB', fontSize: '18px' }}>
            {timeLeft}s
          </span>
        </div>
        <span style={{ color: '#9CA3AF', fontSize: '14px' }}>
          {currentIndex + 1}/{quizQuestions.length}
        </span>
      </div>

      {/* Progress */}
      <div style={{ background: '#1E1E2E', borderRadius: '100px', height: '6px', marginBottom: '24px', overflow: 'hidden' }}>
        <div style={{ background: '#7C3AED', height: '100%', width: `${(currentIndex / quizQuestions.length) * 100}%`, transition: 'width 0.3s' }} />
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={currentIndex}
          initial={{ opacity: 0, x: 40 }}
          animate={{ opacity: 1, x: 0 }}
          exit={{ opacity: 0, x: -40 }}
        >
          {/* Question type badge */}
          <div style={{ marginBottom: '16px' }}>
            <span style={{
              background: '#7C3AED20',
              color: '#7C3AED',
              borderRadius: '100px',
              padding: '4px 12px',
              fontSize: '12px',
              fontWeight: 600,
            }}>
              {currentQuestion.type === 'whoSaidThis' ? '🎤 Qui a dit ça ?' : '✍️ Complète la punchline'}
            </span>
          </div>

          {/* Question */}
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
            {currentQuestion.artistName && currentQuestion.type === 'completePunchline' && (
              <p style={{ color: '#9CA3AF', fontSize: '13px', marginTop: '12px' }}>
                — {currentQuestion.artistName}
              </p>
            )}
          </div>

          {/* Choices */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
            {currentQuestion.choices.map((choice) => {
              const isSelected = selectedAnswer === choice;
              const isRight = choice === currentQuestion.correctAnswer;
              let bg = '#14141F';
              let border = '#2D2D3D';
              let color = '#F9FAFB';

              if (selectedAnswer !== null) {
                if (isRight) { bg = '#10B98120'; border = '#10B981'; color = '#10B981'; }
                else if (isSelected && !isRight) { bg = '#EF444420'; border = '#EF4444'; color = '#EF4444'; }
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

