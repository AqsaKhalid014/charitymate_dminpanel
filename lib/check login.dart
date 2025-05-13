import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login page.dart';
import 'main.dart';

class CheckUserLoginStatus extends StatefulWidget {
  const CheckUserLoginStatus({super.key});

  @override
  State<CheckUserLoginStatus> createState() => _CheckUserLoginStatusState();
}

class _CheckUserLoginStatusState extends State<CheckUserLoginStatus> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() {
    final user = FirebaseAuth.instance.currentUser;
    Future.microtask(() {
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  DashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Temporary screen while checking auth status
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
