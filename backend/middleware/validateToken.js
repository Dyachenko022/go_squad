const config = require('config');
const secret = config.get('jwtToken.secret');
const jwt = require('jsonwebtoken');

class validateTokens {
    validateToken(req,res,next) {
        const authorizationHeader = req.headers.authorization;
        if (!authorizationHeader) {
            res.status(401).json({ message: "Token not provided"});
            return;
        } else {
            const token = req.headers.authorization.split(' ')[1];
            try {
                const payload = jwt.verify(token, secret);
                if (payload.type !== 'access') {
                    res.status(401).json({message: "Invalid token"});
                    return;
                }
            } catch (err) {
                if (err instanceof jwt.TokenExpiredError) {
                    res.status(401).json({message: "Token expired"});
                    return;
                }
                if (err instanceof  jwt.JsonWebTokenError) {
                    res.status(401).json({ message: "Invalid token"});
                }
            }
        }
        next();
    }
}

module.exports = new validateTokens();