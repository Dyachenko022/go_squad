const mongoose = require('mongoose');
const schema = mongoose.Schema;

const userSchema = new mongoose.Schema({
    gameId: { type: String, unique: true },
    gameIcon: { type: String }
}, { collection: 'gameIcon', versionKey: false});

module.exports = mongoose.model('gameIcon', userSchema);