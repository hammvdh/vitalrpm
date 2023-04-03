import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/const/measurement_types.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/auth/auth_wrapper.dart';
import 'package:vitalrpm/screens/measurement/add_measurement_screen.dart';
import 'package:vitalrpm/screens/measurement/measurement_history_screen.dart';
import '../app_localizations.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class PatientHomeDashboard extends StatefulWidget {
  const PatientHomeDashboard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PatientHomeDashboardState createState() => _PatientHomeDashboardState();
}

class _PatientHomeDashboardState extends State<PatientHomeDashboard> {
  late AppLocalizations local;
  double screenWidth = 0;

  List<Map<String, dynamic>> measurementList = [];

  late UserProvider userProvider;
  @override
  initState() {
    userProvider = context.read<UserProvider>();
    initialize();
    super.initState();
  }

  initialize() async {
    measurementList = await getLastMeasurements();
    setState(() {});
  }

  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.assessment_outlined,
    Icons.person_outlined,
    Icons.settings_outlined,
  ];

  var bottomNavIndex = 1;

  getLastMeasurements() async {
    final db = FirebaseFirestore.instance;
    final measurementsRef = db.collection('measurements');
    final measurementTypes = MeasurementTypes.measurementTypes;

    final lastMeasurements = <Map<String, dynamic>>[];
    for (String type in measurementTypes) {
      final snapshot = await measurementsRef
          .where('type', isEqualTo: type)
          .orderBy('date', descending: true)
          .orderBy('time', descending: true)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final lastMeasurement = snapshot.docs.first.data();
        final date = DateTime.parse(lastMeasurement['date']);
        final time = DateTime.parse("2023-04-27 ${lastMeasurement['time']}:00");
        final timestamp =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        final diff = DateTime.now().difference(timestamp);
        final duration = Duration(seconds: diff.inSeconds);
        final lastReading = 'Last Reading - ${_getTimeAgo(duration)} ago';
        lastMeasurement['lastReading'] = lastReading;
        lastMeasurements.add(lastMeasurement);
      }
    }
    return lastMeasurements;
  }

  String _getTimeAgo(Duration duration) {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds} seconds';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} minutes';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} hours';
    } else if (duration.inDays < 30) {
      return '${duration.inDays} days';
    }
    return '${duration.inDays} days';
  }

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
          onPressed: (() => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddMeasurementScreen(),
                  ),
                ).then((value) => {initialize()})
              }),
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AuthenticationWrapper(),
                              ),
                            );
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
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: measurementList.length,
                            itemBuilder: (context, index) {
                              final item = measurementList[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          MeasurementHistoryScreen(
                                        type: item['type'],
                                      ),
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
                                              item['type'],
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                color: AppColors.darkBlue,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              item['lastReading'],
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                color: AppColors.textgrey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              item['type'] == "Blood Pressure"
                                                  ? '${item['reading']['systolic']}/${item['reading']['diastolic']} (${item['unit']})'
                                                  : '${item['reading']} (${item['unit']})',
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
                        const SizedBox(height: 50),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     Padding(
                        //       padding:
                        //           const EdgeInsets.symmetric(horizontal: 20),
                        //       child: Text(
                        //         'Pending Tasks',
                        //         style: GoogleFonts.inter(
                        //           fontSize: 21,
                        //           color: AppColors.textblack,
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //     ),
                        //     Padding(
                        //       padding:
                        //           const EdgeInsets.symmetric(horizontal: 20),
                        //       child: Text(
                        //         'VIEW ALL',
                        //         style: GoogleFonts.inter(
                        //           fontSize: 14,
                        //           color: AppColors.blue,
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 20),
                        // Container(
                        //   height: 100,
                        //   margin: const EdgeInsets.symmetric(horizontal: 15),
                        //   decoration: BoxDecoration(
                        //       color: const Color(0XFFD1E2EC),
                        //       borderRadius: BorderRadius.circular(10)),
                        // ),
                        // Container(
                        //   height: 100,
                        //   margin: const EdgeInsets.symmetric(
                        //       horizontal: 15, vertical: 10),
                        //   decoration: BoxDecoration(
                        //       color: const Color(0XFFD1E2EC),
                        //       borderRadius: BorderRadius.circular(10)),
                        // ),
                        // const SizedBox(height: 20),
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
