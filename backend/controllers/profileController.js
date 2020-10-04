const profile = require('../models/profile');
const mongoose = require('mongoose');

class profileController {

    getProfile(req,res) {
        profile.find(function (err,profile,next) {
            if (err) return next(err);
            res.json(profile);
        });
    }

    getProfileById(req,res,next) {
        console.log(req);
        profile.findById(req.params.id, function (err,user) {
            console.log(req.body);
            if (err) return next(err);
            res.json(user);
        });
    }

    createProfile(req,res,next) {
        const profiles = new profile({
            platformId: new mongoose.Types.ObjectId(),
            nickname: req.body.nickname
        });
        profiles.save();
    }

    updateProfile(req,res,next) {
        profile.findById(req.params.id, function (err, profile) {
            if (!profile) {
                res.statusCode = 404;
                res.json({status: "Not found"});
            }
            else {
                profile.platformId = req.body.platformId;
                profile.nickname = req.body.nickname;
                profile.save();
                res.json({status: "Ok"});
            }
        })
    }

}

module.exports = new profileController();