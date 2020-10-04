const Game = require('../models/game');
const mongoose = require('mongoose');

class gameController {

    getGame(req, res) {
        Game.find(function (err, game, next) {
            if (err) return next(err);
            res.json(game);
        });
    }

    getGameByGameName(req,res,next) {
        Game.findOne(req.params.gameName, function (err,game) {
            console.log(req.body);
            if (err) return next(err);
            res.json(game);
        });
    }

    createGame(req,res,next) {
        const game = new Game({
            gameId: req.body.gameId,
            gameName: req.body.gameName,
            description: req.body.description,
            gameIconId: req.body.gameIconId
        });
        game.save();
    }

    updateGame(req,res, next) {
        Game.findOne(req.params.gameName, function (err, game) {
            if (!game) {
                res.status = 404;
                res.json({status: "Not found"});
            }
            else {
                game.gameId = req.body.gameId;
                game.gameName = req.body.gameName;
                game.description = req.body.description;
                game.gameIconId = req.body.gameIconId;
                game.save();
                res.json({status: "Ok"});
            }
        });
    }
}

module.exports = new gameController();




