const express = require('express');
const router = express.Router();
const platform = require('../models/platform');
const mongoose = require('mongoose');
const platformController = require('../controllers/platformController');
const validateTokens = require('../middleware/validateToken');

router.get('/platform', validateTokens.validateToken, platformController.getPlatform);
router.get('/platform/:id', validateTokens.validateToken, platformController.getPlatformById);
router.post('/platform', validateTokens.validateToken, platformController.createPlatform);
router.put('/platform/:id', validateTokens.validateToken, platformController.updatePlatform);


module.exports = router;