import { useState, useEffect } from 'react';
import { focusSessionsAPI } from '../services/api';
import DataTable from '../components/DataTable';
import Modal from '../components/Modal';
import ConfirmModal from '../components/ConfirmModal';
import './FocusSessions.css';

const FocusSessions = () => {
  const [sessions, setSessions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [viewModalOpen, setViewModalOpen] = useState(false);
  const [deleteModalOpen, setDeleteModalOpen] = useState(false);
  const [selectedSession, setSelectedSession] = useState(null);

  useEffect(() => {
    loadSessions();
  }, [page]);

  const loadSessions = async () => {
    try {
      setLoading(true);
      const response = await focusSessionsAPI.getAll(page, 20);
      // Mock data for development
      const mockSessions = Array.from({ length: 20 }, (_, i) => ({
        id: `session-${i + 1}`,
        userId: `user-${Math.floor(Math.random() * 50) + 1}`,
        durationMinutes: Math.floor(Math.random() * 120) + 15,
        totalSeconds: Math.floor(Math.random() * 7200) + 900,
        isCompleted: Math.random() > 0.3,
        earnedCoins: Math.floor(Math.random() * 100),
        earnedStones: Math.floor(Math.random() * 50),
        earnedWood: Math.floor(Math.random() * 30),
        startTime: new Date(Date.now() - Math.random() * 86400000).toISOString(),
        endTime: new Date(Date.now() - Math.random() * 86400000).toISOString(),
        createdAt: new Date(Date.now() - Math.random() * 10000000000).toISOString(),
      }));
      setSessions(mockSessions);
      setTotalPages(5);
    } catch (error) {
      console.error('Error loading sessions:', error);
      const mockSessions = Array.from({ length: 20 }, (_, i) => ({
        id: `session-${i + 1}`,
        userId: `user-${Math.floor(Math.random() * 50) + 1}`,
        durationMinutes: Math.floor(Math.random() * 120) + 15,
        totalSeconds: Math.floor(Math.random() * 7200) + 900,
        isCompleted: Math.random() > 0.3,
        earnedCoins: Math.floor(Math.random() * 100),
        earnedStones: Math.floor(Math.random() * 50),
        earnedWood: Math.floor(Math.random() * 30),
        startTime: new Date(Date.now() - Math.random() * 86400000).toISOString(),
        endTime: new Date(Date.now() - Math.random() * 86400000).toISOString(),
        createdAt: new Date(Date.now() - Math.random() * 10000000000).toISOString(),
      }));
      setSessions(mockSessions);
      setTotalPages(5);
    } finally {
      setLoading(false);
    }
  };

  const formatDuration = (seconds) => {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    return `${hours}h ${minutes}m`;
  };

  const columns = [
    { key: 'id', label: 'Session ID' },
    { key: 'userId', label: 'User ID' },
    {
      key: 'durationMinutes',
      label: 'Duration',
      render: (value, row) => formatDuration(row.totalSeconds),
    },
    {
      key: 'isCompleted',
      label: 'Status',
      render: (value) => (
        <span className={`status-badge ${value ? 'completed' : 'incomplete'}`}>
          {value ? 'Completed' : 'Incomplete'}
        </span>
      ),
    },
    {
      key: 'earnedCoins',
      label: 'Rewards',
      render: (value, row) => (
        <div className="rewards-cell">
          <span>💰 {value || 0}</span>
          <span>🪨 {row.earnedStones || 0}</span>
          <span>🪵 {row.earnedWood || 0}</span>
        </div>
      ),
    },
    {
      key: 'startTime',
      label: 'Start Time',
      render: (value) => (value ? new Date(value).toLocaleString() : '-'),
    },
  ];

  return (
    <div className="focus-sessions-page">
      <div className="page-header">
        <h2>Focus Sessions</h2>
      </div>

      <DataTable
        columns={columns}
        data={sessions}
        loading={loading}
        actions={(row) => (
          <>
            <button className="btn-view" onClick={() => {
              setSelectedSession(row);
              setViewModalOpen(true);
            }}>
              View
            </button>
            <button className="btn-delete" onClick={() => {
              setSelectedSession(row);
              setDeleteModalOpen(true);
            }}>
              Delete
            </button>
          </>
        )}
      />

      {/* View Modal */}
      <Modal
        isOpen={viewModalOpen}
        onClose={() => {
          setViewModalOpen(false);
          setSelectedSession(null);
        }}
        title="Session Details"
        size="medium"
      >
        {selectedSession && (
          <div className="user-details">
            <div className="detail-row">
              <span className="detail-label">Session ID:</span>
              <span className="detail-value">{selectedSession.id}</span>
            </div>
            <div className="detail-row">
              <span className="detail-label">User ID:</span>
              <span className="detail-value">{selectedSession.userId}</span>
            </div>
            <div className="detail-row">
              <span className="detail-label">Duration:</span>
              <span className="detail-value">{formatDuration(selectedSession.totalSeconds)}</span>
            </div>
            <div className="detail-row">
              <span className="detail-label">Status:</span>
              <span className="detail-value">
                <span className={`status-badge ${selectedSession.isCompleted ? 'completed' : 'incomplete'}`}>
                  {selectedSession.isCompleted ? 'Completed' : 'Incomplete'}
                </span>
              </span>
            </div>
            <div className="detail-row">
              <span className="detail-label">Rewards:</span>
              <span className="detail-value">
                💰 {selectedSession.earnedCoins || 0} | 
                🪨 {selectedSession.earnedStones || 0} | 
                🪵 {selectedSession.earnedWood || 0}
              </span>
            </div>
            <div className="detail-row">
              <span className="detail-label">Start Time:</span>
              <span className="detail-value">
                {selectedSession.startTime ? new Date(selectedSession.startTime).toLocaleString() : 'N/A'}
              </span>
            </div>
            <div className="detail-row">
              <span className="detail-label">End Time:</span>
              <span className="detail-value">
                {selectedSession.endTime ? new Date(selectedSession.endTime).toLocaleString() : 'N/A'}
              </span>
            </div>
          </div>
        )}
      </Modal>

      {/* Delete Confirmation Modal */}
      <ConfirmModal
        isOpen={deleteModalOpen}
        onClose={() => {
          setDeleteModalOpen(false);
          setSelectedSession(null);
        }}
        onConfirm={async () => {
          if (selectedSession) {
            try {
              await focusSessionsAPI.delete(selectedSession.id);
              loadSessions();
            } catch (error) {
              console.error('Error deleting session:', error);
              alert('Failed to delete session');
            }
          }
        }}
        title="Delete Session"
        message={`Are you sure you want to delete session ${selectedSession?.id || ''}? This action cannot be undone.`}
        confirmText="Delete"
        cancelText="Cancel"
        type="danger"
      />

      <div className="pagination">
        <button
          onClick={() => setPage((p) => Math.max(1, p - 1))}
          disabled={page === 1}
        >
          Previous
        </button>
        <span>
          Page {page} of {totalPages}
        </span>
        <button
          onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
          disabled={page === totalPages}
        >
          Next
        </button>
      </div>
    </div>
  );
};

export default FocusSessions;

