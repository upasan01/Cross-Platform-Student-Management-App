const mongoose = require("mongoose")
const Schema = mongoose.Schema
const ObjectId = mongoose.Types.ObjectId

const userSchema = new Schema ({ // user login info
    email: { type: String, unique: true },
    password: String,
    firstName: String,
    lastName: String
})

const adminSchema = new Schema ({ // admin login info
    email: { type: String, unique: true },
    password: String,
    firstName: String,
    lastName: String
})

const studentSchema = new Schema ({ // student info
    fullName: String,
    fathersName: String,
    mothersName: String,
    email: String,
    universityRoll: Number,
    registrationNumber: Number,
    gender: String,
    department: String,
    session: String,
    boardOfEdu: String,
    class12Marks: Number,
    schoolName: String,
    phoneNumber: Number,
    address: String,
    dob: Date,
    bloodGroup: String,
    imageUrl: String,
    studentId: ObjectId 
})

const userModel = mongoose.model("user", userSchema)
const adminModel = mongoose.model("admin", adminSchema)
const studentModel = mongoose.model("student", studentSchema)

module.exports = ({
    userModel,
    adminModel,
    studentModel
})