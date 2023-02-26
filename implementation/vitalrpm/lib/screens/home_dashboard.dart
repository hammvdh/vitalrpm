import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/measurement/measurement_history_screen.dart';
import '../app_localizations.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  late AppLocalizations local;
  double screenWidth = 0;

  List measurementList = List<String>.generate(3, (i) => 'Measurement $i');

  late UserProvider userProvider;
  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    super.initState();
  }

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.assessment_outlined,
    Icons.person_outlined,
    Icons.settings_outlined,
  ];

  var bottomNavIndex = 1;

  @override
  Widget build(BuildContext context) {
    local = AppLocalizations.of(context)!;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        extendBody: true, // very important as noted
        backgroundColor: AppColors.darkBlue,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.blue,
          onPressed: (() => {}),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          color: Colors.white,
          child: AnimatedBottomNavigationBar(
            elevation: 10,
            backgroundColor: Colors.white,
            icons: iconList,
            iconSize: 30,
            activeIndex: bottomNavIndex,
            activeColor: AppColors.darkBlue,
            inactiveColor: AppColors.grey,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,
            onTap: (index) => setState(() => bottomNavIndex = index),
            //other params
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 22),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello Hammadh',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: AppColors.darkBlue,
                                fontWeight: FontWeight.w600,
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
                        GestureDetector(
                          onTap: () {
                            userProvider.logout();
                          },
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: AppColors.darkBlue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image(
                                width: MediaQuery.of(context).size.width,
                                image: const AssetImage(
                                    'assets/images/account.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: screenWidth,
                  margin: const EdgeInsets.only(top: 120),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Measurements',
                                style: GoogleFonts.inter(
                                  fontSize: 21,
                                  color: AppColors.textblack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'VIEW ALL',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: measurementList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const MeasurementScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: const Color(0xFFF0EFF2)
                                            .withOpacity(0.8),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color(0xFFDEE2E5),
                                            offset: Offset(0, 30),
                                            blurRadius: 45)
                                      ]),
                                  height: 105,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Blood Pressure',
                                              style: GoogleFonts.inter(
                                                fontSize: 15,
                                                color: AppColors.darkBlue,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              'Last Reading - 5 hours ago',
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                color: AppColors.textgrey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              '120/80 (mmgH)',
                                              style: GoogleFonts.inter(
                                                fontSize: 18,
                                                color: AppColors.blue,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 11,
                                              ),
                                              child: Icon(
                                                Icons.chevron_right,
                                                color: AppColors.darkBlue,
                                                size: 25,
                                              ),
                                            ),
                                            Container()
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Pending Tasks',
                                style: GoogleFonts.inter(
                                  fontSize: 21,
                                  color: AppColors.textblack,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'VIEW ALL',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: const Color(0XFFD1E2EC),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              color: const Color(0XFFD1E2EC),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(height: 20),
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
