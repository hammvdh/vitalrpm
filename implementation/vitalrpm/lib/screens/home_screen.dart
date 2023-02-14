import 'package:flutter/material.dart';
import '../app_localizations.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  late AppLocalizations local;
  double screenWidth = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    local = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: SafeArea(
        child: Container(
          child: Center(child: const Text('Woah')),
        ),
      )),
    );
  }
}
