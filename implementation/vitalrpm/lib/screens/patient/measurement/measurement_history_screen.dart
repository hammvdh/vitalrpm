import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/const/color_const.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/patient/measurement/add_measurement_screen.dart';

class MeasurementHistoryScreen extends StatefulWidget {
  const MeasurementHistoryScreen({Key? key, required this.type})
      : super(key: key);

  final String type;

  @override
  State<MeasurementHistoryScreen> createState() =>
      _MeasurementHistoryScreenState();
}

class _MeasurementHistoryScreenState extends State<MeasurementHistoryScreen> {
  List<Map<String, dynamic>> measurementList = [];
  late UserProvider userProvider;
  @override
  void initState() {
    userProvider = context.read<UserProvider>();
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
    return 'Last Reading - None Taken';
  }

  getMeasurementsByType(String type) async {
    final db = FirebaseFirestore.instance;
    final measurementsRef = db.collection('measurements');
    final measurements = <Map<String, dynamic>>[];
    final snapshot = await measurementsRef
        .where('patientId', isEqualTo: userProvider.loginUser.documentId)
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
        onPressed: (() => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMeasurementScreen(
                    type: widget.type,
                  ),
                ),
              ).then((value) => {initialize()})
            }),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                            fontSize: 20,
                            color: AppColors.textblack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (measurementList.isEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Text("No Readings Found."),
                        )
                      ] else ...[
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
                                      color: Color(0xFFD4D3D4).withOpacity(0.8),
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
                                                  color:
                                                      const Color(0XFF565555),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Text(
                                                measurement['time'],
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0XFF565555),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox()
                                          // Icon(
                                          //   Icons.chevron_right,
                                          //   color: AppColors.darkBlue,
                                          //   size: 21,
                                          // )
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Divider(
                                        thickness: 1,
                                        color:
                                            Color(0xFFD4D3D4).withOpacity(0.8),
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
                                                        color:
                                                            AppColors.darkBlue,
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
                                                        color:
                                                            AppColors.darkBlue,
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
                                                        color:
                                                            AppColors.darkBlue,
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
                      ]
                    ]),
              ),
            ]),
      )),
    );
  }
}
