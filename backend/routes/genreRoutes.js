const express = require('express');
const genreController = require('../app/controllers/genreController');
const router = express.Router();

router.get('/', genreController.getAllGenres);
router.get('/:id', genreController.getGenreById);

module.exports = router;