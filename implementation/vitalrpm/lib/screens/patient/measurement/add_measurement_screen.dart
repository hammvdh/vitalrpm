import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vitalrpm/app_localizations.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:vitalrpm/const/measurement_types.dart';
import 'package:vitalrpm/providers/user_provider.dart';
import 'package:vitalrpm/widgets/label_date_field_widget.dart';
import 'package:vitalrpm/widgets/label_text_field_widget.dart';
import 'package:vitalrpm/widgets/label_time_field_widget.dart';

class AddMeasurementScreen extends StatefulWidget {
  const AddMeasurementScreen({super.key, this.type, this.patientId});

  final String? type;
  final String? patientId;

  @override
  State<AddMeasurementScreen> createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends State<AddMeasurementScreen> {
  late UserProvider userProvider;
  late bool isUserDoctor;
  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    isUserDoctor = userProvider.loginUser.userType.toLowerCase() == "doctor";
    if (widget.type != null) {
      measurementTypeController.text = widget.type!;
    }
    super.initState();
  }

  final measurementTypeController = TextEditingController();

  final sysController = TextEditingController();
  final diaController = TextEditingController();
  final readingController = TextEditingController();

  String selectedTime =
      "${TimeOfDay.now().hour < 10 ? "0" : ""}${TimeOfDay.now().hour}:${TimeOfDay.now().minute < 10 ? "0" : ""}${TimeOfDay.now().minute}";
  String selectedDate = DateTime.now().toString();

  final mealsController = TextEditingController();
  final notesController = TextEditingController();

