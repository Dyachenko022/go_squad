const messages = require('../models/message');

class messageController {

    getMessage(req, res) {
        messages.find(function (err, message, next) {
            if (err) return next(err);
            res.json(message);
        });
    }

    getMessageById(req,res,next) {
        messages.findById(req.params.id, function (err,message) {
            console.log(req.body);
            if (err) return next(err);
            res.json(message);
        });
    }

    createMessage(req,res,next) {
        const message = new messages({
            postId: req.body.postId,
            createByUser: req.body.createByUser,
            text: req.body.text,
            imageIds: req.body.imageIds
        });
        message.save();
    }

    updateMessage(req,res, next) {
        messages.findById(req.params.id, function (err, message) {
            if (!message) {
                res.status = 404;
                res.json({status: "Not found"});
            }
            else {
                message.postId = req.body.postId;
                message.createByUser = req.body.createByUser;
                message.text = req.body.text;
                message.imageIds = req.body.imageIds;
                message.save();
                res.json({status: "Ok"});
            }
        });
    }
}

module.exports = new messageController();