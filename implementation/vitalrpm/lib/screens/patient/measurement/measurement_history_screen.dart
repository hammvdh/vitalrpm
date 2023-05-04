import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/app_localizations.dart';
import 'package:vitalrpm/const/color_const.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/patient/measurement/add_measurement_screen.dart';

class MeasurementHistoryScreen extends StatefulWidget {
  const MeasurementHistoryScreen({Key? key, required this.type, this.patientId})
      : super(key: key);

  final String type;
  final String? patientId;

  @override
  State<MeasurementHistoryScreen> createState() =>
      _MeasurementHistoryScreenState();
}

class _MeasurementHistoryScreenState extends State<MeasurementHistoryScreen> {
  // List<Map<String, dynamic>> measurementList = [];
  late UserProvider userProvider;
  late bool isUserDoctor;
  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    isUserDoctor = userProvider.loginUser.userType.toLowerCase() == "doctor";
    initialize();
    super.initState();
  }

  var lastReading = '';

  initialize() async {
    setState(() {});
  }

  getLastReading(measurementList) {
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

  late AppLocalizations local;

  @override
  Widget build(BuildContext context) {
    local = AppLocalizations.of(context)!;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blue,
        onPressed: (() => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMeasurementScreen(
                    type: widget.type,
                    patientId: widget.patientId,
                  ),
                ),
              ).then((value) => {
                    setState(() {
                      initialize();
                    })
                  })
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
                          padding:
                              EdgeInsets.only(top: 15, left: 15, right: 15),
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
                            // const SizedBox(height: 5),
                            // Text(
                            //   lastReading,
                            //   style: GoogleFonts.inter(
                            //     fontSize: 16,
                            //     color: AppColors.textGrey,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
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
                          local.t('measurement_history')!,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Text(
                          widget.type,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('measurements')
                              .where('patientId',
                                  isEqualTo: isUserDoctor
                                      ? widget.patientId
                                      : userProvider.loginUser.documentId)
                              .where('type', isEqualTo: widget.type)
                              .orderBy('date', descending: true)
                              .orderBy('time', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null ||
                                snapshot.data!.docs.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Text(
                                  local.t("no_readings_found")!,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }
                            // Future.delayed(Duration.zero, () async {
                            //   setState(() {
                            //     lastReading =
                            //         getLastReading(snapshot.data!.docs);
                            //   });
                            // });

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot measurement =
                                      snapshot.data!.docs[index];
                                  final status = getVitalSignStatus(
                                      measurement['type'], measurement);
                                  return Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: const Color(0xFFD4D3D4)
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
                                                            measurement[
                                                                'date'])),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 16,
                                                      color: const Color(
                                                          0XFF565555),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Text(
                                                    measurement['time'],
                                                    style: GoogleFonts.inter(
                                                      fontSize: 16,
                                                      color: const Color(
                                                          0XFF565555),
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                            color: const Color(0xFFD4D3D4)
                                                .withOpacity(0.8),
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          local.t('systolic')!,
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 15,
                                                            color: const Color(
                                                                0XFF565555),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${measurement['reading']['systolic']} ${measurement['unit']}',
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 17,
                                                            color: AppColors
                                                                .darkBlue,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          local.t('diastolic')!,
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 15,
                                                            color: const Color(
                                                                0XFF565555),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${measurement['reading']['diastolic']} ${measurement['unit']}',
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 17,
                                                            color: AppColors
                                                                .darkBlue,
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          local.t('reading')!,
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 15,
                                                            color: const Color(
                                                                0XFF565555),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${measurement['reading']} ${measurement['unit']}',
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 17,
                                                            color: AppColors
                                                                .darkBlue,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: getStatusColor(status)
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      width: 0.8,
                                                      color: getStatusColor(
                                                          status)),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                child: Text(
                                                  local.t(status)!,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color:
                                                        getStatusColor(status),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                    ]),
              ),
            ]),
      )),
    );
  }

  String getVitalSignStatus(type, measurement) {
    switch (type) {
      case 'Body Temperature':
        double reading = double.parse(measurement['reading']);
        if (reading < 95 || reading > 100.4) {
          return 'status_critical';
        } else if (reading < 97.7 || reading > 99) {
          return 'status_warning';
        } else if (reading > 98.6) {
          return 'status_high';
        } else {
          return 'status_normal';
        }
      case 'Heart Rate':
        double reading = double.parse(measurement['reading']);
        if (reading < 50 || reading > 120) {
          return 'status_critical';
        } else if (reading < 60 || reading > 100) {
          return 'status_warning';
        } else if (reading > 80) {
          return 'status_high';
        } else {
          return 'status_normal';
        }
      case 'Respiratory Rate':
        double reading = double.parse(measurement['reading']);
        if (reading < 8 || reading > 30) {
          return 'status_critical';
        } else if (reading < 12 || reading > 20) {
          return 'status_warning';
        } else if (reading > 16) {
          return 'status_high';
        } else {
          return 'status_normal';
        }
      case 'Blood Oxygen Saturation':
        double reading = double.parse(measurement['reading']);
        if (reading < 90) {
          return 'status_critical';
        } else if (reading < 95) {
          return 'status_high';
        } else if (reading < 97) {
          return 'status_warning';
        } else {
          return 'status_normal';
        }
      case 'Blood Pressure':
        double systolic = double.parse(measurement['reading']['systolic']);
        double diastolic = double.parse(measurement['reading']['diastolic']);
        if (systolic < 90 ||
            diastolic < 60 ||
            systolic > 180 ||
            diastolic > 120) {
          return 'status_critical';
        } else if (systolic < 120 ||
            diastolic < 80 ||
            systolic > 130 ||
            diastolic > 85) {
          return 'status_warning';
        } else if (systolic > 140 || diastolic > 90) {
          return 'status_high';
        } else {
          return 'status_normal';
        }
      default:
        return 'Invalid type';
    }
  }

  getStatusColor(status) {
    if (status == "status_normal") {
      return AppColors.statusNormal;
    } else if (status == "status_warning") {
      return AppColors.statusWarning;
    } else if (status == "status_high") {
      return AppColors.statusHigh;
    } else if (status == "status_critical") {
      return AppColors.statusCritical;
    }
  }
}
