import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:intl/intl.dart';

class MeasurementHistoryScreen extends StatefulWidget {
  const MeasurementHistoryScreen({Key? key, required this.type})
      : super(key: key);

  final String type;

  @override
  State<MeasurementHistoryScreen> createState() =>
      _MeasurementHistoryScreenState();
}

class _MeasurementHistoryScreenState extends State<MeasurementHistoryScreen> {
  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.assessment_outlined,
    Icons.person_outlined,
    Icons.settings_outlined,
  ];

  var bottomNavIndex = 1;

  List<Map<String, dynamic>> measurementList = [];

  @override
  void initState() {
    initialize();
    super.initState();
  }

  var lastReading = '';

  void initialize() async {
    measurementList = await getMeasurementsByType(widget.type);
    lastReading = getLastReading();
    setState(() {});
  }

  getLastReading() {
    if (measurementList.isNotEmpty) {
      final measurement = measurementList.first;
      final date = DateTime.parse(measurement['date']);
      final time = DateTime.parse("2023-04-27 ${measurement['time']}:00");
      final timestamp =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      final diff = DateTime.now().difference(timestamp);
      final duration = Duration(seconds: diff.inSeconds);
      final lastReading = 'Last Reading - ${_getTimeAgo(duration)} ago';
      return lastReading;
    }
    return 'N/A';
  }

  getMeasurementsByType(String type) async {
    final db = FirebaseFirestore.instance;
    final measurementsRef = db.collection('measurements');
    final measurements = <Map<String, dynamic>>[];
    final snapshot = await measurementsRef
        .where('type', isEqualTo: type)
        .orderBy('date', descending: true)
        .orderBy('time', descending: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      for (final measurement in snapshot.docs) {
        measurements.add(measurement.data());
      }
    }
    return measurements;
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
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true, // very important as noted
      backgroundColor: Colors.white,
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
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 185,
                color: AppColors.darkBlue,
                width: screenWidth,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(top: 15, left: 15),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.type,
                              style: GoogleFonts.inter(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              lastReading,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: AppColors.textgrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              ),
              Container(
                width: screenWidth,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Measurement History',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: AppColors.textblack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: measurementList.length,
                          itemBuilder: (context, index) {
                            final measurement = measurementList[index];
                            return Container(
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
                                        offset: Offset(0, 20),
                                        blurRadius: 10)
                                  ]),
                              height: 115,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat.yMMMd().format(
                                                  DateTime.parse(
                                                      measurement['date'])),
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                color: const Color(0XFF565555),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              measurement['time'],
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                color: const Color(0XFF565555),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: AppColors.darkBlue,
                                          size: 21,
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Divider(
                                      thickness: 1,
                                      color: AppColors.grey,
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (widget.type ==
                                            "Blood Pressure") ...[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Systolic',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      color: const Color(
                                                          0XFF565555),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${measurement['reading']['systolic']} ${measurement['unit']}',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 17,
                                                      color: AppColors.darkBlue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Diastolic',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      color: const Color(
                                                          0XFF565555),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${measurement['reading']['diastolic']} ${measurement['unit']}',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 17,
                                                      color: AppColors.darkBlue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ] else ...[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Reading',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      color: const Color(
                                                          0XFF565555),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${measurement['reading']} ${measurement['unit']}',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 17,
                                                      color: AppColors.darkBlue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                        // TODO - WORK ON & ADD BELOW CODE WHEN VITAL RANGE DECIDED
                                        Container(
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: AppColors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            'Normal'.toUpperCase(),
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              color: AppColors.textwhite,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 260),
                    ]),
              ),
            ]),
      )),
    );
  }
}
