const mongoose = require('mongoose');

const studentSchema = new mongoose.Schema({
  imageUrl: String,
  studentId: mongoose.Schema.Types.ObjectId,

  studentDetails: {
    type: { type: String, required: true },
    fullName: { type: String, required: true },
    uniRollNumber: { type: Number },
    regNumber: { type: Number },
    session: { type: String, required: true },
    phoneNumber: { type: Number, required: true },
    email: { type: String, required: true },
    aadhaarNumber: { type: Number, required: true },
    panNumber: { type: Number, required: true },
    dob: { type: Date, required: true },
    gender: { type: String, required: true },
    bloodGroup: { type: String, required: true },
    religion: { type: String },
    category: { type: String, required: true },
    motherTounge: { type: String },
    height: { type: String },
    weight: { type: String },
    permanentAddress: {
      fullAddress: { type: String, required: true },
      city: { type: String, required: true },
      state: { type: String, required: true },
      district: { type: String, required: true },
      pin: { type: Number, required: true }
    },
    residentialAddress: {
      fullAddress: { type: String },
      city: { type: String },
      state: { type: String },
      district: { type: String },
      pin: { type: Number }
    }
  },

  parentsDetails: {
    father: {
      fullName: { type: String, required: true },
      occupation: { type: String },
      phone: { type: Number, required: true },
      income: { type: String },
      aadhaarNumber: { type: Number, required: true },
      panNumber: { type: Number, required: true },
    },
    mother: {
      fullName: { type: String, required: true },
      occupation: { type: String },
      phone: { type: Number, required: true },
      income: { type: String },
      aadhaarNumber: { type: Number, required: true },
      panNumber: { type: Number, required: true },
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

  educationalDetails: {
    hs: {
      percentage: { type: Number },
      board: { type: String },
      year: { type: Number },
      school: { type: String },
    },
    secondary: {
      percentage: { type: Number, required: true },
      board: { type: String, required: true },
      year: { type: Number, required: true },
      school: { type: String, required: true },
    },
    diploma: {
      cgpa: { type: Number },
      college: { type: String },
      stream: { type: String },
      year: { type: Number },
    },
  },

  extraDetails: {
    hobbies: { type: String },
    interestedDomain: { type: String },
    bestSubject: { type: String },
    leastSubject: { type: String }
  }
});

module.exports = mongoose.model('students', studentSchema);
