import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/app_localizations.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/const/measurement_types.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/patient/assessments/view_assessment_screen.dart';
import 'package:vitalrpm/screens/patient/measurement/measurement_history_screen.dart';
import 'package:vitalrpm/widgets/bottom_navbar_widget.dart';
import 'package:vitalrpm/widgets/loading_overlay.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ViewPatientDetails extends StatefulWidget {
  const ViewPatientDetails({required this.patient, super.key});

  final DocumentSnapshot<Object?> patient;

  @override
  State<ViewPatientDetails> createState() => _ViewPatientDetailsState();
}

class _ViewPatientDetailsState extends State<ViewPatientDetails> {
  Future<void> _removeDoctorField(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('usermaster')
          .doc(userId)
          .update({'doctor': ''});
    } catch (e) {
      // print(e.toString());
    }
  }

  late AppLocalizations local;
  double screenWidth = 0;
  late UserProvider userProvider;
  List<Map<String, dynamic>> measurementList = [];

  @override
  initState() {
    userProvider = context.read<UserProvider>();
    Future.delayed(const Duration(seconds: 0), () {
      initialize();
    });
    super.initState();
  }

  initialize() async {
    final LoadingOverlay overlay = LoadingOverlay.of(context);
    overlay.show();
    measurementList = await getLastMeasurements();
    setState(() {});
    overlay.hide();
  }

  getLastMeasurements() async {
    final db = FirebaseFirestore.instance;
    final measurementsRef = db.collection('measurements');
    final measurementTypes = MeasurementTypes.measurementTypes;

    final lastMeasurements = <Map<String, dynamic>>[];
    for (String type in measurementTypes) {
      final snapshot = await measurementsRef
          .where('patientId', isEqualTo: widget.patient.id)
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
      } else {
        lastMeasurements
            .add({'type': type, 'lastReading': 'Last Reading - N/A'});
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
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(currentPage: 5),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: AppColors.blue),
              height: 100,
              width: screenWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          local.t("patient_name")!,
                          style: GoogleFonts.inter(
                            color: AppColors.darkBlue.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.patient['firstName'] +
                              " " +
                              widget.patient['lastName'],
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        // Update the user's doctor field
                        await _removeDoctorField(widget.patient['docId']);
                        // Refresh the user list
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          local.t("remove")!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w600,
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            local.t('measurements')!,
                            style: GoogleFonts.inter(
                              fontSize: 21,
                              color: AppColors.textBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (measurementList.isEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          local.t("loading_measurements")!,
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: measurementList.length,
                        itemBuilder: (context, index) {
                          final type = MeasurementTypes.measurementTypes[index];
                          final item = measurementList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      MeasurementHistoryScreen(
                                    type: type.toString(),
                                    patientId: widget.patient['docId'],
                                  ),
                                ),
                              ).then((value) => {initialize()});
                            },
                            child: Container(
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
                                        offset: Offset(0, 30),
                                        blurRadius: 45)
                                  ]),
                              height: 105,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
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
                                            color: AppColors.textGrey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          item['reading'] != null
                                              ? (item['type'] ==
                                                      "Blood Pressure"
                                                  ? '${item['reading']['systolic']}/${item['reading']['diastolic']} (${item['unit']})'
                                                  : '${item['reading']} (${item['unit']})')
                                              : "N/A",
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
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            local.t('assessments')!,
                            style: GoogleFonts.inter(
                              fontSize: 21,
                              color: AppColors.textBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('assessments')
                            .where('patientId', isEqualTo: widget.patient.id)
                            .orderBy('datetime', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null ||
                              snapshot.data!.docs.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Text(
                                local.t("no_assessments_found")!,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot assessment =
                                    snapshot.data!.docs[index];
                                Timestamp timestamp = assessment['datetime'];
                                DateTime dateTime = timestamp.toDate();
                                TimeOfDay timeOfDay =
                                    TimeOfDay.fromDateTime(dateTime);
                                String formattedTime =
                                    "${timeOfDay.hour < 10 ? "0" : ""}${timeOfDay.hour}:${timeOfDay.minute < 10 ? "0" : ""}${timeOfDay.minute}";

                                final assessmentDate =
                                    '${DateFormat.yMMMd().format(dateTime)} at $formattedTime';
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewAssessmentsScreen(
                                          assessment: assessment,
                                          patientId: widget.patient.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
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
                                    height: 110,
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
                                              Text(
                                                assessmentDate,
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0XFF565555),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(),
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
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        local.t("report_type")!,
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 14,
                                                          color: AppColors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        assessment['type'] ==
                                                                "status"
                                                            ? local.t(
                                                                'status_assessment')!
                                                            : local.t(
                                                                "predicted_status")!,
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontSize: 16,
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
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: getStatusColor(
                                                          assessment['status'])
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                      width: 0.8,
                                                      color: getStatusColor(
                                                          assessment[
                                                              'status'])),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                child: Text(
                                                  local
                                                      .t(assessment['status'])!,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 17,
                                                    color: getStatusColor(
                                                        assessment['status']),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                    const SizedBox(height: 50),
                  ]),
            )
          ],
        ),
      )),
    );
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
