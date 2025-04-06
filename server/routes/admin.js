const jwt = require("jsonwebtoken")
const { adminModel } = require("../db")
const { JWT_SECRET_ADMIN } = require("../config")
const bcrypt = require("bcrypt");
const { z, string } = require("zod");

const { Router } = require("express")
const adminRouter = Router()

// SignUp Route
adminRouter.post("/signup", async (req, res) => {
    const requireBody = z.object({
        email: z.string()
            .min(5)
            .max(100)
            .email(),

        password: z.string()
            .min(8)
            .max(50)
            .regex(/[A-Z]/, { message: "Password must contain atleas one uppercase character" })
            .regex(/[a-z]/, { message: "Password must contain atleas one lowercase character" })
            .regex(/[0-9]/, { message: "Password must contain atleas one number" })
            .regex(/[\W_]/, { message: "Password must contain atleas one special character" }),

        firstName: z.string()
            .min(1)
            .max(100),

        lastName: z.string()
            .min(1)
            .max(100)
    })

    const parsedData = requireBody.safeParse(req.body)

    if (!parsedData.success) {
        return res.status(400).json({
            message: "Incorrect format",
            error: parsedData.error
        })
    }

    const { email, password, firstName, lastName } = req.body

    try {
        const hashedAdminPassword = await bcrypt.hash(password, 10)
        await adminModel.create({
            email: email,
            password: hashedAdminPassword,
            firstName: firstName,
            lastName: lastName
        })
    } catch (err) {
        res.status(409).json({
            message: "Admin already exists",
            code: 409
        })
    }

    res.json({
        message: "Admin Signed up"
    })
})

// SignIn Route
adminRouter.post("/signin", async (req, res) => {

})

// Exporting the userRouter
module.exports = ({
    adminRouter: adminRouter
})