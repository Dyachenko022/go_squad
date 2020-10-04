const mongoose = require('mongoose');
const schema = mongoose.Schema;

const userSchema = new mongoose.Schema({
    platformId: { type: String, unique: true },
    platformName: { type: String },
    icon: { type: String }
}, { collection: 'platform', versionKey: false});

module.exports = mongoose.model('platform', userSchema);