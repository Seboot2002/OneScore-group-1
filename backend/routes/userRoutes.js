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
router.get('/user-info/:id', userController.getBasicInfoById);
router.get('/user-stats/:id', userController.getUserStats);
router.get('/user-albums/:id', userController.getAlbumsByUserId);
router.get('/user-artists/:id', userController.getArtistsByUserId);
router.post('/registerNewUser',userController.registerNewUser);
router.put('/updateUserPassword/:id',userController.updateUserPassword);
router.put('/updateUserProfile/:id', userController.updateUserProfile);

module.exports = router;