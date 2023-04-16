// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/const/storage_keys.dart';
import 'package:vitalrpm/main.dart';
import 'package:vitalrpm/models/entity_model.dart';
import '../../../../providers/common_provider.dart';

class ChangeLanguageScreen extends StatefulWidget {
  ChangeLanguageScreen({this.loginUser});

  final User? loginUser;

  @override
  ChangeLanguageScreenState createState() => ChangeLanguageScreenState();
}

class ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  Entity? _selectedLanguage;

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
      prefs.setString(StorageKeys.LanguageCode, "ar");
    } else {
      temp = const Locale("en", "US");
      prefs.setString(StorageKeys.LanguageCode, "en");
    }
    context.read<CommonProvider>().setLanguage(_selectedLanguage!);
    MyApp.setLocale(context, temp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20),
          icon: const Icon(Icons.arrow_back),
          iconSize: 37,
          color: Colors.black87,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "change_language",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "select_language",
                  style: GoogleFonts.inter(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
              const SizedBox(height: 30),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
