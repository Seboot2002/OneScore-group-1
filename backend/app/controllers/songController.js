const Song = require('../models/songModel');

const songController = {
    getAllSongs: (req, res) => {
        Song.getAll((err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json(rows);
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
            res.json(row);
        });
    },

    createSong: (req, res) => {
        const { title, n_track, album_id } = req.body;

        // Validación de datos requeridos
        if (!title || !n_track || !album_id) {
            res.status(400).json({ 
                error: 'Missing required fields: title, n_track, and album_id are required' 
            });
            return;
        }

        // Validación de tipos
        if (typeof title !== 'string' || typeof n_track !== 'number' || typeof album_id !== 'number') {
            res.status(400).json({ 
                error: 'Invalid data types: title must be string, n_track and album_id must be numbers' 
            });
            return;
        }

        // Validar que el álbum existe antes de crear la canción
        Song.validateAlbumExists(album_id, (err, exists) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (!exists) {
                res.status(400).json({ error: 'Album not found' });
                return;
            }

            // Crear la canción
            Song.create({ title, n_track, album_id }, (err, song) => {
                if (err) {
                    res.status(500).json({ error: err.message });
                    return;
                }
                res.status(201).json({ 
                    message: 'Song created successfully',
                    song: song 
                });
            });
        });
    },

    updateSong: (req, res) => {
        const { id } = req.params;
        const { title, n_track, album_id } = req.body;

        // Validación de datos requeridos
        if (!title || !n_track || !album_id) {
            res.status(400).json({ 
                error: 'Missing required fields: title, n_track, and album_id are required' 
            });
            return;
        }

        // Validación de tipos
        if (typeof title !== 'string' || typeof n_track !== 'number' || typeof album_id !== 'number') {
            res.status(400).json({ 
                error: 'Invalid data types: title must be string, n_track and album_id must be numbers' 
            });
            return;
        }

        // Validar que el álbum existe antes de actualizar la canción
        Song.validateAlbumExists(album_id, (err, exists) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (!exists) {
                res.status(400).json({ error: 'Album not found' });
                return;
            }

            // Actualizar la canción
            Song.update(id, { title, n_track, album_id }, (err, song) => {
                if (err) {
                    if (err.message === 'Song not found') {
                        res.status(404).json({ error: 'Song not found' });
                        return;
                    }
                    res.status(500).json({ error: err.message });
                    return;
                }
                res.json({ 
                    message: 'Song updated successfully',
                    song: song 
                });
            });
        });
    },

    deleteSong: (req, res) => {
        const { id } = req.params;

        Song.delete(id, (err, deletedSong) => {
            if (err) {
                if (err.message === 'Song not found') {
                    res.status(404).json({ error: 'Song not found' });
                    return;
                }
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({ 
                message: 'Song deleted successfully',
                song: deletedSong 
            });
        });
    }
};

module.exports = songController;