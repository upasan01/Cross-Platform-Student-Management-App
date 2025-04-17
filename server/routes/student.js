const { studentModel, userModel } = require("../db")
const { Router } = require("express")
const studentRouter = Router()
const { userMiddleware } = require("../middlewares/userMiddleware")
const { upload } = require("../utils/multer");
const { z, string, boolean } = require("zod");

// student image upload route
studentRouter.post("/uploadImage", userMiddleware, upload.single("image"), async (req, res) => {
    const student_Id = req.userId;
    // console.log(student_Id)

    // Check image upload
    if (!req.file) {
        return res.status(400).json({
            message: "No image uploaded",
            code: 400
        });
    }

    const imageUrl = req.file.path;

    try {
        let student = await studentModel.findOne({ studentId: student_Id });

        // If student doesn't exist then create new student with imageUrl & studentId
        if (!student) {
            student = new studentModel({
                studentId: student_Id,
                imageUrl: imageUrl
            });
            // validate false before save
            await student.save({
                validateBeforeSave: false
            });

        } else {
            // If exists then updat imageUrl
            student.imageUrl = imageUrl;
            await student.save();
        }

        res.status(200).json({
            message: "Image uploaded successfully",
            imageUrl: imageUrl,
            studentInfo_ID: student._id
        });

    } catch (error) {
        console.error("Error uploading image:", error); // for debugging
        res.status(500).json({
            message: "Error uploading image",
            error: error.message
        });
    }
});


