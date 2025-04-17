const jwt = require("jsonwebtoken")
const { adminModel, studentModel } = require("../db")
const { JWT_SECRET_ADMIN } = require("../config")
const bcrypt = require("bcrypt");
const { z, string } = require("zod");
const { adminMiddleware } = require("../middlewares/adminMiddleware")

const { Router } = require("express");
const { appendFile } = require("fs");
const { json } = require("stream/consumers");
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
    const { email, password } = req.body

    const admin = await adminModel.findOne({
        email: email
    })

    if (!admin) {
        return res.status(404).json({
            message: "Admin dont exists",
            code: 404
        })
    }

    const adminPasswordMatched = await bcrypt.compare(password, admin.password)

    if (adminPasswordMatched) {
        const token = jwt.sign({
            id: admin._id
        }, JWT_SECRET_ADMIN)

        res.json({
            token
        })
    } else {
        return res.status(401).json({
            message: "Incorrect credentials",
            code: 401
        })
    }
})

// all student info
adminRouter.get("/students", adminMiddleware, async (req, res) => {
    try {
        const students = await studentModel.find({});
        res.json({
            message: "All student info retrieved",
            students: students
        });
    } catch (error) {
        res.status(500).json({
            message: "Error fetching students",
            error: error.message
        });
    }
});

// get search result route (this is for web app or admin panel)
adminRouter.get("/search", adminMiddleware, async (req, res) => {
    const searchQuery = req.query.searchQuery?.trim()  // trims unwanted spaces at start and end
    if (!searchQuery) {
        return res.json([]) // if the search bar is empty then it will send an empty arrry nd will not execute rest of the code
    }

    try {
        const results = await studentModel.find({
            // searches the input pattern wise
            $or: [
                { "studentDetails.fullName": searchQuery },
                { "studentDetails.email": searchQuery }
            ]
        })

        return res.json({
            results
        })
        
    } catch (err) {
        console.error(err);

        return res.status(500).json({
            message: "Something  went wrong",
            code: 500
        })
    }
})


// Exporting the userRouter
module.exports = ({
    adminRouter: adminRouter
})