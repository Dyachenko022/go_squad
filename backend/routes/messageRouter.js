const express = require('express');
const router = express.Router();
const messageController = require('../controllers/messageController');
const validateTokens = require('../middleware/validateToken');

router.get('/message', validateTokens.validateToken, messageController.getMessage);
router.get('/message/:id', validateTokens.validateToken, messageController.getMessageById);
router.post('/message', validateTokens.validateToken, messageController.createMessage);
router.put('/message/:id', validateTokens.validateToken, messageController.updateMessage);


module.exports = router;