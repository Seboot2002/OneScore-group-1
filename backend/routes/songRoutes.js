const express = require('express');
const songController = require('../app/controllers/songController');
const router = express.Router();

// Rutas básicas CRUD
router.get('/', songController.getAllSongs);           // GET /songs
router.get('/:id', songController.getSongById);       // GET /songs/:id
router.post('/', songController.createSong);          // POST /songs
router.put('/:id', songController.updateSong);        // PUT /songs/:id
router.delete('/:id', songController.deleteSong);     // DELETE /songs/:id

// Rutas específicas (puedes agregar más rutas específicas aquí)

module.exports = router;