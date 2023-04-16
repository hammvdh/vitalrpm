import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/models/user_model.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/auth/auth_wrapper.dart';
import 'package:vitalrpm/screens/change_language_screen.dart';
import 'package:vitalrpm/widgets/bottom_navbar_widget.dart';
import 'package:vitalrpm/widgets/loading_overlay.dart';

import 'patient/measurement/add_measurement_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late UserProvider userProvider;
  late UserModel loginUser;

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    loginUser = userProvider.loginUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(currentPage: 2),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(color: AppColors.blue),
                height: 100,
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Settings',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${loginUser.firstName} ${loginUser.lastName}",
                      style: GoogleFonts.inter(
                        color: AppColors.darkBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        LoadingOverlay.of(context).show();
                        userProvider.logout();
                        LoadingOverlay.of(context).hide();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthenticationWrapper(),
                          ),
                        );
                      },
                      child: Text(
                        "Log Out",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeLanguageScreen(),
                    ),
                  );
                },
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 224, 231, 238),
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "User Profile Settings",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBlack,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.textBlack,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeLanguageScreen(),
                    ),
                  );
                },
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 237, 243, 248),
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Notification Settings",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBlack,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.textBlack,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeLanguageScreen(),
                    ),
                  );
                },
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 224, 231, 238),
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Language Settings",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBlack,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.textBlack,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeLanguageScreen(),
                    ),
                  );
                },
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 237, 243, 248),
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Help & Support",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBlack,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.textBlack,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeLanguageScreen(),
                    ),
                  );
                },
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 224, 231, 238),
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Privacy Policy & Terms of Service",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textBlack,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.textBlack,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
      )),
    );
  }
}
