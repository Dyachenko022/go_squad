const locations = require('../models/locations');
const mongoose = require('mongoose');

class locationsController {

    getLocations(req, res) {
        locations.find(function (err, location, next) {
            if (err) return next(err);
            res.json(location);
        });
    }

    getLocationsById(req,res,next) {
        locations.findById(req.params.id, function (err,locations) {
            console.log(req.body);
            if (err) return next(err);
            res.json(locations);
        });
    }

    createLocations(req,res,next) {
        const location = new locations({
            locationId: req.body.locationId,
            countyName: req.body.countyName
        });
        location.save();
    }

    updateLocations(req,res, next) {
        locations.findById(req.params.id, function (err, location) {
            if (!location) {
                res.status = 404;
                res.json({status: "Not found"});
            }
            else {
                location.locationId = req.body.locationId;
                location.countryName = req.body.countryName;
                location.save();
                res.json({status: "Ok"});
            }
        });
    }
}

module.exports = new locationsController();