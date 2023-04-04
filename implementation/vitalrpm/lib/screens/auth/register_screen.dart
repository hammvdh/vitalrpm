import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/screens/auth/auth_wrapper.dart';
import 'package:vitalrpm/screens/auth/login_screen.dart';
import 'package:vitalrpm/widgets/loading_overlay.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late UserProvider userProvider;

  final userTypeController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Image(
                        image: AssetImage('assets/logo_side.png'),
                        height: 45,
                      ),
                    ]),
              ),
              Container(
                decoration: BoxDecoration(color: AppColors.blue),
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Registration',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // const SizedBox(height: 5),
                      // Text(
                      //   "Let's get you started.",
                      //   style: GoogleFonts.inter(
                      //     color: AppColors.darkBlue,
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.w500,
                      //     height: 1.3,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10.0),
                      RichText(
                        text: TextSpan(
                          text: 'Registering as',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' *',
                              style: GoogleFonts.inter(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      CustomDropdown(
                        hintText: 'Patient or Doctor?',
                        items: const ['Patient', 'Doctor'],
                        controller: userTypeController,
                        excludeSelected: false,
                        onChanged: (item) {},
                        fillColor: const Color(0XFFEDEAEA),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      const SizedBox(height: 20.0),
                      RichText(
                        text: TextSpan(
                          text: 'First Name',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' *',
                              style: GoogleFonts.inter(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: const Color(0XFFF1F1F1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: TextFormField(
                              controller: firstNameController,
                              textInputAction: TextInputAction.next,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return 'Please type a first name';
                                }
                                return null;
                              },
                              // onSaved: (input) => _password = input,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'First Name',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      RichText(
                        text: TextSpan(
                          text: 'Last Name',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' *',
                              style: GoogleFonts.inter(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: const Color(0XFFF1F1F1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: TextFormField(
                              controller: lastNameController,
                              textInputAction: TextInputAction.next,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return 'Please type a last name';
                                }
                                return null;
                              },
                              // onSaved: (input) => _password = input,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Last Name',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      RichText(
                        text: TextSpan(
                          text: 'Email Address',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' *',
                              style: GoogleFonts.inter(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: const Color(0XFFF1F1F1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: TextFormField(
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return 'Please type email';
                                }
                                return null;
                              },
                              // onSaved: (input) => _email = input,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Email Address',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      RichText(
                        text: TextSpan(
                          text: 'Password',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' *',
                              style: GoogleFonts.inter(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: const Color(0XFFF1F1F1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: _obscureText,

                              textInputAction: TextInputAction.done,
                              validator: (input) {
                                if (input!.length < 6) {
                                  return 'Your password needs to be at least 6 characters';
                                }
                                return null;
                              },
                              // onSaved: (input) => _password = input,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Password',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  color: Colors.black87,
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: GestureDetector(
                          onTap: register,
                          child: Container(
                            width: screenWidth / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColors.darkBlue,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 19),
                              child: Center(
                                child: Text(
                                  'Create',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                "Already have an account?",
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: AppColors.textgrey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Login",
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: AppColors.darkBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() async {
    print(
        '-------------------- Registration in Progress -----------------------');
    LoadingOverlay.of(context).show();
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
    // var userId = userCredential.user?.uid;
    await userProvider.createUser(
      userCredential.user?.uid,
      emailController.text.trim(),
      firstNameController.text.trim(),
      lastNameController.text.trim(),
      userTypeController.text.trim(),
    );
    LoadingOverlay.of(context).hide();
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AuthenticationWrapper(),
      ),
    );
  }
}
