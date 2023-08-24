const jwt = require("jsonwebtoken");

module.exports = function (req, res, next) {
  var authToken = req.headers.authtoken;
  console.log(authToken);
  if (!authToken) return res.status(401).send("no token provided");
  try {
    var decoded = jwt.verify(authToken, process.env.serverPrivateKey);
    req.decodedToken = decoded;
    next();
  } catch {
    return res.status(401).send("invalid auth token");
  }
};
