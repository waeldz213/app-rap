import { useState } from 'react';

interface Props {
  src: string;
  alt: string;
  fallback?: string;
  style?: React.CSSProperties;
  className?: string;
}

export default function ImageWithFallback({ src, alt, fallback = '🎤', style, className }: Props) {
  const [error, setError] = useState(false);

  if (error) {
    return (
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          background: '#1E1E2E',
          fontSize: '32px',
          ...style,
        }}
        className={className}
      >
        {fallback}
      </div>
    );
  }

  return (
    <img
      src={src}
      alt={alt}
      onError={() => setError(true)}
      style={style}
      className={className}
    />
  );
}
