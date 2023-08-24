import 'package:client/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("User logged in")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Logout"),
          onPressed: () => authProvider.logOut(),
        ),
      ),
    );
  }
}
