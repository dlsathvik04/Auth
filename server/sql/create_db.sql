CREATE DATABASE IF NOT EXISTS test;
use test;
CREATE TABLE IF NOT EXISTS user(
    userId INT(5) AUTO_INCREMENT UNIQUE,
    firstName VARCHAR(20) NOT NULL,
    lastName VARCHAR(20) NOT NULL,
    hashedPassword VARCHAR(256) NOT NULL,
    houseNo VARCHAR(20) NOT NULL,
    streetName VARCHAR(20) NOT NULL,
    pinCode VARCHAR(10) NOT NULL,
    phoneNumber VARCHAR(11) NOT NULL UNIQUE,
    email VARCHAR(32) NOT NULL UNIQUE
);
CREATE TABLE IF NOT EXISTS password_forgot(
    requestId INT(5) AUTO_INCREMENT UNIQUE,
    phoneNumber VARCHAR(11) NOT NULL UNIQUE,
    otp INT(6) NOT NULL,
    ts DATETIME NOT NULL
);
-- INSERT INTO user(
--         firstName,
--         lastName,
--         hashedPassword,
--         houseNo,
--         streetName,
--         pinCode,
--         phoneNumber,
--         email
--     )
-- VALUES (
--         'user firstname',
--         'lastname',
--         '0123456',
--         '40',
--         'road',
--         '12345',
--         '1234567890',
--         'user@gmail.com'
--     );