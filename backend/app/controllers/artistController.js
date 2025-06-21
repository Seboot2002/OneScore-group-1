const Artist = require('../models/artistModel');

const artistController = {
    getAllArtists: (req, res) => {
        Artist.getAll((err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json(rows);
        });
    },

    getArtistById: (req, res) => {
        const { id } = req.params;
        Artist.getById(id, (err, row) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (!row) {
                res.status(404).json({ error: 'Artist not found' });
                return;
            }
            res.json(row);
        });
    },

    createArtist: (req, res) => {
        const { name, genre_id, picture_url, debut_year } = req.body;

        // Validación de datos requeridos
        if (!name || !genre_id) {
            res.status(400).json({ 
                error: 'Missing required fields: name and genre_id are required' 
            });
            return;
        }

        // Validación de tipos
        if (typeof name !== 'string' || typeof genre_id !== 'number') {
            res.status(400).json({ 
                error: 'Invalid data types: name must be string, genre_id must be number' 
            });
            return;
        }

        // Validación opcional de debut_year
        if (debut_year !== undefined && debut_year !== null && typeof debut_year !== 'number') {
            res.status(400).json({ 
                error: 'Invalid data type: debut_year must be a number' 
            });
            return;
        }

        // Validación opcional de picture_url
        if (picture_url !== undefined && picture_url !== null && typeof picture_url !== 'string') {
            res.status(400).json({ 
                error: 'Invalid data type: picture_url must be a string' 
            });
            return;
        }

        // Validar que el género existe antes de crear el artista
        Artist.validateGenreExists(genre_id, (err, exists) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (!exists) {
                res.status(400).json({ error: 'Genre not found' });
                return;
            }

            // Crear el artista
            Artist.create({ name, genre_id, picture_url, debut_year }, (err, artist) => {
                if (err) {
                    res.status(500).json({ error: err.message });
                    return;
                }
                res.status(201).json({ 
                    message: 'Artist created successfully',
                    artist: artist 
                });
            });
        });
    },

    updateArtist: (req, res) => {
        const { id } = req.params;
        const { name, genre_id, picture_url, debut_year } = req.body;

        // Validación de datos requeridos
        if (!name || !genre_id) {
            res.status(400).json({ 
                error: 'Missing required fields: name and genre_id are required' 
            });
            return;
        }

        // Validación de tipos
        if (typeof name !== 'string' || typeof genre_id !== 'number') {
            res.status(400).json({ 
                error: 'Invalid data types: name must be string, genre_id must be number' 
            });
            return;
        }

        // Validación opcional de debut_year
        if (debut_year !== undefined && debut_year !== null && typeof debut_year !== 'number') {
            res.status(400).json({ 
                error: 'Invalid data type: debut_year must be a number' 
            });
            return;
        }

        // Validación opcional de picture_url
        if (picture_url !== undefined && picture_url !== null && typeof picture_url !== 'string') {
            res.status(400).json({ 
                error: 'Invalid data type: picture_url must be a string' 
            });
            return;
        }

        // Validar que el género existe antes de actualizar el artista
        Artist.validateGenreExists(genre_id, (err, exists) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (!exists) {
                res.status(400).json({ error: 'Genre not found' });
                return;
            }

            // Actualizar el artista
            Artist.update(id, { name, genre_id, picture_url, debut_year }, (err, artist) => {
                if (err) {
                    if (err.message === 'Artist not found') {
                        res.status(404).json({ error: 'Artist not found' });
                        return;
                    }
                    res.status(500).json({ error: err.message });
                    return;
                }
                res.json({ 
                    message: 'Artist updated successfully',
                    artist: artist 
                });
            });
        });
    },

    deleteArtist: (req, res) => {
        const { id } = req.params;

        Artist.delete(id, (err, deletedArtist) => {
            if (err) {
                if (err.message === 'Artist not found') {
                    res.status(404).json({ error: 'Artist not found' });
                    return;
                }
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({ 
                message: 'Artist deleted successfully',
                artist: deletedArtist 
            });
        });
    },

    searchArtists: (req, res) => {
        const { keyword } = req.params;
        
        if (!keyword) {
            res.status(400).json({ error: 'Keyword is required' });
            return;
        }

        Artist.searchByKeyword(keyword, (err, artists) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json(artists);
        });
    },

    removeArtistFromUser: (req, res) => {
        const { userId, artistId } = req.params;
        
        if (!userId || !artistId) {
            res.status(400).json({ error: 'User ID and Artist ID are required' });
            return;
        }

        Artist.removeFromUser(userId, artistId, (err, result) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({
                message: 'Artist removed from user profile successfully',
                result: result
            });
        });
    }

};

module.exports = artistController;