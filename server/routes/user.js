const jwt = require("jsonwebtoken")
const { userModel } = require("../db")
const { JWT_SECRET_USER } = require("../config")
const bcrypt = require("bcrypt");
const { z, string } = require("zod");

const { Router } = require("express")
const userRouter = Router();

// SignUp Route
userRouter.post("/signup", async (req, res) => {

})

// SignIn Route
userRouter.post("/signin", async (req, res) => {

})

// Exporting the userRouter
module.exports = ({
    userRouter: userRouter
})