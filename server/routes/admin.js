const jwt = require("jsonwebtoken")
const { adminModel, studentModel } = require("../db")
const { JWT_SECRET_ADMIN } = require("../config")
const bcrypt = require("bcrypt");
const { z, string } = require("zod");
const { adminMiddleware } = require("../middlewares/adminMiddleware")
const PDFDocument = require("pdfkit");
const axios = require("axios");
const ExcelJS = require('exceljs');

const { Router } = require("express");
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

// all student info in chuncks
adminRouter.get("/studentsChunk", adminMiddleware, async (req, res) => {
    const limit = parseInt(req.query.limit) || 10
    const page = parseInt(req.query.page) || 1

    const skip = (page - 1) * limit

    const students = await studentModel.find()
        .skip(skip)
        .limit(limit);

    const total = await studentModel.countDocuments()

    res.json({
        data: students,
        currentPage: page,
        totalPages: Math.ceil(total / limit),
        totalStudents: total
    })
})

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

// certain student info pdf download
adminRouter.get("/:id/pdf", adminMiddleware, async (req, res) => {
    try {
        const student = await studentModel.findById(req.params.id);
        if (!student) return res.status(404).send("Student not found");

        const doc = new PDFDocument();
        let buffers = [];
        doc.on("data", buffers.push.bind(buffers));
        doc.on("end", () => {
            const pdfData = Buffer.concat(buffers);
            res.writeHead(200, {
                "Content-Length": Buffer.byteLength(pdfData),
                "Content-Type": "application/pdf",
                "Content-disposition": `attachment;filename=${student.studentDetails.fullName.replace(/\s+/g, "_")}_CV.pdf`,
            }).end(pdfData);
        });

        const s = student.studentDetails;
        const p = student.parentsDetails;
        const e = student.educationalDetails;
        const x = student.extraDetails;

        // Logo
        const logoUrl = "https://res.cloudinary.com/dqa0z5gqo/image/upload/v1745055743/techno_logo_m781fj.png"; // Replace this with your actual cloud logo URL
        try {
            const logoResponse = await axios.get(logoUrl, { responseType: "arraybuffer" });
            const logoBuffer = Buffer.from(logoResponse.data);
            doc.image(logoBuffer, 40, 30, { width: 60 });
        } catch (err) {
            console.error("Logo load failed:", err.message);
        }

        // Student Image
        if (student.imageUrl) {
            try {
                const imageResponse = await axios.get(student.imageUrl, { responseType: "arraybuffer" });
                const imageBuffer = Buffer.from(imageResponse.data);
                doc.image(imageBuffer, 470, 50, { width: 80, height: 100 });
            } catch (err) {
                console.error("Image load failed:", err.message);
                doc.fontSize(10).text("Photo: Not available", 40, 110);
            }
        }

        // Title
        doc.fontSize(16).text("Techno Engineering College Banipur", 0, 30, { align: "center" });
        doc.fontSize(10).text("(Approved by AICTE, affiliated to MAKAUT, WB)", { align: "center" });
        doc.moveDown().fontSize(12).text("Course Registration (Student Copy): 2023-24 (Autumn)", { align: "center" });

        // Student Info
        doc.fontSize(10);
        const infoY = 110;
        doc.text(`Name: ${s.fullName}`, 110, infoY);
        doc.text(`Program: B.Tech`, 110, infoY + 15);
        doc.text(`Branch: ${s.branch || "CSE"}`, 110, infoY + 30);
        doc.text(`Type: Regular`, 110, infoY + 45);

        doc.text(`Roll: ${s.uniRollNumber || "N/A"}`, 350, infoY);
        doc.text(`Batch: ${s.session}`, 350, infoY + 15);
        doc.text(`Semester: ${s.semester || "VI"}`, 350, infoY + 30);

        doc.moveTo(40, infoY + 70).lineTo(550, infoY + 70).stroke();
        doc.moveDown(4);

        // Personal Info
        const leftX = 40;
        doc.fontSize(14).text("Personal Information", leftX, doc.y, { underline: true });
        doc.fontSize(11);
        doc.text(`DOB: ${new Date(s.dob).toDateString()}`, leftX);
        doc.text(`Gender: ${s.gender}`, leftX);
        doc.text(`Blood Group: ${s.bloodGroup}`, leftX);
        doc.text(`Email: ${s.email}`, leftX);
        doc.text(`Phone: ${s.phoneNumber}`, leftX);
        doc.text(`Aadhaar: ${s.aadhaarNumber}`, leftX);
        doc.text(`PAN: ${s.panNumber || "N/A"}`, leftX);
        doc.text(`Session: ${s.session}`, leftX);
        doc.text(`University Roll: ${s.uniRollNumber || "N/A"}`, leftX);
        doc.text(`Registration Number: ${s.regNumber || "N/A"}`, leftX);
        doc.moveDown();

        // Address
        doc.fontSize(14).text("Addresses", { underline: true });
        doc.fontSize(11);
        doc.text("Permanent Address:");
        doc.text(`${s.permanentAddress.fullAddress}, ${s.permanentAddress.city}, ${s.permanentAddress.state}, ${s.permanentAddress.district} - ${s.permanentAddress.pin}`);
        doc.moveDown();

        doc.text("Residential Address:");
        doc.text(`${s.residentialAddress.fullAddress}, ${s.residentialAddress.city}, ${s.residentialAddress.state}, ${s.residentialAddress.district} - ${s.residentialAddress.pin}`);
        doc.moveDown();

        // Parents
        doc.fontSize(14).text("Parental Information", { underline: true });
        doc.fontSize(11);
        doc.text(`Father: ${p.father.fullName}, ${p.father.occupation || "N/A"}, Phone: ${p.father.phone || "N/A"}`);
        doc.text(`Mother: ${p.mother.fullName}, ${p.mother.occupation || "N/A"}, Phone: ${p.mother.phone || "N/A"}`);
        if (p.localGuardian?.fullName) {
            doc.text(`Local Guardian: ${p.localGuardian.fullName}, ${p.localGuardian.occupation || "N/A"}`);
            if (p.localGuardian.address?.fullAddress) {
                doc.text(`Guardian Address: ${p.localGuardian.address.fullAddress}, ${p.localGuardian.address.city}, ${p.localGuardian.address.state} - ${p.localGuardian.address.pin}`);
            }
        }
        doc.moveDown();

        // Education
        doc.fontSize(14).text("Education", { underline: true });
        doc.fontSize(11);
        doc.text(`Secondary: ${e.secondary.percentage}% from ${e.secondary.board} (${e.secondary.year}) at ${e.secondary.school}`);
        if (e.hs?.percentage) {
            doc.text(`Higher Secondary: ${e.hs.percentage}% from ${e.hs.board || "N/A"} (${e.hs.year || "N/A"}) at ${e.hs.school || "N/A"}`);
        }
        if (e.diploma?.cgpa) {
            doc.text(`Diploma: ${e.diploma.cgpa} CGPA from ${e.diploma.college} in ${e.diploma.stream} (${e.diploma.year})`);
        }
        doc.moveDown();

        // Extra
        doc.fontSize(14).text("Extra Details", { underline: true });
        doc.fontSize(11);
        doc.text(`Hobbies: ${x.hobbies || "N/A"}`);
        doc.text(`Interested Domain: ${x.interestedDomain || "N/A"}`);
        doc.text(`Best Subject: ${x.bestSubject || "N/A"}`);
        doc.text(`Least Favorite Subject: ${x.leastSubject || "N/A"}`);

        doc.end();

    } catch (error) {
        console.error(error);
        res.status(500).send("Internal Server Error");
    }
});

