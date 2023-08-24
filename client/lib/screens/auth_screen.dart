import 'package:client/providers/auth_provider.dart';
import 'package:client/screens/login_screen.dart';
import 'package:client/screens/otp_and_newpassword_screen.dart';
import 'package:client/screens/phone_number_screen.dart';
import 'package:client/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _AuthPageState {
  login,
  register,
  phoneNumber,
  passwordChange,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  _AuthPageState state = _AuthPageState.login;

  Widget pageBuilder(authProvider) {
    if (state == _AuthPageState.login) {
      return LoginScreen(
          registerClicked: () {
            setState(() {
              state = _AuthPageState.register;
            });
          },
          forgotPasswordClicked: () {
            setState(() {
              state = _AuthPageState.phoneNumber;
            });
          },
          authProvider: authProvider);
    } else if (state == _AuthPageState.register) {
      return RegisterScreen(
          loginClicked: () {
            setState(() {
              state = _AuthPageState.login;
            });
          },
          authProvider: authProvider);
    } else if (state == _AuthPageState.phoneNumber) {
      return PhoneNumberScreen(
          clickNextButtonFunction: () {
            setState(() {
              state = _AuthPageState.passwordChange;
            });
          },
          clickLoginButtonFunction: () {
            setState(() {
              state = _AuthPageState.login;
            });
          },
          authProvider: authProvider);
    } else {
      return OtpAndNewPasswordScreen(
          clickLoginButtonFunction: () {
            setState(() {
              state = _AuthPageState.login;
            });
          },
          authProvider: authProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return pageBuilder(authProvider);
  }
}
