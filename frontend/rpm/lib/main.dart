import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rpm/app_localizations.dart';
import 'package:rpm/const/color_const.dart';
import 'package:rpm/splash_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(locale);
  }

  static Locale? getLocale(BuildContext context) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    return state.getLocale();
  }
}

class _MyAppState extends State<MyApp> {
  static StreamSubscription<User?>? user;

  Locale? _locale;

  @override
  void initState() {
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        if (kDebugMode) {
          print('User is currently signed out!');
        }
      } else {
        if (kDebugMode) {
          print('User is signed in!');
        }
      }
    });
    user?.cancel();
    super.initState();
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  Locale? getLocale() {
    return _locale;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: const [],
      child: MaterialApp(
        title: 'VitalHealth - Remote Patient Monitoring',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.bgBlue,
          scaffoldBackgroundColor: Colors.white,
        ),
        locale: _locale,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('si', 'LK'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale!.languageCode &&
                locale.countryCode == deviceLocale.countryCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
        home: const SplashScreen(),
      ),
    );
  }
}
