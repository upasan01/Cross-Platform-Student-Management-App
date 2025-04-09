const jwt = require("jsonwebtoken")
const { JWT_SECRET_ADMIN } = require("../config")

const adminMiddleware = (req, res, next) => {
    const token = req.headers.token

    const decoded = jwt.verify(token, JWT_SECRET_ADMIN)

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
    adminMiddleware: adminMiddleware
})