const User = require('../models/user');
const mongoose = require('mongoose');
const { validationResult } = require('express-validator');
const config = require('config');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const UserInfo = require('../models/userInfo');
const authHepler = require('../helpers/authHelper');
const auth = require('./authController');


class userController {
    getUsers(req,res) {
        let result = {};
        let status = 200;
                User.find(function (err,user) {
            if (!err) {
                result.status = status;
                result.error = err;
                result.result = user;
            } else {
                status = 500;
                result.status = status;
                result.error = err;
            }
            res.status(status).send(result);

                });
    }

    getUserByID(req,res,next) {
        User.findById(req.params.id, function (err,user) {
            if (err) return next(err);
            res.json(user);
        });
    }

    createUser(req,res,next) {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({errors: errors.array()});
        }
        else {
            const user = new User({
                _id: new mongoose.Types.ObjectId(),
                email: req.body.email,
                nickname: req.body.nickname,
                password: req.body.password
            });
            user.save();
            res.status(200).json({ message: "User created"});
            const userInfo = new UserInfo({
                nickname: req.body.nickname
            });
            userInfo.save();
        }
    }

    authenticate(req,res) {
        const result = {};
            User.findOne({email: req.body.email}).exec().then((user)=> {
                if (!user) {
                    res.status(401).json({ message: 'User does not exists'});
                }
                const isValid = bcrypt.compare(req.body.password, user.password).then(match =>{
                    if (isValid) {
                        result.user = {
                            id: user._id,
                            nickname: user.nickname,
                            email: user.email
                    };
                        auth.updateTokens(user._id).then(tokens => {
                            result.tokens = tokens;
                            res.status(200).send(result);
                        });
                    } else {
                        res.status(401).json({ message: "Invalid data"});
                    }
                })
            }).catch(err => res.status(500).json({ message: err.message}));

    }


    async updateUser(req,res,next) {
        try {
            const updates = req.body;
            const id = req.params.id;
            const options = {new: true};
            console.log(id);
            console.log(updates);
            const result = await User.findByIdAndUpdate(req.params.id, updates, options);
            if (result) {
                return res.status(200).json({ message: "User updates"});
            }
            else if (!result) {
                return res.status(404).json({ message: "User does not exist"});
            }
        } catch (e) {
            if (e instanceof mongoose.CastError) {
                return res.status(400).json({ message: "Invalid user id"});
            }
            next(e);
        }
    }

    removeUser(req,res,next) {
        const id = req.params.id;
        User.remove({_id:id}).then(result=>{
            res.status(200).json({ message: "User deleted"});
        });
    }

}

module.exports = new userController();


