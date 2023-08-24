const express = require("express");
const home = require("./routes/home");
const users = require("./routes/users");

const app = express();

// Middleware ======================================================
app.use(express.json());

// Route Table =====================================================
app.use("/", home);
app.use("/users", users);

const port = process.env.PORT || 8000;

const server = app.listen(port, () => {
  console.log(`listening to ${port}......`);
});
