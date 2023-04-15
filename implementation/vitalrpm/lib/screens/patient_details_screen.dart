import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/widgets/bottom_navbar_widget.dart';

import 'patient/measurement/add_measurement_screen.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: const CustomBottomNavigationBar(currentPage: 2),
      appBar: AppBar(
        title: Text(
          'Patient Profile',
          style: GoogleFonts.inter(
            fontSize: 18,
            color: Color(0xFF0F0F0F),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              "Edit",
              style: GoogleFonts.inter(
                fontSize: 18,
                color: AppColors.textgrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
        elevation: 0,
        // centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage:
                        AssetImage('assets/images/profile_avatar.png'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Male, 45 years old',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('123-456-7890'),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('john.doe@example.com'),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('123 Main St, Anytown, USA'),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Medical Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Blood Type'),
              subtitle: Text('O+'),
            ),
            ListTile(
              leading: Icon(Icons.all_inclusive),
              title: Text('Allergies'),
              subtitle: Text('None'),
            ),
            ListTile(
              leading: Icon(Icons.local_hospital),
              title: Text('Medical Conditions'),
              subtitle: Text('High Blood Pressure'),
            ),
          ],
        ),
      ),
    );
  }
}
