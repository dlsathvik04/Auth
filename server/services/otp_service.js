var nodemailer = require("nodemailer");

var transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.serverMail,
    pass: process.env.serverMailPassword,
  },
});

module.exports.sendOTP = async function ({ otp, email }) {
  var mailOptions = {
    from: process.env.serverMail,
    to: email,
    subject: "Password Reset OTP",
    text: otp,
  };

  return new Promise((resolve, reject) => {
    transporter.sendMail(mailOptions, function (error, info) {
      if (error) {
        reject(error);
      } else {
        resolve(info);
      }
    });
  });
};
