import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/auth/auth_wrapper.dart';

class DoctorHomeDashboard extends StatefulWidget {
  const DoctorHomeDashboard({super.key});

  @override
  State<DoctorHomeDashboard> createState() => _DoctorHomeDashboardState();
}

class _DoctorHomeDashboardState extends State<DoctorHomeDashboard> {
  late UserProvider userProvider;

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  userProvider.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthenticationWrapper(),
                    ),
                  );
                },
                child: Text(
                  'Hello ${userProvider.loginUser.firstName}',
                  style: GoogleFonts.inter(
                    fontSize: 27,
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                width: 250,
                child: Text(
                  'How are you feeling right now?',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
