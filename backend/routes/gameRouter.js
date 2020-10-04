const express = require('express');
const router = express.Router();
const gameController = require('../controllers/gameController');
const validateTokens = require('../middleware/validateToken');

router.get('/game', validateTokens.validateToken, gameController.getGame);
router.get('/game/:id', validateTokens.validateToken, gameController.getGameByGameName);
router.post('/game', validateTokens.validateToken, gameController.createGame);
router.put('/game/:id', validateTokens.validateToken, gameController.updateGame);


module.exports = router;