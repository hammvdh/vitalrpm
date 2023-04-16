import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/app_localizations.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/const/measurement_types.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:vitalrpm/widgets/loading_overlay.dart';

class ViewAssessmentsScreen extends StatefulWidget {
  const ViewAssessmentsScreen(
      {required this.assessment, Key? key, this.patientId})
      : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  final assessment;
  final String? patientId;

  @override
  State<ViewAssessmentsScreen> createState() => _ViewAssessmentsScreenState();
}

class _ViewAssessmentsScreenState extends State<ViewAssessmentsScreen> {
  late UserProvider userProvider;
  late AppLocalizations local;
  late bool isUserDoctor;

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    isUserDoctor = userProvider.loginUser.userType.toLowerCase() == "doctor";
    Future.delayed(const Duration(seconds: 0), () {
      initialize();
    });
    super.initState();
  }

  List<Map<String, dynamic>> vitals = [];
  List assessments = [];

  String assessmentDate = '';

  void initialize() async {
    final LoadingOverlay overlay = LoadingOverlay.of(context);

    if (widget.assessment['type'] == "status") {
      vitals = await overlay.during(getMeasurements());
    } else {
      assessments = await overlay.during(getAssessmentsForecasted());
    }

    Timestamp timestamp = widget.assessment['datetime'];
    DateTime dateTime = timestamp.toDate();
    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
    String formattedTime =
        "${timeOfDay.hour < 10 ? "0" : ""}${timeOfDay.hour}:${timeOfDay.minute < 10 ? "0" : ""}${timeOfDay.minute}";
    final datetime = '${DateFormat.yMMMd().format(dateTime)} at $formattedTime';

    setState(() {
      assessmentDate = datetime;
    });
  }

  Future<List<Map<String, dynamic>>> getMeasurements() async {
    final db = FirebaseFirestore.instance;
    final measurementsRef = db.collection('measurements');
    final assessment = widget.assessment;
    final lastMeasurements = <Map<String, dynamic>>[];
    for (int index = 0; index < assessment['vital_docs'].length; index++) {
      final snapshot = await measurementsRef
          .where('patientId',
              isEqualTo: isUserDoctor
                  ? widget.patientId
                  : userProvider.loginUser.documentId)
          .where('docId', isEqualTo: assessment['vital_docs'][index])
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
        final readingDate = DateFormat.yMMMd().format(timestamp);
        TimeOfDay timeOfDay = TimeOfDay.fromDateTime(timestamp);
        String formattedTime =
            "${timeOfDay.hour < 10 ? "0" : ""}${timeOfDay.hour}:${timeOfDay.minute < 10 ? "0" : ""}${timeOfDay.minute}";

        final datetime = 'Measured on - $readingDate at $formattedTime';

        lastMeasurement['readingTime'] = datetime;
        lastMeasurements.add(lastMeasurement);
      } else {
        lastMeasurements.add({
          'docId': assessment['vital_docs'][index],
          'lastReading': 'Last Reading - N/A'
        });
      }
    }
    return lastMeasurements;
  }

  @override
  Widget build(BuildContext context) {
    // Top Bar
    // Assessment Details
    // List of vital signs used
    local = AppLocalizations.of(context)!;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 235,
              color: AppColors.darkBlue,
              width: screenWidth,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.assessment['type'] == "status"
                                ? local.t("status_assessment")!
                                : local.t("forecast_assessment")!,
                            style: GoogleFonts.inter(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.assessment['type'] == "status"
                                ? local.t('health_status_assessment')!
                                : local.t("health_status_forecast")!,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppColors.textGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: screenWidth / 1.1,
                      height: 70,
                      decoration: BoxDecoration(
                        color: getStatusColor(widget.assessment['status']),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.assessment['type'] == "status"
                                  ? local.t("health_status")!
                                  : local.t("forecasted_status")!,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              local.t(widget.assessment['status'])!,
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                color: AppColors.textWhite,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 215),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
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
                        local.t('assessment_date')!,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          color: AppColors.textBlack,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 20),
                      child: Text(
                        assessmentDate.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (widget.assessment['type'] == "status") ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          local.t('measurements')!,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: vitals.length,
                          itemBuilder: (context, index) {
                            final item = vitals[index];
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
                                        offset: Offset(0, 30),
                                        blurRadius: 45)
                                  ]),
                              height: 105,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item['type'],
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            color: AppColors.darkBlue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      item['readingTime'],
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: AppColors.textGrey,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
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
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          local.t('forecasted_vital_signs')!,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: MeasurementTypes.measurementTypes
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final measurementType = entry.value;
                          String value;
                          if (measurementType == 'Blood Pressure') {
                            final lastTwoValues = widget
                                .assessment['forecasted_vitals']
                                .sublist(widget.assessment['forecasted_vitals']
                                        .length -
                                    2);
                            value = '${lastTwoValues[0]}/${lastTwoValues[1]}';
                          } else {
                            value = widget.assessment['forecasted_vitals']
                                    [index]
                                .toString();
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Row(
                              children: [
                                Text(
                                  '$measurementType: ',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: AppColors.textGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  value,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                          // return Text('$measurementType: $value');
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          local.t('status_assessments_used')!,
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: assessments.length,
                          itemBuilder: (context, index) {
                            final assessment = assessments[index];
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
                                    builder: (context) => ViewAssessmentsScreen(
                                      assessment: assessment,
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
                                              color: const Color(0XFF565555),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    local.t("report_type")!,
                                                    style: GoogleFonts.inter(
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
                                                    style: GoogleFonts.inter(
                                                      fontSize: 16,
                                                      color: AppColors.darkBlue,
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
                                                      assessment['status'])),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            child: Text(
                                              local.t(assessment['status'])!,
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
                      )
                    ],
                    const SizedBox(height: 50),
                  ]),
            ),
          ],
        ),
      )),
    );
  }

  Color getStatusColor(status) {
    if (status == "status_normal") {
      return AppColors.statusNormal;
    } else if (status == "status_warning") {
      return AppColors.statusWarning;
    } else if (status == "status_high") {
      return AppColors.statusHigh;
    } else if (status == "status_critical") {
      return AppColors.statusCritical;
    }
    return AppColors.blue;
  }

  Future<List<Map<String, dynamic>>> getAssessmentsForecasted() async {
    final db = FirebaseFirestore.instance;
    final measurementsRef = db.collection('assessments');
    final assessment = widget.assessment;
    final List<Map<String, dynamic>> forecastedAssessments = [];
    for (int index = 0; index < assessment['assessments'].length; index++) {
      final snapshot = await measurementsRef
          .where('patientId',
              isEqualTo: isUserDoctor
                  ? widget.patientId
                  : userProvider.loginUser.documentId)
          .where('docId', isEqualTo: assessment['assessments'][index])
          .orderBy('datetime', descending: true)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final forecastedAssessment = snapshot.docs.first.data();
        forecastedAssessments.add(forecastedAssessment);
      }
    }
    forecastedAssessments
        .sort((a, b) => b['datetime'].compareTo(a['datetime']));
    return forecastedAssessments;
  }
}
