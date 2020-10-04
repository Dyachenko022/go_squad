const express = require('express');
const router = express.Router();
const locations = require('../models/locations');
const mongoose = require('mongoose');
const locationsController = require('../controllers/locationsController');
const validateTokens = require('../middleware/validateToken');

router.get('/locations', validateTokens.validateToken, locationsController.getLocations);
router.get('/locations/:id', validateTokens.validateToken, locationsController.getLocationsById);
router.post('/locations', validateTokens.validateToken, locationsController.createLocations);
router.put('/locations/:id', validateTokens.validateToken, locationsController.updateLocations);


module.exports = router;