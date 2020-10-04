const express = require('express');
const router = express.Router();
const postController = require('../controllers/postController');
const validateTokens = require('../middleware/validateToken');

router.get('/post', validateTokens.validateToken, postController.getPost);
router.get('/post/:id', validateTokens.validateToken, postController.getPostById);
router.post('/post/:nickname', validateTokens.validateToken, postController.createPost);
router.put('/post/:id', validateTokens.validateToken, postController.updatePost);


module.exports = router;