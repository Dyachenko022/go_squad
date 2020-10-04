const mongoose = require('mongoose');
const schema = mongoose.Schema;

const userSchema = new mongoose.Schema({
    postId: { type: String, unique: true },
    createByUser: { type: String },
    text: { type: String },
    imageIds: { type: Array }
}, { collection: 'message', versionKey: false});

module.exports = mongoose.model('message', userSchema);