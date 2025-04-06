const jwt = require("jsonwebtoken")
const { userModel } = require("../db")
const { JWT_SECRET_USER } = require("../config")
const bcrypt = require("bcrypt");
const { z, string } = require("zod");

const { Router } = require("express")
const userRouter = Router();

// SignUp Route
userRouter.post("/signup", async (req, res) => {
    const { email, password, firstName, lastName } = req.body

    try {
        await userModel.create({
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        })
    } catch (err) {
        res.status(409).json({
            message: "User already exists",
            code: 409
        })
    }

    res.json({
        message: "User Signed Up!"
    })
})

// SignIn Route
userRouter.post("/signin", async (req, res) => {

})

// Exporting the userRouter
module.exports = ({
    userRouter: userRouter
})