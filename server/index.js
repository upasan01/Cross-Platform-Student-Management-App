require("dotenv").config()
const express = require("express")
const mongoose = require("mongoose")
const { userRouter } = require("./routes/user")
const { adminRouter } = require("./routes/admin")
const { studentRouter } = require("./routes/student")
const cors = require("cors")

const app = express()
app.use(cors())
app.use(express.json())

app.use("/api/v1/user", userRouter)
app.use("/api/v1/admin", adminRouter)
app.use("/api/v1/student", studentRouter)

const main = async() => {
    await mongoose.connect(process.env.MONGO_URL)
    app.listen(3000)
    console.log("App is listening on port 3000")
}

main()