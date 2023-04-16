import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/app_localizations.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/models/user_model.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/auth/auth_wrapper.dart';
import 'package:vitalrpm/screens/change_language_screen.dart';
import 'package:vitalrpm/screens/page_unavailable_screen.dart';
import 'package:vitalrpm/widgets/bottom_navbar_widget.dart';
import 'package:vitalrpm/widgets/loading_overlay.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late UserProvider userProvider;
  late UserModel loginUser;
  late AppLocalizations local;

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    loginUser = userProvider.loginUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    local = AppLocalizations.of(context)!;
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
                        local.t('user_settings')!,
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
                          CupertinoPageRoute(
                            builder: (context) => const AuthenticationWrapper(),
                          ),
                        );
                      },
                      child: Text(
                        local.t("log_out")!,
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
                    CupertinoPageRoute(
                      builder: (context) => const PageUnavailableScreen(),
                    ),
                  );
                },
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 224, 231, 238),
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          local.t("user_profile_settings")!,
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
                    CupertinoPageRoute(
                      builder: (context) => const PageUnavailableScreen(),
                    ),
                  );
                },
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 237, 243, 248),
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          local.t("notification_settings")!,
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
                    CupertinoPageRoute(
                      builder: (context) => const ChangeLanguageScreen(),
                    ),
                  );
                },
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 224, 231, 238),
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          local.t("language_settings")!,
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
                    CupertinoPageRoute(
                      builder: (context) => const PageUnavailableScreen(),
                    ),
                  );
                },
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 237, 243, 248),
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          local.t("help_and_support")!,
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
                    CupertinoPageRoute(
                      builder: (context) => const PageUnavailableScreen(),
                    ),
                  );
                },
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 15),
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 224, 231, 238),
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          local.t("terms_of_service")!,
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