// student info input route
studentRouter.post("/infoEntry", userMiddleware, async (req, res) => {
    // Zod Schemas
    const studentDetailsSchema = z.object({
        type: z.string(),
        fullName: z.string().min(1),
        uniRollNumber: z.number().min(1).optional().nullable(),
        regNumber: z.number().min(1).optional().nullable(),
        session: z.string().min(1),
        phoneNumber: z.number().min(3999999999).max(9999999999),
        email: z.string().email().min(1),
        aadhaarNumber: z.number().min(1).nullable(),
        panNumber: z.number().min(1).optional().nullable(),
        dob: z.string().min(1),
        gender: z.string().min(1),
        bloodGroup: z.string().min(1),
        religion: z.string().optional(),
        category: z.string().min(1),
        motherTounge: z.string().optional(),
        height: z.string().optional(),
        weight: z.string().optional(),
        permanentAddress: z.object({
            fullAddress: z.string().min(1),
            city: z.string().min(1),
            state: z.string().min(1),
            district: z.string().min(1),
            pin: z.number().min(1).nullable()
        }),
        residentialAddress: z.object({
            fullAddress: z.string().min(1),
            city: z.string().min(1),
            state: z.string().min(1),
            district: z.string().min(1),
            pin: z.number().min(1).nullable()
        })
    });

    const parentsDetailsSchema = z.object({
        father: z.object({
            fullName: z.string().min(1),
            occupation: z.string().optional(),
            phone: z.number().min(3999999999).max(9999999999).optional().nullable(),
            income: z.string().optional(),
            aadhaarNumber: z.number().min(1).nullable(),
            panNumber: z.number().min(1).nullable()
        }),
        mother: z.object({
            fullName: z.string().min(1),
            occupation: z.string().optional(),
            phone: z.number().min(3999999999).max(9999999999).optional().nullable(),
            income: z.string().optional(),
            aadhaarNumber: z.number().min(1).nullable(),
            panNumber: z.number().min(1).optional().nullable()
        }),
        localGuardian: z.object({
            fullName: z.string().optional(),
            occupation: z.string().optional(),
            address: z.object({
                fullAddress: z.string().optional(),
                city: z.string().optional(),
                state: z.string().optional(),
                district: z.string().optional(),
                pin: z.number().min(1).optional().nullable()
            }).optional()
        }).optional(),
    });

    const educationalDetailsSchema = z.object({
        hs: z.object({
            board: z.string().optional(),
            year: z.number().min(1).optional().nullable(),
            percentage: z.number().min(1).optional().nullable(),
            school: z.string().optional()
        }).optional(),
        secondary: z.object({
            board: z.string().min(1),
            year: z.number().min(1).nullable(),
            percentage: z.number().min(1).nullable(),
            school: z.string().min(1)
        }),
        diploma: z.object({
            year: z.number().min(1).optional().nullable(),
            college: z.string().optional(),
            cgpa: z.number().min(1).optional().nullable(),
            stream: z.string().optional()
        }).optional(),
    });

    const extraDetailsSchema = z.object({
        hobbies: z.string().optional(),
        interestedDomain: z.string().optional(),
        bestSubject: z.string().optional(),
        leastSubject: z.string().optional()
    }).optional();

    const studentInfoSchema = z.object({
        studentDetails: studentDetailsSchema,
        parentsDetails: parentsDetailsSchema,
        educationalDetails: educationalDetailsSchema,
        extraDetails: extraDetailsSchema
    });

    // validation check
    const validationResult = studentInfoSchema.safeParse(req.body);
    if (!validationResult.success) {
        return res.status(400).json({
            message: "Incorrect format",
            errors: validationResult.error.errors
        });
    }

    const student_Id = req.userId;

    // Check if user exists in userModel
    const userExistOrNot = await userModel.findOne({ _id: student_Id });

    if (!userExistOrNot) {
        return res.status(404).json({
            message: "User doesn't exist",
            code: 404
        });
    }

    // existiung user check
    const existingStudent = await studentModel.findOne({
        studentId: student_Id
    });

    const { studentDetails, parentsDetails, educationalDetails, extraDetails } = req.body;

    // dstructuring the payloads
    const { type, fullName, uniRollNumber, regNumber, session, phoneNumber, email, aadhaarNumber, panNumber, dob, gender, bloodGroup, religion, category, motherTounge, height, weight, permanentAddress, residentialAddress } = studentDetails;

    const { father, mother, localGuardian } = parentsDetails;

    const { hs, secondary, diploma } = educationalDetails;

    const { hobbies, interestedDomain, bestSubject, leastSubject } = extraDetails;

    try {
        if (existingStudent) {
            existingStudent.studentDetails = {
                type,
                fullName,
                uniRollNumber,
                regNumber,
                session,
                phoneNumber,
                email,
                aadhaarNumber,
                panNumber,
                dob,
                gender,
                bloodGroup,
                religion,
                category,
                motherTounge,
                height,
                weight,
                permanentAddress,
                residentialAddress
            };

            existingStudent.parentsDetails = {
                father,
                mother,
                localGuardian
            };

            existingStudent.educationalDetails = {
                hs,
                secondary,
                diploma
            };

            existingStudent.extraDetails = {
                hobbies,
                interestedDomain,
                bestSubject,
                leastSubject
            };

            await existingStudent.save();

            return res.status(200).json({
                message: "Student record updated",
                studentInfo_ID: existingStudent._id
            });

        } else {
            const newStudent = await studentModel.create({
                studentId: student_Id,
                studentDetails: {
                    type,
                    fullName,
                    uniRollNumber,
                    regNumber,
                    session,
                    phoneNumber,
                    email,
                    aadhaarNumber,
                    panNumber,
                    dob,
                    gender,
                    bloodGroup,
                    religion,
                    category,
                    motherTounge,
                    height,
                    weight,
                    permanentAddress,
                    residentialAddress
                },
                parentsDetails: {
                    father,
                    mother,
                    localGuardian
                },
                educationalDetails: {
                    hs,
                    secondary,
                    diploma
                },
                extraDetails: {
                    hobbies,
                    interestedDomain,
                    bestSubject,
                    leastSubject
                }
            });

            return res.status(201).json({
                message: "Student record created",
                studentInfo_ID: newStudent._id
            });
        }
    } catch (error) {
        console.error("Error saving student:", error);
        return res.status(500).json({
            message: "Error saving student record",
            error: error.message
        });
    }
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
