const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const Schema = mongoose.Schema;
const saltRound = 10;

const userSchema = new mongoose.Schema({
    tokenId: { type: String, unique: true },
    userId: { type: String }
}, { collection: 'token', versionKey: false});


module.exports = mongoose.model('Token',userSchema);