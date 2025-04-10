const { studentModel } = require("../db")
const { Router } = require("express")
const studentRouter = Router()
const { userMiddleware } = require("../middlewares/userMiddleware")
const { upload } = require("../utils/multer");

// student info input route
studentRouter.post("/infoEntry", userMiddleware, upload.single("image"), async (req, res) => {
    const student_Id = req.userId

    const { fullName, fathersName, mothersName, email, universityRoll, registrationNumber, gender, department, session, boardOfEdu, class12Marks, schoolName, phoneNumber, address, dob, bloodGroup } = req.body

    const imageUrl = req.file.path

    const student = await studentModel.create({
        fullName: fullName,
        fathersName: fathersName,
        mothersName: mothersName,
        email: email,
        universityRoll: universityRoll,
        registrationNumber: registrationNumber,
        gender: gender,
        department: department,
        session: session,
        boardOfEdu: boardOfEdu,
        class12Marks: class12Marks,
        schoolName: schoolName,
        phoneNumber: phoneNumber,
        address: address,
        dob: dob,
        bloodGroup: bloodGroup,
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
