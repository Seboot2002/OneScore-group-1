const Album = require('../models/albumModel');

const albumController = {
    getAllAlbums: (req, res) => {
        Album.getAll((err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({ albums: rows });
        });
    },

    getAlbumById: (req, res) => {
        const { id } = req.params;
        Album.getById(id, (err, row) => {
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
    },

    createAlbum: (req, res) => {
        const albumData = req.body;
        Album.create(albumData, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.status(201).json({ 
                message: 'Album created successfully',
                albumId: this.lastID 
            });
        });
    },

    updateAlbum: (req, res) => {
        const { id } = req.params;
        const albumData = req.body;
        Album.update(id, albumData, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (this.changes === 0) {
                res.status(404).json({ error: 'Album not found' });
                return;
            }
            res.json({ message: 'Album updated successfully' });
        });
    },

    deleteAlbum: (req, res) => {
        const { id } = req.params;
        Album.delete(id, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (this.changes === 0) {
                res.status(404).json({ error: 'Album not found' });
                return;
            }
            res.json({ message: 'Album deleted successfully' });
        });
    },

    getAlbumsByArtist: (req, res) => {
        const { artistId } = req.params;
        Album.getByArtistId(artistId, (err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({ albums: rows });
        });
    },

    getAlbumsByGenre: (req, res) => {
        const { genreId } = req.params;
        Album.getByGenreId(genreId, (err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({ albums: rows });
        });
    }
};

module.exports = albumController;