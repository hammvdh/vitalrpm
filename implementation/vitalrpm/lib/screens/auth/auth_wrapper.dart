import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/auth/login_screen.dart';
import 'package:vitalrpm/screens/home_dashboard.dart';

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  // ignore: prefer_typing_uninitialized_variables
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
    if (firebaseUser != null) {
      // userProvider.initialize(firebaseUser.uid, context);
      return goToHome();
    } else {
      return goToLogin();
    }
  }

  Future goToHome() {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeDashboard(),
      ),
    );
  }

  Future goToLogin() {
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
