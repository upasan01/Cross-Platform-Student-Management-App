const mongoose = require("mongoose")
const { string } = require("zod")
const Schema = mongoose.Schema
const ObjectId = mongoose.Types.ObjectId

const userSchema = new Schema ({
    email: { type: String, unique: true },
    password: String,
    firstName: String,
    lastName: String
})

const adminSchema = new Schema ({
    email: { type: String, unique: true },
    password: String,
    firstName: String,
    lastName: String
})

const studentSchema = new Schema ({
    firstName: String,
    lastName: String,
    email: String,
    universityRoll: Number,
    registrationNumber: Number,
    gender: String,
    department: String,
    session: Number,
    imageUrl: String
})

const userModel = mongoose.model("user", userSchema)
const adminModel = mongoose.model("admin", adminSchema)
const studentModel = mongoose.model("student", studentSchema)

module.exports = ({
    userModel,
    adminModel,
    studentModel
})