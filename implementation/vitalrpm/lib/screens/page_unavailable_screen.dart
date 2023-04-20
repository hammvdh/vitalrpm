import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/app_localizations.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/models/user_model.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/widgets/bottom_navbar_widget.dart';

class PageUnavailableScreen extends StatefulWidget {
  const PageUnavailableScreen({super.key});

  @override
  State<PageUnavailableScreen> createState() => _PageUnavailableScreenState();
}

class _PageUnavailableScreenState extends State<PageUnavailableScreen> {
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
                decoration: BoxDecoration(color: AppColors.textWhite),
                height: 70,
                width: screenWidth,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: AppColors.textBlack,
                          size: 29,
                        ),
                        Text(
                          local.t('back')!,
                          style: GoogleFonts.inter(
                            color: AppColors.textBlack,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                        local.t('page_not_found')!,
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
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    local.t('pnf_desc')!,
                    style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textGrey,
                        height: 1.5),
                    textAlign: TextAlign.left,
                  ))
            ]),
      )),
    );
  }
}
