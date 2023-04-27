import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/app_localizations.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/models/user_model.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/widgets/bottom_navbar_widget.dart';

class AddPatientsScreen extends StatefulWidget {
  const AddPatientsScreen({super.key});

  @override
  State<AddPatientsScreen> createState() => _AddPatientsScreenState();
}

class _AddPatientsScreenState extends State<AddPatientsScreen> {
  List<DocumentSnapshot> _users = [];
  late UserProvider userProvider;
  late UserModel loginUser;
  late AppLocalizations local;
  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    loginUser = userProvider.loginUser;
    super.initState();
    _getUsers();
  }

  Future<void> _getUsers() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('usermaster')
          .where('usertype', isEqualTo: 'Patient')
          .where('doctor', isEqualTo: '')
          .get();
      setState(() {
        _users = querySnapshot.docs;
      });
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> _updateDoctorField(String userId, String doctorId) async {
    try {
      await FirebaseFirestore.instance
          .collection('usermaster')
          .doc(userId)
          .update({'doctor': doctorId});
    } catch (e) {
      // print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    local = AppLocalizations.of(context)!;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(currentPage: 1),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.blue),
            height: 100,
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    local.t('add_patients')!,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              local.t("available_patients")!,
              style: GoogleFonts.inter(
                fontSize: 20,
                color: AppColors.textBlack,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_users.isEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                local.t("no_patients_available")!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
          ListView.builder(
            shrinkWrap: true,
            itemCount: _users.length,
            itemBuilder: (context, index) {
              var user = _users[index];
              return Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFFD4D3D4).withOpacity(0.8),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user['firstName']} ${user['lastName']}',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: AppColors.textBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            user['emailAddress'],
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Update the user's doctor field
                          await _updateDoctorField(
                              user.id, loginUser.doctorId!);
                          // Refresh the user list
                          await _getUsers();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            local.t("add")!,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    ]),
              );
            },
          ),
        ],
      )),
    );
  }
}
