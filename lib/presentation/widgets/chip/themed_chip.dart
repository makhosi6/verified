import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verify_sa/presentation/theme.dart';

class ThemedChip extends StatelessWidget {
  final String label;
  final void Function() onTap;
  const ThemedChip({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 16, bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 0.5),
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            color: primaryColor,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }
}
