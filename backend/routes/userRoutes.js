const express = require('express');
const userController = require('../app/controllers/userController');
const router = express.Router();

router.get('/', userController.getAllUsers);
router.get('/:id', userController.getUserById);

module.exports = router;