const db = require('../../config/database');

const albumController = {
    getAllAlbums: (req, res) => {
        const query = `
            SELECT alb.*, a.name as artist_name, g.name as genre_name
            FROM Album alb
            LEFT JOIN Artist a ON alb.artist_id = a.id
            LEFT JOIN Genre g ON alb.genre_id = g.id
        `;
        
        db.all(query, (err, rows) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        res.json({ albums: rows });
        });
    },

    getAlbumById: (req, res) => {
        const { id } = req.params;
        const query = `
            SELECT alb.*, a.name as artist_name, g.name as genre_name
            FROM Album alb
            LEFT JOIN Artist a ON alb.artist_id = a.id
            LEFT JOIN Genre g ON alb.genre_id = g.id
            WHERE alb.id = ?
        `;
        
        db.get(query, [id], (err, row) => {
        if (err) {
            res.status(500).json({ error: err.message });
            return;
        }
        if (!row) {
            res.status(404).json({ error: 'Album not found' });
            return;
        }
        res.json({ album: row });
        });
    }
};

module.exports = albumController;