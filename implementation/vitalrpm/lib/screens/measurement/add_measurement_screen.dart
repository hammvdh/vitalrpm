import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalrpm/const/color_const.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:vitalrpm/widgets/label_date_field_widget.dart';
import 'package:vitalrpm/widgets/label_text_field_widget.dart';
import 'package:vitalrpm/widgets/label_time_field_widget.dart';

class AddMeasurementScreen extends StatefulWidget {
  const AddMeasurementScreen({super.key});

  @override
  State<AddMeasurementScreen> createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends State<AddMeasurementScreen> {
  List<String> measurementTypes = [
    "Blood Pressure",
    "Heart Rate",
    "Body Temperature",
    "Respiratory Rate",
    "Blood Oxygen Saturation"
  ];
  final measurementTypeController = TextEditingController();

  final sysController = TextEditingController();
  final diaController = TextEditingController();
  final heartRateController = TextEditingController();
  final tempController = TextEditingController();
  final resprateController = TextEditingController();
  final o2SatController = TextEditingController();
  final mealsController = TextEditingController();
  final notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
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
                  padding: EdgeInsets.only(top: 15, left: 15),
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
                              'Add Measurement',
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
                                'Keep track of your health vital sign measurements',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.textgrey,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Measurement Type',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: AppColors.textblack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomDropdown.search(
                          hintText: 'Select Measurement Type',
                          items: measurementTypes,
                          controller: measurementTypeController,
                          excludeSelected: false,
                          onChanged: (item) {
                            setState(() {});
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
                                    controller: resprateController,
                                    isRequired: true,
                                    maxLength: 3,
                                    hintText: "Enter a value.",
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
                                    controller: o2SatController,
                                    isRequired: true,
                                    maxLength: 2,
                                    hintText: "Enter a value.",
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
                                    controller: heartRateController,
                                    isRequired: true,
                                    maxLength: 3,
                                    hintText: "Enter a value.",
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
                                    controller: tempController,
                                    isRequired: true,
                                    maxLength: 3,
                                    hintText: "Enter a value.",
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
                                    label: "Systolic",
                                    controller: sysController,
                                    isRequired: true,
                                    maxLength: 3,
                                    suffixText: "mmHg",
                                    textInputType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: LabelTextFieldWidget(
                                    label: "Diastolic",
                                    controller: diaController,
                                    isRequired: true,
                                    maxLength: 3,
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
                                  label: "Reading Date",
                                  initialDate: DateTime.now(),
                                  isLastDateToday: true,
                                  onSelected: (DateTime date) {},
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: LabelTimeFieldWidget(
                                  label: "Reading Time",
                                  value:
                                      "${TimeOfDay.now().hour < 10 ? "0" : ""}${TimeOfDay.now().hour}:${TimeOfDay.now().minute < 10 ? "0" : ""}${TimeOfDay.now().minute}",
                                  onSelected: (String time) {
                                    //
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Meals',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: AppColors.textblack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomDropdown(
                            hintText: 'Before or After Meals?',
                            items: const ['Before Meals', 'After Meals'],
                            controller: mealsController,
                            excludeSelected: false,
                            onChanged: (item) {},
                            fillColor: const Color(0XFFEDEAEA),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Notes',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: AppColors.textblack,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Anything you would like the doctor to know?',
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
                                  controller: notesController,
                                  isRequired: false,
                                  textInputType: TextInputType.text,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 100),
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
    );
  }
}
