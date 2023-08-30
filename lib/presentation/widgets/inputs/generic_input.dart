import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class GenericInputField extends StatelessWidget {
  final String hintText;
  final String label;
  final void Function(String value) onChange;
  const GenericInputField({
    super.key,
    required this.hintText,
    required this.label,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
        ),
        TextFormField(
          key: UniqueKey(),
          inputFormatters: const <TextInputFormatter>[],
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[400]),
            border: const UnderlineInputBorder(),
          ),
          onChanged: onChange,
          validator: (value) {
            return null;
          },
          style: GoogleFonts.dmSans(
            fontSize: 18.0,
            fontStyle: FontStyle.normal,
          ),
        )
      ],
    );
  }
}
