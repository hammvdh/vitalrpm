// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitalrpm/app_localizations.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/const/storage_keys.dart';
import 'package:vitalrpm/main.dart';
import 'package:vitalrpm/models/entity_model.dart';
import '../../../../providers/common_provider.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({Key? key, this.loginUser}) : super(key: key);

  final User? loginUser;

  @override
  ChangeLanguageScreenState createState() => ChangeLanguageScreenState();
}

class ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  Entity? _selectedLanguage;
  late AppLocalizations local;
  @override
  void initState() {
    _selectedLanguage = context.read<CommonProvider>().selectedLanguage;
    super.initState();
  }

  Future<void> changeLanguage(Entity languageItem) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Locale temp;
    if (languageItem.code == "si") {
      temp = const Locale("si", "LK");
      prefs.setString(StorageKeys.languageCode, "si");
    } else if (languageItem.code == "ta") {
      temp = const Locale("ta", "LK");
      prefs.setString(StorageKeys.languageCode, "ta");
    } else if (languageItem.code == "si") {
      temp = const Locale("ms", "MY");
      prefs.setString(StorageKeys.languageCode, "ms");
    } else if (languageItem.code == "ar") {
      temp = const Locale("ar", "KW");
      prefs.setString(StorageKeys.languageCode, "ar");
    } else if (languageItem.code == "ko") {
      temp = const Locale("ko", "KO");
      prefs.setString(StorageKeys.languageCode, "ko");
    } else if (languageItem.code == "fr") {
      temp = const Locale("fr", "FR");
      prefs.setString(StorageKeys.languageCode, "fr");
    } else if (languageItem.code == "hi") {
      temp = const Locale("hi", "IN");
      prefs.setString(StorageKeys.languageCode, "hi");
    } else if (languageItem.code == "id") {
      temp = const Locale("id", "ID");
      prefs.setString(StorageKeys.languageCode, "id");
    } else {
      temp = const Locale("en", "US");
      prefs.setString(StorageKeys.languageCode, "en");
    }
    context.read<CommonProvider>().setLanguage(_selectedLanguage!);
    MyApp.setLocale(context, temp);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    local = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  local.t("select_language")!,
                  style: GoogleFonts.inter(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  local.t("update_language")!,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children:
                    context.read<CommonProvider>().languageList.map((item) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLanguage = item;
                        changeLanguage(item);
                      });
                    },
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: _selectedLanguage == item
                              ? AppColors.blue
                              : AppColors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.description,
                              style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: _selectedLanguage == item
                                    ? AppColors.textWhite
                                    : AppColors.textBlack,
                              ),
                            ),
                            _selectedLanguage == item
                                ? Icon(
                                    Icons.check,
                                    color: AppColors.textWhite,
                                    size: 30,
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
