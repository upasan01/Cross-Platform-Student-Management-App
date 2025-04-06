const jwt = require("jsonwebtoken")
const { userModel } = require("../db")
const { JWT_SECRET_USER } = require("../config")
const bcrypt = require("bcrypt");
const { z, string } = require("zod");

const { Router } = require("express")
const userRouter = Router();

// SignUp Route
userRouter.post("/signup", async (req, res) => {
    const requireBody = z.object({
        email: z.string()
            .min(5)
            .max(100)
            .email(),

        password: z.string()
            .min(8)
            .max(50)
            .regex(/[A-Z]/, { message: "Password must contain atleast on uppercase character" })
            .regex(/[a-z]/, { message: "Password must contain atleast on lowercase character" })
            .regex(/[0-9]/, { message: "Password must contain atleast on number" })
            .regex(/[\W_]/, { message: "Password must contain atleast on special character" }),

        firstName: z.string()
            .min(1)
            .max(100),

        lastName: z.string()
            .min(1)
            .max(100)
    })

    const parsedData = requireBody.safeParse(req.body)

    if(!parsedData.success){
        return res.status(400).json({
            message: "Incorrect format",
            code: 400
        })
    }

    const { email, password, firstName, lastName } = req.body

    try {
        const hashedUserPassword = await bcrypt.hash(password, 10)

        await userModel.create({
            email: email,
            password: hashedUserPassword,
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