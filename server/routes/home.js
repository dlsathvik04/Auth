const express = require("express");
const auth = require("../middleware/auth");

const home = express.Router();

home.get("/", auth, (req, res) => {
  // console.log(req.headers.authtoken);
  console.log(req.decodedToken);
  res.send("you are logged in !!!");
});

module.exports = home;
