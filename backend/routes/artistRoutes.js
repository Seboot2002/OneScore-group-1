const express = require('express');
const artistController = require('../app/controllers/artistController');
const router = express.Router();

// Rutas básicas CRUD
router.get('/', artistController.getAllArtists);
router.get('/:id', artistController.getArtistById);
router.post('/', artistController.createArtist);
router.put('/:id', artistController.updateArtist);
router.delete('/:id', artistController.deleteArtist);

// Rutas específicas
router.get('/search/:keyword', artistController.searchArtists);


module.exports = router;