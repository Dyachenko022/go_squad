const GameIcon = require('../models/gameIcon');
const mongoose = require('mongoose');

class gameIconController {

    getGameIcon(req, res) {
        GameIcon.find(function (err, gameIcon, next) {
            if (err) return next(err);
            res.json(gameIcon);
        });
    }

    getGameIconById(req,res,next) {
        GameIcon.findById(req.params.id, function (err,gameIcon) {
            console.log(req.body);
            if (err) return next(err);
            res.json(gameIcon);
        });
    }

    createGameIcon(req,res,next) {
        const gameIcon = new GameIcon({
            gameId: req.body.gameId,
            gameIcon: req.body.gameIcon
        });
        gameIcon.save();
    }

    updateGameIcon(req,res, next) {
        GameIcon.findById(req.params.id, function (err, gameIcon) {
            if (!gameIcon) {
                res.status = 404;
                res.json({status: "Not found"});
            }
            else {
                gameIcon.gameId = req.body.gameId;
                gameIcon.gameIcon = req.body.gameIcon;
                gameIcon.save();
                res.json({status: "Ok"});
            }
        });
    }
}

module.exports = new gameIconController();




