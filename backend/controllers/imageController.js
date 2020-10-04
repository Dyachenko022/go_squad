const Image = require('../models/image');
const mongoose = require('mongoose');

class imageController {

    getImage(req,res) {
        Image.find(function (err, image, next) {
            if (err) return next(err);
            res.json(image);
        });
    }

    getImageById(req,res,next) {
        console.log(req);
        Image.findById(req.params.id, function (err, image) {
            console.log(req.body);
            if (err) return next(err);
            res.json(image);
        });
    }

    createImage(req,res,next) {
        const image = new Image({
            imageId: req.body.imageId,
            imageUrl: req.body.imageUrl
        });
        image.save();
    }

    updateImage(req,res,next) {
        Image.findById(req.params.id, function (err, image) {
            if (!image) {
                res.statusCode = 404;
                res.json({status: "Not found"});
            }
            else {
                image.imageId = req.body.imageId;
                image.imageUrl = req.body.imageUrl;
                image.save();
                res.json({status: "Ok"});
            }
        })
    }

}

module.exports = new imageController();