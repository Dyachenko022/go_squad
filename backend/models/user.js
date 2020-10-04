const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const Schema = mongoose.Schema;
const saltRound = 10;

const userSchema = new mongoose.Schema({
    id: mongoose.Schema.Types.ObjectId,
    email: { type: String, unique: true },
    nickname: { type: String, unique: true },
    password: { type: String }
}, { collection: 'user', versionKey: false});

userSchema.pre('save', function(next) {
    this.password = bcrypt.hashSync(this.password, saltRound);
    next();
});

module.exports = mongoose.model('User',userSchema);