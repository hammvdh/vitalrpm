import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitalrpm/app_localizations.dart';
import 'package:vitalrpm/const/color_const.dart';

class LabelTextFieldWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final bool isEnabled;
  final int maxLength;
  final String suffixText;
  final String hintText;
  final TextInputType textInputType;
  const LabelTextFieldWidget({
    Key? key,
    required this.label,
    required this.controller,
    this.suffixText = "",
    this.hintText = "",
    this.isRequired = true,
    this.isEnabled = true,
    this.maxLength = 0,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  State<LabelTextFieldWidget> createState() => _LabelTextFieldWidgetState();
}

class _LabelTextFieldWidgetState extends State<LabelTextFieldWidget> {
  late AppLocalizations local;

  @override
  Widget build(BuildContext context) {
    local = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != "")
            Row(
              children: [
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: AppColors.grey,
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
            controller: widget.controller,
            keyboardType: widget.textInputType,
            maxLines: null,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              counterText: "",
              suffixText: widget.suffixText == "" ? "" : widget.suffixText,
              hintText: widget.hintText == "" ? "" : widget.hintText,
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
            ),
            enabled: widget.isEnabled,
            maxLength: widget.maxLength > 0 ? widget.maxLength : null,
            validator: (text) {
              if (widget.isRequired) {
                if (text == null || text.trim().isEmpty) {
                  return "*Field cannot be empty*";
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
