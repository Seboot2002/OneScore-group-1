const express = require('express');
const albumController = require('../app/controllers/albumController');
const router = express.Router();

// Rutas básicas CRUD
router.get('/', albumController.getAllAlbums);
router.get('/:id', albumController.getAlbumById);
router.post('/', albumController.createAlbum);
router.put('/:id', albumController.updateAlbum);
router.delete('/:id', albumController.deleteAlbum);

// Rutas específicas
router.get('/artist/:artistId', albumController.getAlbumsByArtist);
router.get('/genre/:genreId', albumController.getAlbumsByGenre);

module.exports = router;