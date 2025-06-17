const express = require('express');
const userController = require('../app/controllers/userController');
const router = express.Router();

// Rutas básicas CRUD
router.get('/', userController.getAllUsers);
router.get('/:id', userController.getUserById);
router.post('/', userController.createUser);
router.put('/:id', userController.updateUser);
router.delete('/:id', userController.deleteUser);

// Rutas específicas
router.get('/email/:email', userController.getUserByEmail);
router.get('/nickname/:nickname', userController.getUserByNickname);
router.put('/:id/password', userController.updatePassword);

module.exports = router;