import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalrpm/app_localizations.dart';

import '../const/color_const.dart';

class LabelTimeFieldWidget extends StatefulWidget {
  final String label;
  final Function(String time) onSelected;
  final String value;
  final bool isRequired;
  const LabelTimeFieldWidget({
    Key? key,
    required this.label,
    required this.onSelected,
    this.value = "",
    this.isRequired = true,
  }) : super(key: key);

  @override
  State<LabelTimeFieldWidget> createState() => LabelTimeFieldWidgetState();
}

class LabelTimeFieldWidgetState extends State<LabelTimeFieldWidget> {
  late AppLocalizations local;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    local = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 18,
                color: AppColors.textBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.isRequired)
              Text(
                " *",
                style: GoogleFonts.inter(
                  color: const Color(0xFFE5234A),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            filled: true,
            fillColor: const Color(0XFFEDEAEA),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (String? value) {
            if (widget.isRequired) {
              if (value != null && value == "") {
                return local.t("warning_time_is_required");
              }
            }
            return null;
          },
          onTap: () {
            openTimePicker(context);
          },
        ),
      ],
    );
  }

  Future<void> openTimePicker(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    if (widget.value.isNotEmpty) {
      final time = widget.value.split(":");
      if (time.length >= 2) {
        initialTime = TimeOfDay(
          hour: int.parse(time[0]),
          minute: int.parse(time[1]),
        );
      }
    }
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      setState(() {
        controller.text =
            "${pickedTime.hour < 10 ? "0" : ""}${pickedTime.hour}:${pickedTime.minute < 10 ? "0" : ""}${pickedTime.minute}";

        widget.onSelected(controller.text);
      });
    }
  }
}
