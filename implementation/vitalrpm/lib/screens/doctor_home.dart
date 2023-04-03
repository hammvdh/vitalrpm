import 'package:flutter/material.dart';

class DoctorHomeDashboard extends StatefulWidget {
  const DoctorHomeDashboard({super.key});

  @override
  State<DoctorHomeDashboard> createState() => _DoctorHomeDashboardState();
}

class _DoctorHomeDashboardState extends State<DoctorHomeDashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Doctor Home"),
    );
  }
}
