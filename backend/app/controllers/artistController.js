const Artist = require('../models/artistModel');

const artistController = {
    getAllArtists: (req, res) => {
        Artist.getAll((err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({ artists: rows });
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
            res.json({ artist: row });
        });
    },

    createArtist: (req, res) => {
        const artistData = req.body;
        Artist.create(artistData, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.status(201).json({ 
                message: 'Artist created successfully',
                artistId: this.lastID 
            });
        });
    },

    updateArtist: (req, res) => {
        const { id } = req.params;
        const artistData = req.body;
        Artist.update(id, artistData, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (this.changes === 0) {
                res.status(404).json({ error: 'Artist not found' });
                return;
            }
            res.json({ message: 'Artist updated successfully' });
        });
    },

    deleteArtist: (req, res) => {
        const { id } = req.params;
        Artist.delete(id, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (this.changes === 0) {
                res.status(404).json({ error: 'Artist not found' });
                return;
            }
            res.json({ message: 'Artist deleted successfully' });
        });
    },

    getArtistsByGenre: (req, res) => {
        const { genreId } = req.params;
        Artist.getByGenreId(genreId, (err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({ artists: rows });
        });
    }
};

module.exports = artistController;