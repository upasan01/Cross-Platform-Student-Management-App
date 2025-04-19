const jwt = require("jsonwebtoken")
const { adminModel, studentModel } = require("../db")
const { JWT_SECRET_ADMIN } = require("../config")
const bcrypt = require("bcrypt");
const { z, string } = require("zod");
const { adminMiddleware } = require("../middlewares/adminMiddleware")
const PDFDocument = require("pdfkit");
const axios = require("axios");

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
        doc.text(`Active Backlog: ${x.activeBacklog || 0}`, 350, infoY + 45);

        doc.moveTo(40, infoY + 70).lineTo(550, infoY + 70).stroke();
        doc.moveDown(2);

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

// Exporting the userRouter
module.exports = ({
    adminRouter: adminRouter
})