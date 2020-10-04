const express = require('express');
const router = express.Router();
const imageController = require('../controllers/imageController');
const validateTokens = require('../middleware/validateToken');

router.get('/image', validateTokens.validateToken, imageController.getImage);
router.get('/image/:id', validateTokens.validateToken, imageController.getImageById);
router.post('/image', validateTokens.validateToken, imageController.createImage);
router.put('/image/:id', validateTokens.validateToken, imageController.updateImage);


module.exports = router;