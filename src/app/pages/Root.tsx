import { Outlet, Link, useLocation } from 'react-router';
import { Home, BookOpen, User, Trophy } from 'lucide-react';

const navItems = [
  { path: '/', icon: Home, label: 'Accueil' },
  { path: '/packs', icon: BookOpen, label: 'Packs' },
  { path: '/collection', icon: Trophy, label: 'Collection' },
  { path: '/profile', icon: User, label: 'Profil' },
];

export default function Root() {
  const location = useLocation();

  return (
    <div style={{ minHeight: '100vh', background: '#0A0A0F', display: 'flex', flexDirection: 'column' }}>
      <main style={{ flex: 1, paddingBottom: '80px' }}>
        <Outlet />
      </main>
      <nav style={{
        position: 'fixed',
        bottom: 0,
        left: 0,
        right: 0,
        background: '#14141F',
        borderTop: '1px solid #2D2D3D',
        display: 'flex',
        justifyContent: 'space-around',
        alignItems: 'center',
        padding: '8px 0',
        zIndex: 50,
      }}>
        {navItems.map(({ path, icon: Icon, label }) => {
          const active = location.pathname === path;
          return (
            <Link
              key={path}
              to={path}
              style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                gap: '4px',
                textDecoration: 'none',
                color: active ? '#7C3AED' : '#6B7280',
                transition: 'color 0.2s',
                padding: '8px 16px',
              }}
            >
              <Icon size={22} />
              <span style={{ fontSize: '11px', fontWeight: active ? 600 : 400 }}>{label}</span>
            </Link>
          );
        })}
      </nav>
    </div>
  );
}
