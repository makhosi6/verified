import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verify_sa/presentation/theme.dart';

Future showDefaultPopUp(
  BuildContext context, {
  required String title,
  required String subtitle,
  required String confirmBtnText,
  required String declineBtnText,
  required void Function() onConfirm,
  required void Function() onDecline,
}) =>
    showDialog(
      context: context,
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
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              declineBtnText,
            ),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, true),
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
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: Colors.red),
              )),
            ),
            child: Text(
              confirmBtnText,
            ),
          ),
        ],
      ),
    );
