const Platform = require('../models/platform');
const mongoose = require('mongoose');

class platformController {

    getPlatform(req,res) {
        Platform.find(function (err,platform,next) {
            if (err) return next(err);
            res.json(platform);
        });
    }

    getPlatformById(req,res,next) {
        console.log(req);
        Platform.findById(req.params.id, function (err,platform) {
            console.log(req.body);
            if (err) return next(err);
            res.json(platform);
        });
    }

    createPlatform(req,res,next) {
        const platform = new Platform({
            platformId: req.body.platformId,
            platformName: req.body.platformName,
            icon: req.body.icon
        });
        platform.save();
    }

    updatePlatform(req,res,next) {
        Platform.findById(req.params.id, function (err, platform) {
            if (!platform) {
                res.statusCode = 404;
                res.json({status: "Not found"});
            }
            else {
                platform.platformId = req.body.platformId;
                platform.platformName = req.body.platformName;
                platform.icon = req.body.icon;
                platform.save();
                res.json({status: "Ok"});
            }
        })
    }

}

module.exports = new platformController();