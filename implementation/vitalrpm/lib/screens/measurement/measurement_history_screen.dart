import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalrpm/const/color_const.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({Key? key}) : super(key: key);

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.assessment_outlined,
    Icons.person_outlined,
    Icons.settings_outlined,
  ];

  var bottomNavIndex = 1;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 165,
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
                              'Blood Pressure',
                              style: GoogleFonts.inter(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
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
                            fontSize: 21,
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
                          itemCount: 5,
                          itemBuilder: (context, index) {
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
                              height: 105,
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
                                              'Jan 11, 2022',
                                              style: GoogleFonts.inter(
                                                fontSize: 15,
                                                color: const Color(0XFF565555),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              '06.31 pm',
                                              style: GoogleFonts.inter(
                                                fontSize: 15,
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
                                      height: 1,
                                      color: AppColors.grey,
                                    ),
                                    const SizedBox(height: 10),
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
                                                  'Systolic',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 15,
                                                    color:
                                                        const Color(0XFF565555),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  '120 mmgH',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 17,
                                                    color: AppColors.darkBlue,
                                                    fontWeight: FontWeight.w600,
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
                                                    color:
                                                        const Color(0XFF565555),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  '80 mmgH',
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
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                    ]),
              ),
            ]),
      )),
    );
  }
}
