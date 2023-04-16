// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalrpm/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:vitalrpm/const/color_const.dart';

class LabelDateFieldWidget extends StatefulWidget {
  final String label;
  final Function(DateTime date) onSelected;
  final DateTime? initialDate;
  final bool isRequired;
  final bool isLastDateToday;
  const LabelDateFieldWidget({
    Key? key,
    required this.label,
    required this.onSelected,
    this.initialDate,
    this.isRequired = true,
    this.isLastDateToday = true,
  }) : super(key: key);

  @override
  State<LabelDateFieldWidget> createState() => LabelDateFieldWidgetState();
}

class LabelDateFieldWidgetState extends State<LabelDateFieldWidget> {
  late AppLocalizations local;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      if (widget.initialDate!.year < 1900) {
        controller.text = 'N/A';
      }
      controller.text = DateFormat('dd-MMM-yyyy').format(widget.initialDate!);
    }
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
                return local.t("warning_date_is_required");
              }
            }
            return null;
          },
          onTap: () {
            openDatePicker(context);
          },
        ),
      ],
    );
  }

  Future<void> openDatePicker(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (widget.initialDate != null) {
      initialDate = widget.initialDate!;
    }
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: widget.isLastDateToday
          ? DateTime.now()
          : DateTime(DateTime.now().year + 100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      setState(() {
        if (selectedDate.year < 1900) {
          controller.text = 'N/A';
        } else {
          controller.text = DateFormat('dd-MMM-yyyy').format(selectedDate);
        }

        widget.onSelected(selectedDate);
      });
    }
  }
}
