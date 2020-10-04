const mongoose = require('mongoose');
const schema = mongoose.Schema;
const user = require('../models/user');


const userSchema = new mongoose.Schema({
    nickname: { type: String, unique: true},
    serviceIds: { type: Array},
    firstName: { type: String },
    lastName: { type: String },
    dateOfBirth: { type: Date, default: Date.now() },
    voiceChat: { type: Boolean },
    platformIds: { type: Array},
    country: { type: Number },
    about: { type: String}
}, { collection: 'userInfo', versionKey: false});

module.exports = mongoose.model('UserInfo', userSchema);
