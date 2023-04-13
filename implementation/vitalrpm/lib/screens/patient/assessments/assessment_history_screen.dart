import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/patient/measurement/add_measurement_screen.dart';
import 'package:vitalrpm/widgets/bottom_navbar_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

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
  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    initialize();
    super.initState();
  }

  var lastReading = '';

  void initialize() async {
    assessmentList = await getAssessments();
    setState(() {});
  }

  getAssessments() async {
    final db = FirebaseFirestore.instance;
    final assessmentRef = db.collection('assessments');
    final assessments = <Map<String, dynamic>>[];
    final snapshot = await assessmentRef
        .where('patientId', isEqualTo: userProvider.loginUser.documentId)
        .orderBy('date', descending: true)
        .orderBy('time', descending: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      for (final assessment in snapshot.docs) {
        assessments.add(assessment.data());
      }
    }
    return assessments;
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                          "Assessment History",
                          style: GoogleFonts.inter(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Keep track of your health assessments",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textgrey,
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
                          'Assessments',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            color: AppColors.textblack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Text(
                              'Generate',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.textwhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (assessmentList.isEmpty) ...[
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
                        itemCount: assessmentList.length,
                        itemBuilder: (context, index) {
                          final measurement = assessmentList[index];
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
                                    color: Color(0xFFD4D3D4).withOpacity(0.8),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Status Assessment',
                                                style: GoogleFonts.inter(
                                                  fontSize: 17,
                                                  color: AppColors.darkBlue,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
                                      // TODO - WORK ON & ADD BELOW CODE WHEN VITAL RANGE DECIDED
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
