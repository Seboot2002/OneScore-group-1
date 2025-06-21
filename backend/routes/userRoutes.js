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
router.post('/login', userController.loginUser);
router.get('/search/:keyword', userController.searchUsers);

module.exports = router;