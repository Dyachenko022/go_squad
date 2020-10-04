const mongoose = require('mongoose');
const schema = mongoose.Schema;

const userSchema = new mongoose.Schema({
    gameId: { type: String, unique: true },
    gameName: { type: String, unique: true },
    description: { type: String },
    gameIconId: { type: String }
}, { collection: 'game', versionKey: false});

module.exports = mongoose.model('game', userSchema);