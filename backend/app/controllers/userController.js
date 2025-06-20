const User = require('../models/userModel');

const userController = {
    getAllUsers: (req, res) => {
        User.getAll((err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({ users: rows });
        });
    },

    getUserById: (req, res) => {
        const { id } = req.params;
        User.getById(id, (err, row) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (!row) {
                res.status(404).json({ error: 'User not found' });
                return;
            }
            res.json({ user: row });
        });
    },

    createUser: (req, res) => {
        const userData = req.body;
        User.create(userData, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.status(201).json({ 
                message: 'User created successfully',
                userId: this.lastID 
            });
        });
    },

    updateUser: (req, res) => {
        const { id } = req.params;
        const userData = req.body;
        User.update(id, userData, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (this.changes === 0) {
                res.status(404).json({ error: 'User not found' });
                return;
            }
            res.json({ message: 'User updated successfully' });
        });
    },

    deleteUser: (req, res) => {
        const { id } = req.params;
        User.delete(id, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (this.changes === 0) {
                res.status(404).json({ error: 'User not found' });
                return;
            }
            res.json({ message: 'User deleted successfully' });
        });
    },
};

module.exports = userController;