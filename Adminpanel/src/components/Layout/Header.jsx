import { useAuth } from '../../contexts/AuthContext';
import { useNavigate, useLocation } from 'react-router-dom';
import './Header.css';

const Header = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const handleLogout = async () => {
    await logout();
    navigate('/login');
  };

  const navItems = [
    { path: '/', label: 'Dashboard' },
    { path: '/users', label: 'Users' },
    { path: '/focus-sessions', label: 'Focus Sessions' },
    { path: '/castle-grounds', label: 'Castle Grounds' },
    { path: '/leaderboard', label: 'Leaderboard' },
    { path: '/treasure-chests', label: 'Treasure Chests' },
  ];

  return (
    <header className="admin-header">
      <div className="header-content">
        <nav className="header-nav">
          {navItems.map((item) => (
            <button
              key={item.path}
              className={`nav-button ${location.pathname === item.path ? 'active' : ''}`}
              onClick={() => navigate(item.path)}
            >
              {item.label}
            </button>
          ))}
        </nav>
      </div>
    </header>
  );
};

export default Header;

