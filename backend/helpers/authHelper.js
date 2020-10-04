const config = require('config');
const jwt = require('jsonwebtoken');
const secret = config.get("jwtToken.secret");
const uuid = require('uuidv4');
const mongoose = require('mongoose');
const Token = require('../models/token');


const generateAccessToken = (userId) => {
    const payload = {
        userId,
        type: config.get("jwtToken.tokens.access.type")
    };
    const options = { expiresIn: config.get("jwtToken.tokens.access.expiresIn")};
    return jwt.sign(payload, secret, options);
};

const generateRefreshToken = () => {
    const payload = {
        id: uuid.uuid(),
        type: config.get("jwtToken.tokens.refresh.type")
    };
    const options = { expiresIn: config.get("jwtToken.tokens.refresh.expiresIn")};
    return {
        id: payload.id,
        token: jwt.sign(payload, secret, options)
    };
};

const replaceDbRefreshToken = (tokenId, userId) => {
    return Token.findOneAndRemove({userId})
        .exec().then(() => Token.create({tokenId, userId}));

};

module.exports = {
    generateAccessToken,
    generateRefreshToken,
    replaceDbRefreshToken
}