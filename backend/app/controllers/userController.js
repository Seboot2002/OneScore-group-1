const db = require('../../config/database');

const userController = {
    getAllUsers: (req, res) => {
        db.all('SELECT user_id, name, last_name, nickname, mail FROM User', (err, rows) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        res.json({ users: rows });
        });
    },

    getUserById: (req, res) => {
        const { id } = req.params;
        db.get('SELECT user_id, name, last_name, nickname, mail FROM User WHERE user_id = ?', [id], (err, row) => {
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
    }
};

module.exports = userController;