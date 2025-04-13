const { studentModel, userModel } = require("../db")
const { Router } = require("express")
const studentRouter = Router()
const { userMiddleware } = require("../middlewares/userMiddleware")
const { upload } = require("../utils/multer");
const { z, string } = require("zod");

// student info input route
studentRouter.post("/infoEntry", userMiddleware, upload.single("image"), async (req, res) => {
    // input validation
    const requireBody = z.object({
        fullName: z.string().min(1),
        fathersName: z.string().min(1),
        mothersName: z.string().min(1),
        email: z.string().email(),
        universityRoll: z.string().min(1),
        registrationNumber: z.string().min(1),
        department: z.string().min(1),
        session: z.string().min(1),
        boardOfEdu: z.string().min(1),
        class12Marks: z.string().min(1),
        schoolName: z.string().min(1),
        phoneNumber: z.string(),
        address: z.string().min(1),
        bloodGroup: z.string().min(1)
    });

    const parsedData = requireBody.safeParse(req.body)

    if(!parsedData.success){
        return res.status(400).json({
            message: "incorrect format",
            code: 400,
            error: parsedData.error
        })
    }

    const student_Id = req.userId;
    // console.log(student_Id)

    // user exist in userModel or not
    const userExistOrNot = await userModel.findOne({
        _id: student_Id
    })

    if(!userExistOrNot){
        return res.status(404).json({
            message: "user dont exits",
            code: 404
        })
    }
    
    // Check for existing user
    const existingStudent = await studentModel.findOne({
        studentId: student_Id
    });

    if (existingStudent) {
        return res.status(400).json({
            message: "Student already registered."
        });
    }

    const { fullName, fathersName, mothersName, email, universityRoll, registrationNumber, gender, department, session, boardOfEdu, class12Marks, schoolName, phoneNumber, address, dob, bloodGroup } = req.body;

    const imageUrl = req.file.path;

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
    });

    res.json({
        message: "Student db created",
        studentInfo_ID: student._id
    });
});

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
