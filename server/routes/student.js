const { studentModel } = require("../db")
const { Router } = require("express")
const studentRouter = Router()
const { userMiddleware } = require("../middlewares/userMiddleware")

// student info input route
studentRouter.post("/infoEntry", userMiddleware, async (req, res) => {
    const student_Id = req.userId

    const { firstName, lastName, email, universityRoll, registrationNumber, gender, department, session, phoneNumber, address, dob, imageUrl } = req.body

    const student = await studentModel.create({
        firstName: firstName,
        lastName: lastName,
        email: email,
        universityRoll: universityRoll,
        registrationNumber: registrationNumber,
        gender: gender,
        department: department,
        session: session,
        phoneNumber: phoneNumber,
        address: address,
        dob: dob,
        imageUrl: imageUrl,
        studentId: student_Id
    })

    res.json({
        message: "Student db created",
        studentInfo_ID: student._id
    })
})

// student info show route
studentRouter.get("/showInfo", userMiddleware, async (req, res) => {
    const student_Id = req.userId

    try {
        const studentInfo = await studentModel.findOne({
            studentId: student_Id
        })

        if (!studentInfo) {
            return res.status(404).json({
                message: "Student info not found"
            })
        } else {
            res.json({
                message: "Student info retrieved",
                studentInfo: studentInfo
            })
        }

    } catch (error) {
        res.status(500).json({
            message: "Error fetching student info", error: error.message
        })
    }
})


module.exports = ({
    studentRouter: studentRouter
})
