import 'package:client/providers/auth_provider.dart';
import 'package:client/screens/auth_screen.dart';
import 'package:client/screens/user_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return authProvider.authStatus
        ? const UserHomeScreen()
        : const AuthScreen();
  }
}
