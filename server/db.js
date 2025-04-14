const mongoose = require("mongoose")
const Schema = mongoose.Schema
const ObjectId = mongoose.Types.ObjectId

const userSchema = new Schema({ // user login info
    email: { type: String, unique: true },
    password: String,
    firstName: String,
    lastName: String
})

const adminSchema = new Schema({ // admin login info
    email: { type: String, unique: true },
    password: String,
    firstName: String,
    lastName: String
})

const studentSchema = new Schema({ // student info
    imageUrl: String,

    //student details
    studentDetails: {
        type: { type: String, enum: ["Regular", "Lateral"], required: true },
        name: { type: String, required: true },
        uniRollNumber: { type: Number },
        regNumber: { type: Number },
        session: { type: String, required: true },
        phoneNumber: { type: Number, required: true },
        email: { type: String, required: true },
        dob: { type: Date, required: true },
        gender: { type: String, required: true },
        bloodGroup: { type: String, required: true },
        religion: { type: String },
        category: { type: String, required: true },
        motherTounge: { type: String },
        height: { type: String },
        weight: { type: String },

        // permanent address
        permanentAddress: {
            fullAddress: { type: String, required: true },
            city: { type: String, required: true },
            state: { type: String, required: true },
            district: { type: String, required: true },
            pin: { type: String, required: true }
        },

        // residential address
        residentialAddress: {
            fullAddress: { type: String },
            city: { type: String },
            state: { type: String },
            district: { type: String },
            pin: { type: String }
        }
    },

    // parent's details
    parentsDetails: {
        father: {
            name: { type: String, required: true },
            occupation: { type: String },
            phone: { type: String, required: true },
            income: { type: String }
        },
        mother: {
            name: { type: String, required: true },
            occupation: { type: String },
            phone: { type: String, required: true },
            income: { type: String }
        },
        localGuardian: {
            name: { type: String },
            occupation: { type: String },
            address: { type: String }
        }
    },

    // students educationals info
    educationalDetails: {
        hs: {
            percentage: { type: String, required: true },
            board: { type: String, required: true },
            year: { type: String, required: true },
            school: { type: String },
        },
        secondary: {
            percentage: { type: String, required: true },
            board: { type: String, required: true },
            year: { type: String, required: true },
            school: { type: String },
        },
        diploma: {
            cgpa: { type: String, required: true },
            college: { type: String, required: true },
            stream: { type: String, required: true },
            year: { type: String, required: true },
        },
    },

    //extracurrucular info
    extraDetails: {
        hobbies: { type: String },
        interestedDomain: { type: String },
        bestSubject: { type: String },
        leastSubject: { type: String }
    }
})

const userModel = mongoose.model("user", userSchema)
const adminModel = mongoose.model("admin", adminSchema)
const studentModel = mongoose.model("student", studentSchema)

module.exports = ({
    userModel,
    adminModel,
    studentModel
})