  void resetVariables() {
    sysController.clear();
    diaController.clear();
    readingController.clear();
    mealsController.clear();
    notesController.clear();
  }

  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Submit form
      addMeasurement();
    }
  }

  late AppLocalizations local;

  @override
  Widget build(BuildContext context) {
    local = AppLocalizations.of(context)!;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
                SizedBox(
                  height: 105,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                local.t('add_measurement')!,
                                style: GoogleFonts.inter(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              SizedBox(
                                width: screenWidth / 1.4,
                                child: Text(
                                  local.t('keep_track_of_measurements')!,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppColors.textGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            local.t('measurement_type')!,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: AppColors.textBlack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomDropdown.search(
                            hintText: local.t('select_measurement_type')!,
                            items: MeasurementTypes.measurementTypes,
                            controller: measurementTypeController,
                            excludeSelected: false,
                            onChanged: (item) {
                              setState(() {
                                resetVariables();
                              });
                            },
                            fillColor: const Color(0XFFEDEAEA),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          const SizedBox(height: 13),
                          Divider(
                            height: 1,
                            thickness: 1.6,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 15),
                          if (measurementTypeController.text != "") ...[
                            Text(
                              measurementTypeController.text,
                              style: GoogleFonts.inter(
                                fontSize: 19,
                                color: AppColors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (measurementTypeController.text ==
                                "Respiratory Rate") ...[
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: LabelTextFieldWidget(
                                      label: "",
                                      controller: readingController,
                                      isRequired: true,
                                      maxLength: 3,
                                      hintText: local.t("enter_value")!,
                                      suffixText: "bpm",
                                      textInputType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (measurementTypeController.text ==
                                "Blood Oxygen Saturation") ...[
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: LabelTextFieldWidget(
                                      label: "",
                                      controller: readingController,
                                      isRequired: true,
                                      maxLength: 5,
                                      hintText: local.t("enter_value")!,
                                      suffixText: "%",
                                      textInputType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (measurementTypeController.text ==
                                "Heart Rate") ...[
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: LabelTextFieldWidget(
                                      label: "",
                                      controller: readingController,
                                      isRequired: true,
                                      maxLength: 5,
                                      hintText: local.t("enter_value")!,
                                      suffixText: "bpm",
                                      textInputType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (measurementTypeController.text ==
                                "Body Temperature") ...[
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: LabelTextFieldWidget(
                                      label: "",
                                      controller: readingController,
                                      isRequired: true,
                                      maxLength: 5,
                                      hintText: local.t("enter_value")!,
                                      suffixText: "°F",
                                      textInputType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (measurementTypeController.text ==
                                "Blood Pressure") ...[
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Flexible(
                                    child: LabelTextFieldWidget(
                                      label: local.t("systolic")!,
                                      controller: sysController,
                                      hintText: local.t("enter_value")!,
                                      isRequired: true,
                                      maxLength: 5,
                                      suffixText: "mmHg",
                                      textInputType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: LabelTextFieldWidget(
                                      label: local.t("diastolic")!,
                                      controller: diaController,
                                      hintText: local.t("enter_value")!,
                                      isRequired: true,
                                      maxLength: 5,
                                      suffixText: "mmHg",
                                      textInputType: TextInputType.number,
                                    ),
                                  )
                                ],
                              ),
                            ],
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Flexible(
                                  child: LabelDateFieldWidget(
                                    label: local.t("reading_date")!,
                                    initialDate: DateTime.now(),
                                    isLastDateToday: true,
                                    onSelected: (DateTime date) {
                                      selectedDate = date.toString();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: LabelTimeFieldWidget(
                                    label: local.t("reading_time")!,
                                    value:
                                        "${TimeOfDay.now().hour < 10 ? "0" : ""}${TimeOfDay.now().hour}:${TimeOfDay.now().minute < 10 ? "0" : ""}${TimeOfDay.now().minute}",
                                    onSelected: (String time) {
                                      selectedTime = time;
                                    },
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  local.t('meals')!,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    color: AppColors.textBlack,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  " *",
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFFE5234A),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            CustomDropdown(
                              hintText: local.t('meals')!,
                              items: [
                                local.t('before_meals')!,
                                local.t('after_meals')!,
                                local.t('not_applicable')!
                              ],
                              controller: mealsController,
                              // excludeSelected: false,
                              onChanged: (item) {},
                              fillColor: const Color(0XFFEDEAEA),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              local.t('notes')!,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: AppColors.textBlack,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              local.t('anything_wanna_know')!,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Flexible(
                                  child: LabelTextFieldWidget(
                                    label: "",
                                    hintText: local.t("add_note")!,
                                    controller: notesController,
                                    isRequired: false,
                                    textInputType: TextInputType.text,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    resetVariables();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 140,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.grey,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Text(
                                        local.t('cancel')!,
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          color: AppColors.textWhite,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    _submitForm();
                                  },
                                  child: Container(
                                    width: 140,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Text(
                                        local.t('save')!,
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          color: AppColors.textWhite,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                          ],
                          if (measurementTypeController.text == "") ...[
                            const SizedBox(height: 485),
                          ]
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addMeasurement() async {
    DocumentReference measurementDocument;
    final type = measurementTypeController.text;
    final unit = getMeasurementUnit(type);
    final systolic = sysController.text;
    final diastolic = diaController.text;
    final reading = readingController.text;
    final meal = mealsController.text;
    final notes = notesController.text;

    if (type == "Blood Pressure") {
      if (systolic.isEmpty || diastolic.isEmpty) {
        // print("bp_validation");
        return;
      }
    } else {
      if (reading.isEmpty) {
        // print("Reading value is required.");
        return;
      }
    }

    FirebaseFirestore.instance.runTransaction((transaction) async {
      try {
        measurementDocument =
            FirebaseFirestore.instance.collection('measurements').doc();
        transaction.set(measurementDocument, {
          'docId': measurementDocument.id,
          'patientId': isUserDoctor
              ? widget.patientId
              : userProvider.loginUser.documentId,
          'type': type,
          'reading': type == "Blood Pressure"
              ? {
                  'systolic': systolic,
                  'diastolic': diastolic,
                }
              : reading,
          'unit': unit,
          'date': selectedDate,
          'time': selectedTime,
          'timestamp': Timestamp.now(),
          'meals': meal,
          'notes': notes
        });

        Navigator.pop(context);
      } catch (e) {
        // print("Add Measurement - Unable to add measurement - $e");
      }
    });
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
