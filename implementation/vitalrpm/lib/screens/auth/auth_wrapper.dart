// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/auth/login_screen.dart';
import 'package:vitalrpm/screens/doctor/doctor_home.dart';
import 'package:vitalrpm/screens/patient/patient_home.dart';

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  late final firebaseUser;

  late UserProvider userProvider;

  @override
  void initState() {
    firebaseUser = FirebaseAuth.instance.currentUser;
    userProvider = context.read<UserProvider>();
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    if (mounted) {
      Future.delayed(Duration.zero, () async {
        // return goToHome();
        if (firebaseUser != null) {
          await userProvider.loadUser(firebaseUser.uid);
          String type = userProvider.loginUser.userType.toLowerCase();
          return goToHome(type);
        } else {
          return goToLogin();
        }
      });
    }
  }

  goToHome(String type) {
    // print(type);
    if (type == "doctor") {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DoctorHomeDashboard(),
        ),
      );
    } else {
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PatientHomeDashboard(),
        ),
      );
    }
  }

  goToLogin() {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.darkBlue,
          backgroundColor: AppColors.blue,
        ),
      ),
    );
  }
}
