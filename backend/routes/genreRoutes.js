const express = require('express');
const genreController = require('../app/controllers/genreController');
const router = express.Router();

// Rutas básicas CRUD
router.get('/', genreController.getAllGenres);
router.get('/:id', genreController.getGenreById);
router.post('/', genreController.createGenre);
router.put('/:id', genreController.updateGenre);
router.delete('/:id', genreController.deleteGenre);

module.exports = router;