// all students Excel
adminRouter.get("/students/excel", adminMiddleware, async (req, res) => {
    try {
        const students = await studentModel.find({});

        const workbook = new ExcelJS.Workbook();
        const worksheet = workbook.addWorksheet("Students");

        // columns
        worksheet.columns = [
            { header: "Full Name", key: "fullName", width: 25 },
            { header: "University Roll", key: "uniRollNumber", width: 15 },
            { header: "Registration Number", key: "regNumber", width: 20 },
            { header: "Session", key: "session", width: 15 },
            { header: "Phone Number", key: "phoneNumber", width: 15 },
            { header: "Email", key: "email", width: 25 },
            { header: "Aadhaar", key: "aadhaarNumber", width: 20 },
            { header: "PAN", key: "panNumber", width: 20 },
            { header: "DOB", key: "dob", width: 15 },
            { header: "Branch", key: "branch", width: 15 },
            { header: "Gender", key: "gender", width: 10 },
            { header: "Blood Group", key: "bloodGroup", width: 10 },

            // Permanent Address
            { header: "Permanent Address", key: "permanentAddress", width: 40 },

            // Residential Address
            { header: "Residential Address", key: "residentialAddress", width: 40 },

            // Father's Info
            { header: "Father Name", key: "fatherName", width: 20 },
            { header: "Father Occupation", key: "fatherOcc", width: 20 },
            { header: "Father Phone", key: "fatherPhone", width: 20 },

            // Mother's Info
            { header: "Mother Name", key: "motherName", width: 20 },
            { header: "Mother Occupation", key: "motherOcc", width: 20 },
            { header: "Mother Phone", key: "motherPhone", width: 20 },

            // Local Guardian
            { header: "Guardian Name", key: "guardianName", width: 20 },
            { header: "Guardian Address", key: "guardianAddress", width: 30 },

            // Education
            { header: "Secondary %", key: "secondaryPct", width: 15 },
            { header: "Secondary Board", key: "secondaryBoard", width: 20 },
            { header: "Secondary Year", key: "secondaryYear", width: 10 },
            { header: "Secondary School", key: "secondarySchool", width: 30 },

            { header: "HS %", key: "hsPct", width: 15 },
            { header: "HS Board", key: "hsBoard", width: 20 },
            { header: "HS Year", key: "hsYear", width: 10 },
            { header: "HS School", key: "hsSchool", width: 30 },

            { header: "Diploma CGPA", key: "diplomaCgpa", width: 15 },
            { header: "Diploma College", key: "diplomaCollege", width: 20 },
            { header: "Diploma Stream", key: "diplomaStream", width: 15 },
            { header: "Diploma Year", key: "diplomaYear", width: 10 },

            // Extra
            { header: "Hobbies", key: "hobbies", width: 30 },
            { header: "Interested Domain", key: "interestedDomain", width: 25 },
            { header: "Best Subject", key: "bestSubject", width: 20 },
            { header: "Least Favorite Subject", key: "leastSubject", width: 20 },
        ];

        // Add rows
        students.forEach(student => {
            const s = student.studentDetails;
            const p = student.parentsDetails;
            const e = student.educationalDetails;
            const x = student.extraDetails;

            worksheet.addRow({
                fullName: s.fullName,
                uniRollNumber: s.uniRollNumber,
                regNumber: s.regNumber,
                session: s.session,
                phoneNumber: s.phoneNumber,
                email: s.email,
                aadhaarNumber: s.aadhaarNumber,
                panNumber: s.panNumber || "N/A",
                dob: s.dob ? new Date(s.dob).toLocaleDateString() : "N/A",
                branch: s.branch || "N/A",
                gender: s.gender || "N/A",
                bloodGroup: s.bloodGroup || "N/A",

                permanentAddress: `${s.permanentAddress?.fullAddress}, ${s.permanentAddress?.city}, ${s.permanentAddress?.state}, ${s.permanentAddress?.district} - ${s.permanentAddress?.pin}`,
                residentialAddress: `${s.residentialAddress?.fullAddress}, ${s.residentialAddress?.city}, ${s.residentialAddress?.state}, ${s.residentialAddress?.district} - ${s.residentialAddress?.pin}`,

                fatherName: p?.father?.fullName || "N/A",
                fatherOcc: p?.father?.occupation || "N/A",
                fatherPhone: p?.father?.phone || "N/A",

                motherName: p?.mother?.fullName || "N/A",
                motherOcc: p?.mother?.occupation || "N/A",
                motherPhone: p?.mother?.phone || "N/A",

                guardianName: p?.localGuardian?.fullName || "N/A",
                guardianAddress: p?.localGuardian?.address?.fullAddress || "N/A",

                secondaryPct: e?.secondary?.percentage || "N/A",
                secondaryBoard: e?.secondary?.board || "N/A",
                secondaryYear: e?.secondary?.year || "N/A",
                secondarySchool: e?.secondary?.school || "N/A",

                hsPct: e?.hs?.percentage || "N/A",
                hsBoard: e?.hs?.board || "N/A",
                hsYear: e?.hs?.year || "N/A",
                hsSchool: e?.hs?.school || "N/A",

                diplomaCgpa: e?.diploma?.cgpa || "N/A",
                diplomaCollege: e?.diploma?.college || "N/A",
                diplomaStream: e?.diploma?.stream || "N/A",
                diplomaYear: e?.diploma?.year || "N/A",

                hobbies: x?.hobbies || "N/A",
                interestedDomain: x?.interestedDomain || "N/A",
                bestSubject: x?.bestSubject || "N/A",
                leastSubject: x?.leastSubject || "N/A"
            });
        });

        // Send as file
        res.setHeader(
            "Content-Type",
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        );
        res.setHeader(
            "Content-Disposition",
            "attachment; filename=students.xlsx"
        );

        await workbook.xlsx.write(res);
        res.end();
    } catch (err) {
        console.error(err);
        res.status(500).send("Could not generate Excel");
    }
});

// Exporting the userRouter
module.exports = ({
    adminRouter: adminRouter
})