const Post = require('../models/post');
const UserInfo = require('../models/userInfo');
const Game = require('../models/game');

class postController {

    getPost(req, res) {
        Post.find(function (err, post, next) {
            if (err) return next(err);
            res.json(post);
        });
    }

    getPostById(req,res,next) {
        Post.findById(req.params.id, function (err,post) {
            console.log(req.body);
            if (err) return next(err);
            res.json(post);
        });
    }

    createPost(req,res,next) {
        var gameIdRes = {};
        Game.findOne({gameId: req.body.gameId}, function (err, game, next) {
            if (err) next(err);
            gameIdRes.gameIdRes = game.body.gameId;
        });
        const post = new Post({
            postId: req.body.postId,
            ownerNickname: req.params.nickname,
            creationTime: req.body.creationTime,
            timeToLive: req.body.timeToLive,
            maxAmountOfPlayer: req.body.maxAmountOfPlayer,
            gameId: gameIdRes,
            description: req.body.description,
            isPrivate: req.body.isPrivate
        });
        post.save();
    }

    updatePost(req,res, next) {
        Post.findById(req.params.id, function (err, post) {
            if (!post) {
                res.status = 404;
                res.json({status: "Not found"});
            }
            else {
                post.postId = req.body.locationId;
                post.ownerNickname = req.body.ownerNickname;
                post.creationTime = req.body.creationTime;
                post.timeToLive = req.body.timeToLive;
                post.maxAmountOfPlayer = req.body.maxAmountOfPlayer;
                post.gameId = req.body.gameId;
                post.description = req.body.description;
                post.isPrivate = req.body.isPrivate;
                post.save();
                res.json({status: "Ok"});
            }
        });
    }
}

module.exports = new postController();