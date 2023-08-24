const User = require("../models/user");
const express = require("express");
const bcrypt = require("bcrypt");
const _ = require("lodash");
const { sendOTP } = require("../services/otp_service");

const users = express.Router();

// route for regustration
users.post("/register", async (req, res) => {
  const { error, value } = User.validate(req.body);
  if (error) {
    return res.status(400).send(error.message);
  }
  if (value.userId) return res.status(400).send("invalid request");
  let salt = await bcrypt.genSalt(10);
  let hashedPassword = await bcrypt.hash(req.body.password, salt);
  let newuser = _.omit(req.body, ["password"]);
  newuser["hashedPassword"] = hashedPassword;
  try {
    let usr = await User.addUser(newuser);
    usr = _.omit(usr, ["hashedPassword"]);
    usr.authToken = await User.generateAuthToken({
      phoneNumber: usr.phoneNumber,
    });
    res.status(200).send(JSON.stringify(usr));
  } catch (err) {
    res.status(400).send(err.message);
  }
});

// route for login
users.post("/login", async (req, res) => {
  if (!req.body.password) return res.status(400).send("password required");
  if (!req.body.phoneNumber)
    return res.status(400).send("phone number required");
  var phoneNumber = req.body.phoneNumber;
  let user = await User.getUser({ phoneNumber: phoneNumber });
  if (!user.userId)
    return res.status(400).send("invalid phone Number or password");
  var isValidPassword = await bcrypt.compare(
    req.body.password,
    user.hashedPassword
  );
  if (isValidPassword) {
    var authToken = await User.generateAuthToken({ phoneNumber: phoneNumber });
    res.send(
      JSON.stringify({
        authToken: authToken,
      })
    );
  } else {
    return res.status(400).send("invalid phone number or password");
  }
});

// route to get an otp when forgot password
users.post("/forgotPassword", async (req, res) => {
  var phoneNumber = req.body.phoneNumber;
  let user = await User.getUser({ phoneNumber: phoneNumber });
  if (!user.userId) return res.status(400).send("invalid phone number");
  let otp;
  try {
    otp = await User.getOtp({ phoneNumber: phoneNumber });
  } catch (error) {
    return res.status(400).send("Can't send otp right now");
  }
  try {
    await sendOTP({ otp: otp, email: user.email }); // Change this with phone number otp service
  } catch (error) {
    return res.status(400).send("Can't send otp right now");
  }
  res.send("otp sent");
});

// route to change otp after changing the password
users.post("/changePassword", async (req, res) => {
  var phoneNumber = req.body.phoneNumber;
  let user = await User.getUser({ phoneNumber: phoneNumber });
  if (!user.userId) return res.status(400).send("invalid email");
  if (!req.body.otp) return res.status(400).send("no otp provided");
  if (!req.body.newPassword)
    return res.status(400).send("no password provided");
  try {
    let salt = await bcrypt.genSalt(10);
    let hashedPassword = await bcrypt.hash(req.body.newPassword, salt);
    let message = await User.verifyOtpAndChangePassword({
      phoneNumber: phoneNumber,
      otp: req.body.otp,
      newHashedPassword: hashedPassword,
    });
    return res.send(message);
  } catch (error) {
    return res.status(400).send("Invalid otp");
  }
});

module.exports = users;
