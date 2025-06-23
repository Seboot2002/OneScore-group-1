const User = require('../models/userModel');

const userController = {
    getAllUsers: (req, res) => {
        User.getAll((err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json(rows);
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
            res.json(row);
        });
    },

    getBasicInfoById: (req, res) => {
        const { id } = req.params;
        User.getBasicInfoById(id, (err, result) => {
            if (err) {
                res.status(500).json({ error: err.message });
            }
            if (!result) {
                res.status(404).json({ error: 'User not found' });
            }
            res.json(result);
        });
    },

    getUserStats: (req, res) => {
        const { id } = req.params;
        User.getUserStats(id, (err, stats) => {
            if (err) {
                res.status(500).json({ error: err.message });
            }
            if (!stats) {
                res.status(404).json({ error: 'UserData not found' });
            }
            res.json(stats);
        });
    },

    getAlbumsByUserId: (req, res) => {
        const { id } = req.params;
        User.getAlbumsByUserId(id, (err, albums) => {
            if (err) {
                res.status(500).json({ error: err.message });
            }
            if (!albums) {
                res.status(404).json({ error: 'UserData not found' });
            }
            res.json(albums);
        });
    },

    getArtistsByUserId: (req, res) => {
        const { id } = req.params;
        User.getArtistsByUserId(id, (err, artists) => {
            if (err) {
                res.status(500).json({ error: err.message });
            }
            if (!artists) {
                res.status(404).json({ error: 'UserData not found' });
            }
            res.json(artists);
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

    loginUser: (req, res) => {
        const { login, password } = req.body;
        
        if (!login || !password) {
            res.status(400).json({ 
                error: 'Missing required fields: login and password are required' 
            });
            return;
        }

        User.login(login, password, (err, user) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (!user) {
                res.status(401).json({ error: 'Invalid credentials' });
                return;
            }
            res.json({
                message: 'Login successful',
                user: user
            });
        });
    },

    searchUsers: (req, res) => {
        const { keyword } = req.params;
        
        if (!keyword) {
            res.status(400).json({ error: 'Keyword is required' });
            return;
        }

        User.searchByKeyword(keyword, (err, users) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json(users);
        });
    }
};

module.exports = userController;