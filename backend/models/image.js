const mongoose = require('mongoose');
const schema = mongoose.Schema;

const userSchema = new mongoose.Schema({
    imageId: { type: String, unique: true },
    imageUrl: { type: String },
}, { collection: 'image', versionKey: false});

module.exports = mongoose.model('image', userSchema);