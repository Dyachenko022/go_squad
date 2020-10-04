const mongoose = require('mongoose');
const schema = mongoose.Schema;

const userSchema = new mongoose.Schema({
    postId: { type: String, unique: true },
    ownerNickname: { type: String },
    creationTime: { type: Date, default: Date.now() },
    timeToLive: { type: Number, default: 60},
    maxAmountOfPlayer: { type: Number },
    gameId: { type: String },
    description: { type: String },
    isPrivate: { type: Boolean},

}, { collection: 'post', versionKey: false});

module.exports = mongoose.model('post', userSchema);