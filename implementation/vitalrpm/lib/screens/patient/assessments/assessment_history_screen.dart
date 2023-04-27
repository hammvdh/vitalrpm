// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/app_localizations.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/const/measurement_types.dart';
import 'package:vitalrpm/environment.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/patient/assessments/view_assessment_screen.dart';
import 'package:vitalrpm/screens/patient/measurement/add_measurement_screen.dart';
import 'package:vitalrpm/widgets/bottom_navbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:vitalrpm/widgets/utility.dart';

class AssessmentHistoryScreen extends StatefulWidget {
  const AssessmentHistoryScreen({Key? key}) : super(key: key);

  @override
  State<AssessmentHistoryScreen> createState() =>
      _AssessmentHistoryScreenState();
}

// List of Assessments
class _AssessmentHistoryScreenState extends State<AssessmentHistoryScreen> {
  List<Map<String, dynamic>> assessmentList = [];
  late UserProvider userProvider;
  late AppLocalizations local;
  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    super.initState();
  }

  var lastReading = '';

  getLastMeasurements() async {
    final db = FirebaseFirestore.instance;
    final measurementsRef = db.collection('measurements');
    final measurementTypes = MeasurementTypes.measurementTypes;
    final vitalsigns = [];
    final vitalDocs = [];
    for (String type in measurementTypes) {
      final snapshot = await measurementsRef
          .where('patientId', isEqualTo: userProvider.loginUser.documentId)
          .where('type', isEqualTo: type)
          .orderBy('date', descending: true)
          .orderBy('time', descending: true)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final measurement = snapshot.docs.first.data();
        final reading = measurement['reading'];
        type == "Blood Pressure"
            ? [
                vitalsigns.add(double.parse(reading['systolic'])),
                vitalsigns.add(double.parse(reading['diastolic']))
              ]
            : vitalsigns.add(double.parse(reading));
        vitalDocs.add(measurement['docId'].toString());
      }
    }
    return {"vitals": vitalsigns, "documents": vitalDocs};
  }

  void _fetchData(BuildContext context, [bool mounted = true]) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // The loading indicator
                  CircularProgressIndicator(
                    color: AppColors.blue,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  // Some text
                  Text(
                    local.t('generating_assessment')!,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      color: AppColors.textBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          );
        });

    final measurements = await getLastMeasurements();
    if (measurements['vitals'].length == 6 &&
        measurements['documents'].length == 5) {
      await generateAssessment(
          measurements['vitals'], measurements['documents']);
      await checkCanForecast();
    } else {
      // print("Cannot Generate");
      Future.delayed(Duration.zero, () async {
        Utility.error(context, local.t("cannot_generate_assessments"));
      });
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    local = AppLocalizations.of(context)!;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blue,
        onPressed: (() => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMeasurementScreen(),
                ),
              ).then((value) => {})
            }),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: const CustomBottomNavigationBar(currentPage: 1),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 155,
            color: AppColors.darkBlue,
            width: screenWidth,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          local.t("assessment_history")!,
                          style: GoogleFonts.inter(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          local.t("keep_track_of_assessments")!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textGrey,
                            fontWeight: FontWeight.w400,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          local.t('assessments')!,
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            _fetchData(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Text(
                                local.t('generate')!,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.textWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('assessments')
                          .where('patientId',
                              isEqualTo: userProvider.loginUser.documentId)
                          .orderBy('datetime', descending: true)
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
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
                        );
                      }),
                  const SizedBox(height: 50),
                ]),
          ),
        ]),
      )),
    );
  }

  checkCanForecast() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('assessments')
            .where(
              'patientId',
              isEqualTo: userProvider.loginUser.documentId,
            )
            .where('type', isEqualTo: "status")
            .get();

    final List vitalValues = [];
    final List assessmentDocs = [];

    for (final QueryDocumentSnapshot<Map<String, dynamic>> document
        in snapshot.docs) {
      final List vitalValue = document.get('vital_values');

      if (vitalValue.isNotEmpty) {
        vitalValues.add(vitalValue);
        assessmentDocs.add(document.get('docId'));
      }
    }

    if (vitalValues.length >= 6) {
      // Changed the condition to 6 instead of 7
      // print("Generating Forecast");
      final currentAssessment = vitalValues
          .last; // Get the vital signs of the current status assessment
      final currentDoc = assessmentDocs
          .last; // Get the document ID of the current status assessment

      // Wait for the current status assessment to be added to the Firebase collection before generating the forecast
      await FirebaseFirestore.instance
          .collection('assessments')
          .doc(currentDoc)
          .get()
          .then((doc) {
        if (doc.exists) {
          // print("Current assessment added to Firebase collection");
        } else {
          throw Exception(
              'Current assessment not added to Firebase collection');
        }
      });

      // Add the vital signs of the current status assessment to the list of assessments for the forecast
      vitalValues.add(currentAssessment);
      assessmentDocs.add(currentDoc);

      await generateForecast(vitalValues, assessmentDocs);
    }
  }

  generateForecast(assessments, docs) async {
    String url = '${Environment.host}forecast';
    // print(url);
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"vitals": assessments.toList()}),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      DocumentReference assessmentDocument;
      FirebaseFirestore.instance.runTransaction((transaction) async {
        try {
          assessmentDocument =
              FirebaseFirestore.instance.collection('assessments').doc();
          transaction.set(assessmentDocument, {
            'docId': assessmentDocument.id,
            'patientId': userProvider.loginUser.documentId,
            'status': json['status'],
            // 'acuity': json['predicted_acuity'],
            'forecasted_vitals': json['forecasted_vitals'],
            'assessments': docs,
            'datetime': DateTime.now(),
            'type': "forecast",
          });
        } catch (e) {
          if (kDebugMode) {
            // print("Generate Forecast - Error Occured - $e");
          }
        }
      });
    }
  }

  generateAssessment(vitals, docs) async {
    // print("Generating Assessment");
    String url = '${Environment.host}status';
    // print(url);

    if (vitals == null || docs == null) {
      // Return early if vital signs or related documents are null
      return;
    }

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({"vitals": vitals.toList()}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      DocumentReference assessmentDocument;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        // Use a batch write to ensure atomicity of the transaction
        WriteBatch batch = firestore.batch();

        assessmentDocument = firestore.collection('assessments').doc();
        batch.set(assessmentDocument, {
          'docId': assessmentDocument.id,
          'patientId': userProvider.loginUser.documentId,
          'status': json['status'],
          'acuity': json['predicted_acuity'],
          'vital_values': json['vitals'],
          'vital_docs': docs,
          'datetime': DateTime.now(),
          'type': "status",
        });

        await batch.commit();
      } catch (e) {
        if (kDebugMode) {
          // print("Generate Assessment - Error Occured - $e");
        }
        // Handle error
      }
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

  getMeasurementUnit(String type) {
    String unit = '';
    if (type == "Blood Pressure") {
      unit = "mmHg";
    } else if (type == "Body Temperature") {
      unit = "°F";
    } else if (type == "Heart Rate") {
      unit = "bpm";
    } else if (type == "Blood Oxygen Saturation") {
      unit = "%";
    } else if (type == "Respiratory Rate") {
      unit = "bpm";
    }
    return unit;
  }
}
