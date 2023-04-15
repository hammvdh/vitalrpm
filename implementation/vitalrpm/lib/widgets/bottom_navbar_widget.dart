import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/models/user_model.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/doctor/doctor_home.dart';
import 'package:vitalrpm/screens/doctor/doctor_settings_screen.dart';
import 'package:vitalrpm/screens/patient/assessments/assessment_history_screen.dart';
import 'package:vitalrpm/screens/patient/measurement/add_measurement_screen.dart';
import 'package:vitalrpm/screens/patient/patient_home.dart';
import 'package:vitalrpm/screens/patient/patient_settings_screen.dart';
import 'package:vitalrpm/screens/patient_details_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key, this.currentPage})
      : super(key: key);

  final int? currentPage;

  @override
  CustomBottomNavigationBarState createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late UserProvider userProvider;

  late UserModel loginUser;

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    loginUser = userProvider.loginUser;
    loadData();
    super.initState();
  }

  late final List<IconData> iconList;

  loadData() {
    if (loginUser.userType.trim().toLowerCase() == 'doctor') {
      iconList = <IconData>[
        Icons.home_outlined,
        Icons.assessment_outlined,
        Icons.chat_bubble_outline,
        Icons.settings_outlined,
      ];
    } else {
      iconList = <IconData>[
        Icons.home_outlined,
        Icons.assessment_outlined,
        Icons.person_outlined,
        Icons.settings_outlined,
      ];
    }
  }

  // Navigation method for doctor user
  void _navigateDoctor(int index) {
    if (widget.currentPage == index) {
      return;
    } // don't navigate if already on the selected item
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DoctorHomeDashboard(),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AssessmentHistoryScreen(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AssessmentHistoryScreen(),
          ),
        );
        //  Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => const PatientChatScreen(),
        //   ),
        // );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DoctorSettingsScreen(),
          ),
        );
        break;
    }
  }

  // Navigation method for doctor user
  void _navigatePatient(int index) {
    if (widget.currentPage == index) {
      return;
    } // don't navigate if already on the selected item
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PatientHomeDashboard(),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AssessmentHistoryScreen(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PatientProfileScreen(),
          ),
        );
        //  Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => const PatientChatScreen(),
        //   ),
        // );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PatientSettingsScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: AnimatedBottomNavigationBar(
        elevation: 10,
        backgroundColor: Colors.white,
        icons: iconList,
        iconSize: 30,
        activeIndex: widget.currentPage!,
        activeColor: AppColors.darkBlue,
        inactiveColor: AppColors.grey,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) {
          setState(() {
            if (widget.currentPage != '') {
              if (loginUser.userType.trim().toLowerCase() == 'doctor') {
                _navigateDoctor(index);
              } else {
                _navigatePatient(index);
              }
            }
          });
        },
        //other params
      ),
    );
  }
}

class CustomFloatingActionButton extends StatefulWidget {
  const CustomFloatingActionButton(
      {Key? key, bool? isHome, Function()? onClicked})
      : super(key: key);

  @override
  State<CustomFloatingActionButton> createState() =>
      _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState
    extends State<CustomFloatingActionButton> {
  bool isHome = false;

  void Function()? onClicked;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.blue,
      onPressed: (() => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddMeasurementScreen(),
              ),
            ).then((value) => {onClicked})
          }),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
