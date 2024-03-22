import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/presentation/theme.dart';

Future showDefaultPopUp(
  BuildContext context, {
  required String title,
  required String subtitle,
  String? confirmBtnText,
  String? declineBtnText,
  void Function()? onConfirm,
  void Function()? onDecline,
}) =>
    showDialog(
      context: context,
      barrierColor: darkBlurColor,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 24,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: Text(
          subtitle,
          style: GoogleFonts.dmSans(
            fontSize: 16.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
            color: neutralDarkGrey,
          ),
        ),
        actions: [
          /// Decline button
          if (declineBtnText != null)
            TextButton(
              onPressed: onDecline,
              child: Text(
                declineBtnText,
              ),
            ),

          /// Confirm button
          if (confirmBtnText != null)
            OutlinedButton(
              onPressed: onConfirm,
              style: ButtonStyle(
                side: MaterialStatePropertyAll(
                  BorderSide(
                    color: primaryColor,
                  ),
                ),
                textStyle: const MaterialStatePropertyAll(
                  TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              child: Text(
                confirmBtnText,
              ),
            ),
        ],
      ),
    );
