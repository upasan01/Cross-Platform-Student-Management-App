const { studentModel, userModel } = require("../db")
const { Router } = require("express")
const studentRouter = Router()
const { userMiddleware } = require("../middlewares/userMiddleware")
const { upload } = require("../utils/multer");
const { z, string, boolean } = require("zod");

// student image upload route
studentRouter.post("/uploadImage", userMiddleware, upload.single("image"), async (req, res) => {
    const student_Id = req.userId;

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
    const { type, fullName, uniRollNumber, regNumber, session, phoneNumber, email, dob, gender, bloodGroup, religion, category, motherTounge, height, weight, permanentAddress, residentialAddress } = studentDetails;

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
