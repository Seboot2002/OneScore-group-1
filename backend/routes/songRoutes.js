const express = require('express');
const songController = require('../app/controllers/songController');
const router = express.Router();

// Rutas básicas CRUD
router.get('/', songController.getAllSongs);
router.get('/:id', songController.getSongById);
router.post('/', songController.createSong);
router.put('/:id', songController.updateSong);
router.delete('/:id', songController.deleteSong);

// Rutas específicas
router.get('/album/:albumId', songController.getSongsByAlbum);
router.get('/search', songController.searchSongs); // /songs/search?q=title

module.exports = router;