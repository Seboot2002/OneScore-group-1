const express = require('express');
const albumController = require('../app/controllers/albumController');
const userController = require('../app/controllers/userController');
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
router.get('/search/:keyword', albumController.searchAlbums);
router.post('/user/:userId/:albumId', albumController.addAlbumToUser);
router.delete('/user/:userId/:albumId', albumController.removeAlbumFromUser);
router.post('/rate', albumController.rateAlbum);
router.get('/album-songs/:id', albumController.getSongsByAlbumId);
router.get('/recommend-albums/:userId', albumController.recommendAlbumsToUser);
router.get('/check-user-album/:userId/:albumId', albumController.getUserAlbumRankState);
router.get('/average-rating/:userId/:albumId', albumController.getUserAlbumAverageRating);
router.get('/song-ratings/:userId/:albumId', albumController.getSongRatingsByUserAndAlbum);

router.get('/user-albums-by-state/:userId', albumController.getUserAlbumsByState);

module.exports = router;