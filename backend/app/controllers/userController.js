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

    getUserByEmail: (req, res) => {
        const { email } = req.params;
        User.getByEmail(email, (err, row) => {
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

    getUserByNickname: (req, res) => {
        const { nickname } = req.params;
        User.getByNickname(nickname, (err, row) => {
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

    updatePassword: (req, res) => {
        const { id } = req.params;
        const { password } = req.body;
        // Aquí deberías hashear la contraseña antes de guardarla
        User.updatePassword(id, password, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (this.changes === 0) {
                res.status(404).json({ error: 'User not found' });
                return;
            }
            res.json({ message: 'Password updated successfully' });
        });
    }
};

module.exports = userController;