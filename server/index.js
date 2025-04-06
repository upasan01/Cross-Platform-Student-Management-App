require("dotenv").config()
const express = require("express")
const mongoose = require("mongoose")
const { userRouter } = require("./routes/user")
const { adminRouter } = require("./routes/admin")

const app = express()
app.use(express.json())

app.use("/api/v1/user", userRouter)
app.use("/api/v1/admin", adminRouter)

const main = async() => {
    await mongoose.connect(process.env.MONGO_URL)
    app.listen(3000)
    console.log("App is listening on port 3000")
}

main()