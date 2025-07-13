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
router.delete('/user/:userId/:artistId', artistController.removeArtistFromUser);
router.get('/artist-stats/:id', artistController.getStatsByArtistId);
router.post('/artist-add-user/:id/:user_id', artistController.addToUser);
router.get('/recommend/:userId', artistController.recommendArtistToUser);

router.get('/user-artists-by-state/:userId', artistController.getUserArtistsByState);

module.exports = router;