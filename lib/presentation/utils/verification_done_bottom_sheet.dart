import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/theme.dart';

FutureOr verificationDoneBottomSheet(BuildContext context,
        {required String title,
        required String msg,
        required List<Widget> actions,
        required LottieBuilder? lottieBuilder,
        Color color = Colors.white}) =>
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: color,
      isDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.only(bottom: 20),
              height: 200,
              width: double.infinity,
              child: lottieBuilder,
            ),
            SingleChildScrollView(
              child: Container(
                constraints: appConstraints,
                child: Column(
                  children: [
                    /// sign in text
                    Container(
                      padding: EdgeInsets.only(
                        top: primaryPadding.top,
                        bottom: primaryPadding.vertical,
                      ),
                      child: Column(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              fontStyle: FontStyle.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: primaryPadding.vertical,
                              horizontal: primaryPadding.vertical * 1.3,
                            ),
                            child: Text(
                              msg,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: neutralDarkGrey,
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///
                    ...actions,
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
