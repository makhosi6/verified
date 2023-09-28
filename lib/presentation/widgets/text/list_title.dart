import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/presentation/theme.dart';

class ListTitle extends StatelessWidget {
  final String text;

  const ListTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.dmSans(
        color: neutralDarkGrey,
        fontSize: 14.0,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
