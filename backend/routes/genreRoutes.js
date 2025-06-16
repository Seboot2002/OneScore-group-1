const express = require('express');
const db = require('../config/database');
const router = express.Router();

// GET all genres
router.get('/', (req, res) => {
    db.all('SELECT * FROM Genre', (err, rows) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        res.json({ genres: rows });
    });
});

// GET genre by ID
router.get('/:id', (req, res) => {
    const { id } = req.params;
    db.get('SELECT * FROM Genre WHERE id = ?', [id], (err, row) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        if (!row) {
            res.status(404).json({ error: 'Genre not found' });
            return;
        }
        res.json({ genre: row });
    });
});

module.exports = router;