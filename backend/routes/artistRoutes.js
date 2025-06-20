const express = require('express');
const artistController = require('../app/controllers/artistController');
const router = express.Router();

// Rutas básicas CRUD
router.get('/', artistController.getAllArtists);           // GET /artists
router.get('/:id', artistController.getArtistById);       // GET /artists/:id
router.post('/', artistController.createArtist);          // POST /artists
router.put('/:id', artistController.updateArtist);        // PUT /artists/:id
router.delete('/:id', artistController.deleteArtist);     // DELETE /artists/:id

module.exports = router;