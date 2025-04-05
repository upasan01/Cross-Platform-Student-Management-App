const jwt = require("jsonwebtoken")
const { adminModel } = require("../db")
const { JWT_SECRET_ADMIN } = require("../config")
const bcrypt = require("bcrypt");
const { z, string } = require("zod");

const { Router } = require("express")
const adminRouter = Router()

// SignUp Route
adminRouter.post("/signup", async (req, res) => {

})

// SignIn Route
adminRouter.post("/signin", async (req, res) => {

})

// Exporting the userRouter
module.exports = ({
    adminRouter: adminRouter
})