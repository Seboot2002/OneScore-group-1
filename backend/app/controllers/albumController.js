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
        const { title, release_year, genre_id, cover_url, artist_id } = req.body;
        
        // Validación básica
        if (!title || !release_year || !genre_id || !artist_id) {
            res.status(400).json({ 
                error: 'Missing required fields: title, release_year, genre_id, artist_id' 
            });
            return;
        }

        const albumData = { title, release_year, genre_id, cover_url, artist_id };
        
        Album.create(albumData, (err, album) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.status(201).json({ 
                message: 'Album created successfully',
                album: album 
            });
        });
    },

    updateAlbum: (req, res) => {
        const { id } = req.params;
        const { title, release_year, genre_id, cover_url, artist_id } = req.body;
        
        // Validación básica
        if (!title || !release_year || !genre_id || !artist_id) {
            res.status(400).json({ 
                error: 'Missing required fields: title, release_year, genre_id, artist_id' 
            });
            return;
        }

        const albumData = { title, release_year, genre_id, cover_url, artist_id };
        
        Album.update(id, albumData, (err, album) => {
            if (err) {
                if (err.message === 'Album not found') {
                    res.status(404).json({ error: 'Album not found' });
                } else {
                    res.status(500).json({ error: err.message });
                }
                return;
            }
            res.json({ 
                message: 'Album updated successfully',
                album: album 
            });
        });
    },

    deleteAlbum: (req, res) => {
        const { id } = req.params;
        
        Album.delete(id, (err, result) => {
            if (err) {
                if (err.message === 'Album not found') {
                    res.status(404).json({ error: 'Album not found' });
                } else {
                    res.status(500).json({ error: err.message });
                }
                return;
            }
            res.json(result);
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