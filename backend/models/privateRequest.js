const mongoose = require('mongoose');
const schema = mongoose.Schema;

const userSchema = new mongoose.Schema({
    ownerNickname: { type: String },
    requestedUserNickname: { type: String },
    postId: { type: String}
}, { collection: 'privateRequest', versionKey: false});

module.exports = mongoose.model('privateRequest', userSchema);