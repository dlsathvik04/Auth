# Basic Login and Registration with Forgot password service

## Resgister end point:

POST http://\<Host name\>:\<portNumber>/users/register

JSON Body template:

```
{
    "firstName" : "user first name",
    "lastName" : "user last name",
    "password" : "password for the account",
    "houseNo" : "user house number",
    "streetName" : "user streetName",
    "pincode" : "pincode",
    "phoneNumber": "phone number",
    "email": "user@email.com"
}
```

## Login end point:

POST http://\<Host name\>:\<portNumber>/users/login

JSON Body template:

```
{
    "phoneNumber": "1234567890",
    "password" : "password"
}
```

If sucessful you will get an auth token which expires in 1 hour.

## Forgot Password Endpoint:

### STEP 1 : sends the otp to the email

POST http://\<Host name\>:\<portNumber>/users/forgotPassword

JSON Body template :

```
{
    "phoneNumber" : "user phone number"
}
```

### STEP 2 : change password using OTP

POST http://\<Host name\>:\<portNumber>/users/changePassword

JSON Body template :

```
{
    "phoneNumber" : "1234567890",
    "otp": "012345",
    "newPassword" : "newPassword"
}
```

# Server Configuration

follow the following configs to set all the required environmet variables to run the server

## Database Coniguration

set the following envirnment variables for database configuration in the running terminal:

```
SET dbName=<database name>
SET dbHost=<database host eg: localhost>
SET dbUser=<database user eg: root>
SET dbPassword=<database password>
```

## Email OTP Service Configuration

```
SET serverMail=<server mail address to send otps>
SET serverMailPassword=<your mail server password>
```

## JSON Web Token Coniguration

the following environment variable is used to sign and verify the JWT's so keep it same for various runs if you are persisting the database entries.

```
SET serverPrivateKey=<your server private key>
```

# Migration to Phone Number OTP

STEP 1: Implemt the service to send the OTP through phonenumber in the `./services` foleder

STEP 2: Change the line number 69 in the `routes/users.js`
