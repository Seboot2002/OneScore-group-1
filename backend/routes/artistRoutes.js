const express = require('express');
const db = require('../config/database');
const router = express.Router();

// GET all artists
router.get('/', (req, res) => {
    const query = `
        SELECT a.*, g.name as genre_name 
        FROM Artist a 
        LEFT JOIN Genre g ON a.genre_id = g.id
    `;
    db.all(query, (err, rows) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        res.json({ artists: rows });
    });
});

// GET artist by ID
router.get('/:id', (req, res) => {
    const { id } = req.params;
    const query = `
        SELECT a.*, g.name as genre_name 
        FROM Artist a 
        LEFT JOIN Genre g ON a.genre_id = g.id
        WHERE a.id = ?
    `;
    db.get(query, [id], (err, row) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        if (!row) {
            res.status(404).json({ error: 'Artist not found' });
            return;
        }
        res.json({ artist: row });
    });
});

module.exports = router;