const express = require('express');
const albumController = require('../app/controllers/albumController');
const router = express.Router();

// Solo define las rutas y delega al controller
router.get('/', albumController.getAllAlbums);
router.get('/:id', albumController.getAlbumById);

module.exports = router;