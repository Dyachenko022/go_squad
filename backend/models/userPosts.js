const mongoose = require('mongoose');
const schema = mongoose.Schema;

const userSchema = new mongoose.Schema({
    userNickname: { type: String },
    userPostsId: { type: Array }
}, { collection: 'userPosts', versionKey: false});

module.exports = mongoose.model('userPosts', userSchema);