const Genre = require('../models/genreModel');

const genreController = {
    getAllGenres: (req, res) => {
        Genre.getAll((err, rows) => {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.json({ genres: rows });
        });
    },

    getGenreById: (req, res) => {
        const { id } = req.params;
        Genre.getById(id, (err, row) => {
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
    },

    createGenre: (req, res) => {
        const { name } = req.body;
        
        // Validación básica
        if (!name) {
            res.status(400).json({ error: 'Name is required' });
            return;
        }

        const genreData = { name };
        Genre.create(genreData, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            res.status(201).json({ 
                message: 'Genre created successfully',
                genreId: this.lastID 
            });
        });
    },

    updateGenre: (req, res) => {
        const { id } = req.params;
        const { name } = req.body;
        
        // Validación básica
        if (!name) {
            res.status(400).json({ error: 'Name is required' });
            return;
        }

        const genreData = { name };
        Genre.update(id, genreData, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (this.changes === 0) {
                res.status(404).json({ error: 'Genre not found' });
                return;
            }
            res.json({ message: 'Genre updated successfully' });
        });
    },

    deleteGenre: (req, res) => {
        const { id } = req.params;
        Genre.delete(id, function(err) {
            if (err) {
                res.status(500).json({ error: err.message });
                return;
            }
            if (this.changes === 0) {
                res.status(404).json({ error: 'Genre not found' });
                return;
            }
            res.json({ message: 'Genre deleted successfully' });
        });
    },
};

module.exports = genreController;