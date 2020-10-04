const mongoose = require('mongoose');
const authHelper = require('../helpers/authHelper');
const config = require('config');
const secret = config.get("jwtToken.secret");
const Token = require('../models/token');
const jwt = require('jsonwebtoken');

const updateTokens = (userId) => {
    const accessToken = authHelper.generateAccessToken(userId);
    const refreshToken = authHelper.generateRefreshToken();
    return authHelper.replaceDbRefreshToken(refreshToken.id, userId)
        .then(() => ({
            accessToken,
            refreshToken: refreshToken.token
        }));
};

const refreshTokens = (req, res) => {
    const {refreshToken} = req.body;
    let payload;
    try {
        payload = jwt.verify(refreshToken, secret);
        if (payload.type !== 'refresh') {
            res.status(400).json({ message: "Invalid token"});
            return;
        }
    } catch (e) {
        if (e instanceof jwt.TokenExpiredError) {
            res.status(400).json({ message: "Token expired"});
        } else if (e instanceof jwt.JsonWebTokenError) {
            res.status(400).json({ message: "Invalid token"});
            return;
        }
    }
    Token.findOne({tokenId: payload.id}).exec()
        .then((token)=> {
            if (token === null) {
                throw new Error('invalid token');
            }
            return updateTokens(token.userId);
        }).then(tokens => {
            res.json(tokens);
    }).catch(err => res.status(400).json({ message: err.message}));
};

module.exports = {
    updateTokens,
    refreshTokens
};

