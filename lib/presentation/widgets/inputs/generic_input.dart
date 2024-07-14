// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class GenericInputField extends StatelessWidget {
  final String hintText;
  final String? label;
  final String? initialValue;
  final bool autofocus;
  final bool readOnly;
  final int? maxLines;
  final String? Function(String? value)? validator;
  final void Function(String value) onChange;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;

  TextInputType? keyboardType;

  GenericInputField({
    Key? key,
    required this.hintText,
    this.label,
    this.initialValue,
    this.autofocus = false,
    this.readOnly = false,
    required this.validator,
    required this.onChange,
    this.onTap,
    this.maxLines,
    this.inputFormatters,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
            ),
          ),
        TextFormField(
          key: Key('input-field-$label'),
          initialValue: initialValue,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: 1,
          readOnly: readOnly,
          autofocus: autofocus,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: const UnderlineInputBorder(),
          ),
          onChanged: onChange,
          validator: validator,
          // validator: (val) {
          //   var errorMsg = validator?.call(val);
          //   if (errorMsg == null) onChange(val ?? ' ');
          //   return errorMsg;
          // },
          style: GoogleFonts.dmSans(
            fontSize: 18.0,
            fontStyle: FontStyle.normal,
          ),
        )
      ],
    );
  }
}
