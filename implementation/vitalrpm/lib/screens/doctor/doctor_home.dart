import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/providers/doctor_provider.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/auth/auth_wrapper.dart';

class DoctorHomeDashboard extends StatefulWidget {
  const DoctorHomeDashboard({super.key});

  @override
  State<DoctorHomeDashboard> createState() => _DoctorHomeDashboardState();
}

class _DoctorHomeDashboardState extends State<DoctorHomeDashboard> {
  late UserProvider userProvider;

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppColors.darkBlue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image(
                                width: MediaQuery.of(context).size.width,
                                image: const AssetImage(
                                    'assets/images/account.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome,',
                              style: GoogleFonts.inter(
                                fontSize: 17,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Dr. ${userProvider.loginUser.firstName} ${userProvider.loginUser.lastName}',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                color: AppColors.darkBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      color: Colors.blue,
                      icon: Icon(
                        Icons.logout,
                        color: AppColors.blue,
                        size: 35,
                      ),
                      tooltip: 'Logout',
                      onPressed: () {
                        userProvider.logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthenticationWrapper(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  "Your Patients",
                  style: GoogleFonts.inter(
                    fontSize: 23,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('usermaster')
                      .where('usertype', isEqualTo: 'Patient')
                      .where('doctor',
                          isEqualTo: userProvider.loginUser.doctorId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      print('No Patient');
                      return Container(
                        child: Text('No Data'),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot patient = snapshot.data!.docs[index];
                        return Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                            color: Color(0XFF1d3566),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 5, 39, 98)
                                    .withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 20,
                                offset: Offset(
                                    22, 19), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${patient.get('firstName')} ${patient.get('lastName')}',
                                      style: GoogleFonts.inter(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Status: Normal",
                                      style: GoogleFonts.inter(
                                        fontSize: 17,
                                        color: Color(0xff92d3ff),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Color(0xff92d3ff),
                                  size: 35,
                                ),
                              ]),
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
