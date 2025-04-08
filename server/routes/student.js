const { studentModel } = require("../db")
const { Router } = require("express")
const studentRouter = Router()

// student info input route
studentRouter.post("/infoEntry", async (req, res) => {

})

// student info show route
studentRouter.get("/showInfo", async (req, res) => {

})

module.exports = ({
    studentRouter: studentRouter
})
