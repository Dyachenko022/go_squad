const express = require('express');
const router = express.Router();
const gameIconController = require('../controllers/gameIconController');
const validateTokens = require('../middleware/validateToken');

router.get('/gameIcon', validateTokens.validateToken, gameIconController.getGameIcon);
router.get('/gameIcon/:id', validateTokens.validateToken, gameIconController.getGameIconById);
router.post('/gameIcon', validateTokens.validateToken, gameIconController.createGameIcon);
router.put('/gameIcon/:id', validateTokens.validateToken, gameIconController.updateGameIcon);


module.exports = router;