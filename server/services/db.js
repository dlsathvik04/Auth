const mysql = require("mysql");

let db = mysql.createConnection({
  database: process.env.dbName,
  host: process.env.dbHost,
  user: process.env.dbUser,
  password: process.env.dbPassword,
});

db.connect();
module.exports = db;
