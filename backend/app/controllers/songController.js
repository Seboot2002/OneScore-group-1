const Song = require('../models/songModel');

const songController = {
    getAllSongs: (req, res) => {
        Song.getAll((err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({ songs: rows });
        });
    },

    getSongById: (req, res) => {
        const { id } = req.params;
        Song.getById(id, (err, row) => {
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
    },

    createSong: (req, res) => {
        const songData = req.body;
        Song.create(songData, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.status(201).json({ 
                message: 'Song created successfully',
                songId: this.lastID 
            });
        });
    },

    updateSong: (req, res) => {
        const { id } = req.params;
        const songData = req.body;
        Song.update(id, songData, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (this.changes === 0) {
                res.status(404).json({ error: 'Song not found' });
                return;
            }
            res.json({ message: 'Song updated successfully' });
        });
    },

    deleteSong: (req, res) => {
        const { id } = req.params;
        Song.delete(id, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (this.changes === 0) {
                res.status(404).json({ error: 'Song not found' });
                return;
            }
            res.json({ message: 'Song deleted successfully' });
        });
    },

    getSongsByAlbum: (req, res) => {
        const { albumId } = req.params;
        Song.getByAlbumId(albumId, (err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({ songs: rows });
        });
    },

    searchSongs: (req, res) => {
        const { q } = req.query;
        if (!q) {
            res.status(400).json({ error: 'Search term is required' });
            return;
        }
        Song.searchByTitle(q, (err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({ songs: rows });
        });
    }
};

module.exports = songController;