const jwt = require("jsonwebtoken")
const { JWT_SECRET_USER } = require("../config")

const userMiddleware = (req, res, next) => {
    const token = req.headers.token

    const decoded = jwt.verify(token, JWT_SECRET_USER)

    if(decoded){
        req.userId = decoded.id;
        next()
    }else{
        res.status(401).json({
            message: "You are not signed in",
            code: 401
        })
    }
}

module.exports = ({
    userMiddleware: userMiddleware
})