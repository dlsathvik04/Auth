const db = require("../services/db");
const _ = require("lodash");
const Joi = require("joi");
const jwt = require("jsonwebtoken");

function getUser({ email, userId, phoneNumber }, callBack) {
  if (callBack) {
    if (email) {
      let sql = `SELECT * FROM user WHERE email='${email}'`;
      db.query(sql, (err, res) => {
        return callBack(err, _.omit(res[0]));
      });
    }
    if (userId) {
      let sql = `SELECT * FROM user WHERE userId='${userId}'`;
      db.query(sql, (err, res) => {
        return callBack(err, _.omit(res[0]));
      });
    }
    if (phoneNumber) {
      let sql = `SELECT * FROM user WHERE phoneNumber='${phoneNumber}'`;
      db.query(sql, (err, res) => {
        return callBack(err, _.omit(res[0]));
      });
    }
  } else {
    return new Promise((resolve, reject) => {
      if (email) {
        let sql = `SELECT * FROM user WHERE email='${email}'`;
        db.query(sql, (err, res) => {
          if (err) reject(err);
          resolve(_.omit(res[0]));
        });
      }
      if (userId) {
        let sql = `SELECT * FROM user WHERE userId='${userId}'`;
        db.query(sql, (err, res) => {
          if (err) reject(err);
          resolve(_.omit(res[0]));
        });
      }
      if (phoneNumber) {
        let sql = `SELECT * FROM user WHERE phoneNumber='${phoneNumber}'`;
        db.query(sql, (err, res) => {
          if (err) reject(err);
          resolve(_.omit(res[0]));
        });
      }
    });
  }
}

exports.getUser = getUser;

exports.addUser = function (
  {
    firstName,
    lastName,
    hashedPassword,
    houseNo,
    streetName,
    pinCode,
    phoneNumber,
    email,
  },
  callBack
) {
  if (callBack) {
    let sql = `INSERT INTO user(firstName, lastName, hashedPassword, houseNo, streetName, pinCode, phoneNumber, email) 
  VALUES ('${firstName}', '${lastName}', '${hashedPassword}', '${houseNo}', '${streetName}', '${pinCode}', '${phoneNumber}', '${email}');`;
    db.query(sql, (err, res) => {
      if (err) return callBack(err, res);
      let sql = `SELECT * FROM user WHERE phoneNumber='${phoneNumber}'`;
      db.query(sql, (err, res) => {
        return callBack(err, _.omit(res[0]));
      });
    });
  } else {
    return new Promise((resolve, reject) => {
      let sql = `INSERT INTO user(firstName, lastName, hashedPassword, houseNo, streetName, pinCode, phoneNumber, email) 
  VALUES ('${firstName}', '${lastName}', '${hashedPassword}', '${houseNo}', '${streetName}', '${pinCode}', '${phoneNumber}', '${email}');`;
      db.query(sql, (err, res) => {
        if (err) reject(err);
        let sql = `SELECT * FROM user WHERE phoneNumber='${phoneNumber}'`;
        db.query(sql, (err, res) => {
          if (err) reject(err);
          resolve(_.omit(res[0]));
        });
      });
    });
  }
};

exports.updateUser = function (
  {
    firstName,
    lastName,
    hashedPassword,
    houseNo,
    streetName,
    pinCode,
    phoneNumber,
    email,
  },
  callBack
) {
  if (callBack) {
    let sql = `UPDATE user
    SET firstName = '${firstName}', lastName = '${lastName}', hashedPassword = '${hashedPassword}', houseNo = '${houseNo}', streetName = '${streetName}', pinCode = '${pinCode}'
    WHERE phoneNumber='${phoneNumber}'`;
    db.query(sql, (err, res) => {
      if (err) return callBack(err, res);
      let sql = `SELECT * FROM user WHERE phoneNumber='${phoneNumber}'`;
      db.query(sql, (err, res) => {
        return callBack(err, _.omit(res[0]));
      });
    });
  } else {
    return new Promise((resolve, reject) => {
      let sql = `UPDATE user
    SET firstName = '${firstName}', lastName = '${lastName}', hashedPassword = '${hashedPassword}', houseNo = '${houseNo}', streetName = '${streetName}', pinCode = '${pinCode}'
    WHERE phoneNumber='${phoneNumber}'`;
      db.query(sql, (err, res) => {
        if (err) reject(err);
        let sql = `SELECT * FROM user WHERE phoneNumber='${phoneNumber}'`;
        db.query(sql, (err, res) => {
          if (err) reject(err);
          resolve(_.omit(res[0]));
        });
      });
    });
  }
};

const schema = Joi.object({
  userId: Joi.number(),
  firstName: Joi.string().min(3).max(20).required(),
  lastName: Joi.string().min(3).max(20).required(),
  password: Joi.string()
    .pattern(new RegExp("^[a-zA-Z0-9]{3,30}$"))
    .message("please choose a proper password"),
  houseNo: Joi.string().min(3).max(20).required(),
  streetName: Joi.string().min(3).max(20).required(),
  pinCode: Joi.string().alphanum().min(3).max(20).required(),
  phoneNumber: Joi.string().alphanum().min(3).max(11).required(),
  email: Joi.string().email(),
});

// exports.schema = schema;
exports.validate = function (userObject) {
  return schema.validate(userObject);
};

// exports.generateAuthToken();
exports.generateAuthToken = function ({ phoneNumber }) {
  return new Promise((resolve, reject) => {
    getUser({ phoneNumber: phoneNumber }, (err, res) => {
      if (err) reject(err);
      jwt.sign(
        { phoneNumber: res.phoneNumber, userId: res.userId },
        process.env.serverPrivateKey,
        { expiresIn: "1h" },
        (err, token) => {
          if (err) reject(err);
          resolve(token);
        }
      );
    });
  });
};

exports.getOtp = function ({ phoneNumber }) {
  let randomNumber = Math.floor(Math.random() * 1000000);
  let otp = randomNumber.toString().padStart(6, "0");
  let sql = `INSERT INTO password_forgot(phoneNumber, otp, ts) values ('${phoneNumber}', '${otp}', NOW());`;
  return new Promise((resolve, reject) => {
    db.query(sql, (err, res) => {
      if (err) {
        if (err.code == "ER_DUP_ENTRY") {
          sql = `UPDATE password_forgot SET otp='${otp}', ts=NOW() WHERE phoneNumber='${phoneNumber}';`;
          db.query(sql, (err, res) => {
            if (err) reject(err);
            else resolve(otp);
          });
        } else reject(err);
      } else resolve(otp);
    });
  });
};

exports.verifyOtpAndChangePassword = function ({
  phoneNumber,
  otp,
  newHashedPassword,
}) {
  let sql = `DELETE FROM password_forgot WHERE ts < (NOW() - INTERVAL 5 MINUTE);`;
  return new Promise((resolve, reject) => {
    db.query(sql, (err, res) => {
      if (err) reject(err);
      let sql2 = `SELECT * FROM password_forgot WHERE phoneNumber='${phoneNumber}';`;
      db.query(sql2, (err, res) => {
        if (err) reject(err);
        try {
          if (res[0].otp == otp) {
            let sql3 = `UPDATE user SET hashedPassword = '${newHashedPassword}' WHERE phoneNumber='${phoneNumber}';`;
            db.query(sql3, (err, res) => {
              if (err) reject(err);
              db.query(
                `DELETE FROM password_forgot WHERE phoneNumber='${phoneNumber};`,
                (err, res) => {
                  resolve("Password changed");
                }
              );
            });
          } else {
            reject("invalid otp");
          }
        } catch (error) {
          reject(error);
        }
      });
    });
  });
};
