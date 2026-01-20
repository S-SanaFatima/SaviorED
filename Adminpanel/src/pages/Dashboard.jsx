import { useState, useEffect } from 'react';
import { dashboardAPI } from '../services/api';
import treasureChestImage from '../assets/Images/Gemini_Generated_Image_ozm4fgozm4fgozm4-removebg-preview.png';
import castleBackgroundImage from '../assets/Images/generate a image like a castle and green trees and bushes around it amd montai in the back and clouds over that mountail_ and makei it gaming style not too muc animated looks natural not too much cartoonish  (1).jpg';
import Modal from '../components/Modal';
import './Dashboard.css';

const Dashboard = () => {
  const [stats, setStats] = useState(null);
  const [activity, setActivity] = useState([]);
  const [loading, setLoading] = useState(true);
  const [profileModalOpen, setProfileModalOpen] = useState(false);
  const [selectedCommander, setSelectedCommander] = useState(null);

  useEffect(() => {
    loadDashboardData();
  }, []);

  const loadDashboardData = async () => {
    try {
      setLoading(true);
      const [statsRes, activityRes] = await Promise.all([
        dashboardAPI.getStats(),
        dashboardAPI.getRecentActivity(),
      ]);
      setStats(statsRes.data.stats || statsRes.data);
      setActivity(activityRes.data.activities || activityRes.data || []);
    } catch (error) {
      console.error('Error loading dashboard:', error);
      // Fallback only if absolutely necessary, but we want real data
      setStats(null);
      setActivity([]);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return <div className="dashboard-loading">Loading dashboard...</div>;
  }

  const statCards = [
    {
      title: 'Total Users',
      value: stats?.totalUsers || 1250,
      icon: 'people',
      color: '#3b82f6',
    },
    {
      title: 'Active Users',
      value: stats?.activeUsers || 342,
      icon: 'check_circle',
      color: '#10b981',
    },
    {
      title: 'Focus Sessions',
      value: stats?.totalFocusSessions || 8567,
      icon: 'timer',
      color: '#f59e0b',
    },
    {
      title: 'Total Focus Hours',
      value: stats?.totalFocusHours?.toFixed(1) || 2845.5,
      icon: 'access_time',
      color: '#8b5cf6',
    },
    {
      title: 'Castles Built',
      value: stats?.totalCastles || 890,
      icon: 'domain',
      color: '#ec4899',
    },
    {
      title: 'Treasure Chests',
      value: stats?.totalTreasureChests || 2340,
      icon: 'inventory_2',
      color: '#06b6d4',
    },
  ];

  // Mock users data for Commander Registry
  const commanderData = [
    { id: 1, username: 'SirGalahad99', rank: 1, status: 'IN FOCUS', statusColor: 'green', email: 'sirgalahad99@example.com', focusHours: 245.5, castles: 12, sessions: 156 },
    { id: 2, username: 'LadyAmatyhst', rank: 0, status: 'IDLE', statusColor: 'grey', email: 'ladyamatyhst@example.com', focusHours: 189.2, castles: 8, sessions: 124 },
    { id: 3, username: 'KnightShadow', rank: 2, status: 'IN FOCUS', statusColor: 'green', email: 'knightshadow@example.com', focusHours: 312.8, castles: 15, sessions: 201 },
    { id: 4, username: 'DragonSlayer', rank: 3, status: 'IDLE', statusColor: 'grey', email: 'dragonslayer@example.com', focusHours: 167.3, castles: 9, sessions: 98 },
  ];

  const handleViewProfile = (commander) => {
    setSelectedCommander(commander);
    setProfileModalOpen(true);
  };

  return (
    <div className="dashboard">
      {/* Main Stats Section with Castle Background */}
      <div className="castle-stats-section">
        <div className="castle-background">
          <img 
            src={castleBackgroundImage} 
            alt="Fantasy Castle" 
            className="castle-bg-image"
          />
          <div className="castle-overlay"></div>
        </div>
        
        <div className="stats-cards-container">
          <div className="frosted-stat-card featured-stat">
            <div className="stat-icon-wrapper">
              <span className="material-icons">people</span>
            </div>
            <div className="stat-number">{(stats?.activeUsers || stats?.totalUsers || 2345).toLocaleString()}</div>
            <div className="stat-label">Active Commanders</div>
            <div className="stat-title">GLOBAL KINGDOM</div>
          </div>

          <div className="frosted-stat-card featured-stat">
            <div className="stat-icon-wrapper">
              <span className="material-icons">access_time</span>
            </div>
            <div className="stat-number">{((stats?.totalFocusHours || 0) * 60).toLocaleString()}</div>
            <div className="stat-label">TOTAL STUDY MINUTES</div>
          </div>
        </div>
      </div>

      {/* Three Panel Layout */}
      <div className="dashboard-panels">
        {/* Left Sidebar Panel - Stat Cards */}
        <div className="left-sidebar-panel">
          <div className="sidebar-stats">
            {statCards.map((stat, index) => (
              <div key={index} className="sidebar-stat-item">
                <div className="sidebar-stat-icon">
                  <span className="material-icons">{stat.icon}</span>
                </div>
                <div className="sidebar-stat-content">
                  <div className="sidebar-stat-value">{stat.value.toLocaleString()}</div>
                  <div className="sidebar-stat-title">{stat.title}</div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Middle Panel - Commander Registry */}
        <div className="middle-panel">
          <h2 className="panel-title">COMMANDER REGISTRY</h2>
          <div className="registry-table">
            <table>
              <thead>
                <tr>
                  <th>Username</th>
                  <th>Rank</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {commanderData.map((user) => (
                  <tr key={user.id}>
                    <td className="username-cell">{user.username}</td>
                    <td className="rank-cell">{user.rank}</td>
                    <td className="status-cell">
                      <span className={`status-indicator ${user.statusColor}`}></span>
                      <span>{user.status}</span>
                    </td>
                    <td className="actions-cell">
                      <button 
                        className="view-profile-btn"
                        onClick={() => handleViewProfile(user)}
                      >
                        View Profile
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <div className="community-goal">
            <div className="goal-progress-bar">
              <div className="goal-progress-fill" style={{ width: '50%' }}></div>
            </div>
            <div className="goal-label">50% COMPLETE: Community Goal</div>
          </div>
        </div>

        {/* Right Panel - The Treasury */}
        <div className="right-panel">
          <h2 className="panel-title">THE TREASURY</h2>
          <div className="treasury-content">
            <div className="treasure-chest-image">
              <img 
                src={treasureChestImage} 
                alt="Treasure Chest" 
              />
            </div>
            <div className="treasury-subtitle">Virtual Rewards</div>
            <div className="reward-items">
              <div className="reward-item">
                <div className="reward-icon">🪵</div>
                <span>Wood Logs</span>
              </div>
              <div className="reward-item">
                <div className="reward-icon">🧱</div>
                <span>Store Bricks</span>
              </div>
              <div className="reward-item">
                <div className="reward-icon">📦</div>
                <span>Mystery Chest</span>
              </div>
            </div>
            <div className="treasury-buttons">
              <button className="add-reward-btn">ADD NEW REWARD</button>
              <button className="reroll-prizes-btn">RE-ROLL PRIZES</button>
            </div>
          </div>
        </div>
      </div>

      {/* Commander Profile Modal */}
      <Modal
        isOpen={profileModalOpen}
        onClose={() => {
          setProfileModalOpen(false);
          setSelectedCommander(null);
        }}
        title="Commander Profile"
        size="medium"
      >
        {selectedCommander && (
          <div className="user-details">
            <div className="detail-row">
              <span className="detail-label">Username:</span>
              <span className="detail-value">{selectedCommander.username}</span>
            </div>
            <div className="detail-row">
              <span className="detail-label">Rank:</span>
              <span className="detail-value">#{selectedCommander.rank}</span>
            </div>
            <div className="detail-row">
              <span className="detail-label">Status:</span>
              <span className="detail-value">
                <span className={`status-indicator ${selectedCommander.statusColor}`}></span>
                {selectedCommander.status}
              </span>
            </div>
            <div className="detail-row">
              <span className="detail-label">Email:</span>
              <span className="detail-value">{selectedCommander.email || 'N/A'}</span>
            </div>
            <div className="detail-row">
              <span className="detail-label">Focus Hours:</span>
              <span className="detail-value">{selectedCommander.focusHours || 0} hours</span>
            </div>
            <div className="detail-row">
              <span className="detail-label">Castles Built:</span>
              <span className="detail-value">{selectedCommander.castles || 0}</span>
            </div>
            <div className="detail-row">
              <span className="detail-label">Total Sessions:</span>
              <span className="detail-value">{selectedCommander.sessions || 0}</span>
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
};

export default Dashboard;

