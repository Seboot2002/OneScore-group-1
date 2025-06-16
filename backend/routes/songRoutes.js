const express = require('express');
const songController = require('../app/controllers/songController');
const router = express.Router();

router.get('/', songController.getAllSongs);
router.get('/:id', songController.getSongById);

module.exports = router;