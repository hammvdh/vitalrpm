import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/app_localizations.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/doctor/view_patient_details.dart';
import 'package:vitalrpm/widgets/bottom_navbar_widget.dart';

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

  late AppLocalizations local;

  @override
  Widget build(BuildContext context) {
    local = AppLocalizations.of(context)!;
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(currentPage: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            local.t('welcome')!,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: Text(
                              'Dr. ${userProvider.loginUser.firstName} ${userProvider.loginUser.lastName}',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
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
                                'assets/images/profile_avatar.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  local.t("patient_list")!,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    color: AppColors.textBlack,
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
                    if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Text(
                          local.t("no_patients_available")!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot patient = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ViewPatientDetails(
                                  patient: patient,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color:
                                      const Color(0xFFD4D3D4).withOpacity(0.8),
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0xFFDEE2E5),
                                      offset: Offset(0, 30),
                                      blurRadius: 45)
                                ]),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${patient['firstName']} ${patient['lastName']}',
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          color: AppColors.textBlack,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        patient['emailAddress'],
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: AppColors.textGrey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: AppColors.darkBlue,
                                    size: 25,
                                  ),
                                ]),
                          ),
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
