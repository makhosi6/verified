import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/presentation/theme.dart';

class Balance extends StatelessWidget {
  final String? title;
  const Balance({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //name
              Text(
                title ?? "Hello",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0,
                ),
              ),
              // subtitle
              Text(
                "Your available balance",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: neutralDarkGrey,
                  fontSize: 14.0,
                ),
              )
            ],
          ),
          //balance
          Text(
            r"$15,901",
            style: GoogleFonts.dmSans(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
            textAlign: TextAlign.right,
          )
        ],
      ),
    );
  }
}
