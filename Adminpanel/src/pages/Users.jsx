import { useState, useEffect } from 'react';
import { usersAPI } from '../services/api';
import DataTable from '../components/DataTable';
import Modal from '../components/Modal';
import ConfirmModal from '../components/ConfirmModal';
import './Users.css';

const Users = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [searchQuery, setSearchQuery] = useState('');
  const [viewModalOpen, setViewModalOpen] = useState(false);
  const [editModalOpen, setEditModalOpen] = useState(false);
  const [deleteModalOpen, setDeleteModalOpen] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);
  const [editFormData, setEditFormData] = useState({ name: '', email: '' });

  useEffect(() => {
    loadUsers();
  }, [page, searchQuery]);

  const loadUsers = async () => {
    try {
      setLoading(true);
      const response = await usersAPI.getAll(page, 20);
      // Mock data for development
      const mockUsers = Array.from({ length: 20 }, (_, i) => ({
        id: `user-${i + 1}`,
        email: `user${i + 1}@example.com`,
        name: `User ${i + 1}`,
        avatar: null,
        createdAt: new Date(Date.now() - Math.random() * 10000000000).toISOString(),
      }));
      setUsers(mockUsers);
      setTotalPages(5);
    } catch (error) {
      console.error('Error loading users:', error);
      // Set mock data on error
      const mockUsers = Array.from({ length: 20 }, (_, i) => ({
        id: `user-${i + 1}`,
        email: `user${i + 1}@example.com`,
        name: `User ${i + 1}`,
        avatar: null,
        createdAt: new Date(Date.now() - Math.random() * 10000000000).toISOString(),
      }));
      setUsers(mockUsers);
      setTotalPages(5);
    } finally {
      setLoading(false);
    }
  };

  const handleView = (user) => {
    setSelectedUser(user);
    setViewModalOpen(true);
  };

  const handleEdit = (user) => {
    setSelectedUser(user);
    setEditFormData({
      name: user.name || '',
      email: user.email || '',
    });
    setEditModalOpen(true);
  };

  const handleSaveEdit = async () => {
    if (!selectedUser) return;
    try {
      await usersAPI.update(selectedUser.id, editFormData);
      loadUsers();
      setEditModalOpen(false);
      setSelectedUser(null);
    } catch (error) {
      console.error('Error updating user:', error);
      alert('Failed to update user');
    }
  };

  const handleDelete = (user) => {
    setSelectedUser(user);
    setDeleteModalOpen(true);
  };

  const confirmDelete = async () => {
    if (!selectedUser) return;
    try {
      await usersAPI.delete(selectedUser.id);
      loadUsers();
      setSelectedUser(null);
    } catch (error) {
      console.error('Error deleting user:', error);
      alert('Failed to delete user');
    }
  };

  const columns = [
    { key: 'id', label: 'ID' },
    {
      key: 'name',
      label: 'Name',
      render: (value, row) => (
        <div className="user-cell">
          {row.avatar && (
            <img src={row.avatar} alt={value} className="user-avatar" />
          )}
          <span>{value || 'N/A'}</span>
        </div>
      ),
    },
    { key: 'email', label: 'Email' },
    {
      key: 'createdAt',
      label: 'Created At',
      render: (value) => (value ? new Date(value).toLocaleDateString() : '-'),
    },
  ];

  return (
    <div className="users-page">
      <div className="page-header">
        <h2>Users Management</h2>
        <div className="page-actions">
          <input
            type="text"
            placeholder="Search users..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="search-input"
          />
        </div>
      </div>

      <DataTable
        columns={columns}
        data={users}
        loading={loading}
        actions={(row) => (
          <>
            <button className="btn-view" onClick={() => handleView(row)}>
              View
            </button>
            <button className="btn-edit" onClick={() => handleEdit(row)}>
              Edit
            </button>
            <button className="btn-delete" onClick={() => handleDelete(row)}>
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
          setSelectedUser(null);
        }}
        title="User Details"
        size="medium"
      >
        {selectedUser && (
          <div className="user-details">
            <div className="detail-row">
              <span className="detail-label">ID:</span>
              <span className="detail-value">{selectedUser.id}</span>
            </div>
            <div className="detail-row">
              <span className="detail-label">Name:</span>
              <span className="detail-value">{selectedUser.name || 'N/A'}</span>
            </div>
            <div className="detail-row">
              <span className="detail-label">Email:</span>
              <span className="detail-value">{selectedUser.email || 'N/A'}</span>
            </div>
            <div className="detail-row">
              <span className="detail-label">Created At:</span>
              <span className="detail-value">
                {selectedUser.createdAt ? new Date(selectedUser.createdAt).toLocaleString() : 'N/A'}
              </span>
            </div>
          </div>
        )}
      </Modal>

      {/* Edit Modal */}
      <Modal
        isOpen={editModalOpen}
        onClose={() => {
          setEditModalOpen(false);
          setSelectedUser(null);
        }}
        title="Edit User"
        size="medium"
      >
        <div className="edit-form">
          <div className="form-group">
            <label htmlFor="edit-name">Name</label>
            <input
              type="text"
              id="edit-name"
              value={editFormData.name}
              onChange={(e) => setEditFormData({ ...editFormData, name: e.target.value })}
              className="form-input"
            />
          </div>
          <div className="form-group">
            <label htmlFor="edit-email">Email</label>
            <input
              type="email"
              id="edit-email"
              value={editFormData.email}
              onChange={(e) => setEditFormData({ ...editFormData, email: e.target.value })}
              className="form-input"
            />
          </div>
          <div className="modal-footer">
            <button
              className="modal-button modal-button-secondary"
              onClick={() => {
                setEditModalOpen(false);
                setSelectedUser(null);
              }}
            >
              Cancel
            </button>
            <button
              className="modal-button modal-button-primary"
              onClick={handleSaveEdit}
            >
              Save Changes
            </button>
          </div>
        </div>
      </Modal>

      {/* Delete Confirmation Modal */}
      <ConfirmModal
        isOpen={deleteModalOpen}
        onClose={() => {
          setDeleteModalOpen(false);
          setSelectedUser(null);
        }}
        onConfirm={confirmDelete}
        title="Delete User"
        message={`Are you sure you want to delete ${selectedUser?.name || selectedUser?.email || 'this user'}? This action cannot be undone.`}
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

export default Users;

