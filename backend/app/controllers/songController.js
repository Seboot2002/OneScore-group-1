const db = require('../../config/database');

const songController = {
    getAllSongs: (req, res) => {
        const query = `
            SELECT s.*, alb.title as album_title, a.name as artist_name
            FROM Song s
            LEFT JOIN Album alb ON s.album_id = alb.id
            LEFT JOIN Artist a ON alb.artist_id = a.id
        `;
        
        db.all(query, (err, rows) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        res.json({ songs: rows });
        });
    },

    getSongById: (req, res) => {
        const { id } = req.params;
        const query = `
            SELECT s.*, alb.title as album_title, a.name as artist_name
            FROM Song s
            LEFT JOIN Album alb ON s.album_id = alb.id
            LEFT JOIN Artist a ON alb.artist_id = a.id
            WHERE s.id = ?
        `;
        
        db.get(query, [id], (err, row) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        if (!row) {
            res.status(404).json({ error: 'Song not found' });
            return;
        }
        res.json({ song: row });
        });
    }
};

module.exports = songController;