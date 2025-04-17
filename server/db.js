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
    studentId: ObjectId,

    //student details
    studentDetails: {
        type: { type: String, required: true },
        fullName: { type: String, required: true },
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
            pin: { type: Number, required: true }
        },

        // residential address
        residentialAddress: {
            fullAddress: { type: String },
            city: { type: String },
            state: { type: String },
            district: { type: String },
            pin: { type: Number }
        }
    },

    // parent's details
    parentsDetails: {
        father: {
            fullName: { type: String, required: true },
            occupation: { type: String },
            phone: { type: Number, required: true },
            income: { type: String },
            aadhaarNumber: { type: Number, required: true }
        },
        mother: {
            fullName: { type: String, required: true },
            occupation: { type: String },
            phone: { type: Number, required: true },
            income: { type: String },
            aadhaarNumber: { type: Number, required: true }
        },
        localGuardian: {
            fullName: { type: String },
            occupation: { type: String },
            address: {
                fullAddress: { type: String },
                city: { type: String },
                state: { type: String },
                district: { type: String },
                pin: { type: Number }
            }
        }
    },

    // students educationals info
    educationalDetails: {
        hs: {
            percentage: { type: Number, required: true },
            board: { type: String, required: true },
            year: { type: Number, required: true },
            school: { type: String },
        },
        secondary: {
            percentage: { type: Number, required: true },
            board: { type: String, required: true },
            year: { type: Number, required: true },
            school: { type: String },
        },
        diploma: {
            cgpa: { type: Number, required: true },
            college: { type: String, required: true },
            stream: { type: String, required: true },
            year: { type: Number, required: true },
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