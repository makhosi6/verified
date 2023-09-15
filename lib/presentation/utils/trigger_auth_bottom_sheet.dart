import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verify_sa/presentation/theme.dart';
import 'package:verify_sa/presentation/widgets/buttons/base_buttons.dart';

FutureOr triggerAuthBottomSheet({
  required BuildContext context,
}) async =>
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 500.0,
          ),
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              /// sign in text
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    const Text(
                      "Sign in to continue",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                        fontStyle: FontStyle.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: neutralDarkGrey,
                              fontSize: 14.0,
                            ),
                            children: [
                              const TextSpan(
                                text: "New to Verify SA? ",
                              ),
                              TextSpan(
                                text: "Sign Up",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => {},
                                style: GoogleFonts.ibmPlexSans(
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  color: darkerPrimaryColor,
                                ),
                              ),
                              const TextSpan(text: "! \n"),
                              const TextSpan(
                                text: "Read our ",
                              ),
                              TextSpan(
                                text: "Terms Of Use",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => {},
                                style: GoogleFonts.ibmPlexSans(
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  color: darkerPrimaryColor,
                                ),
                              ),
                            ]),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),

              ///buttons
              BaseButton(
                key: UniqueKey(),
                onTap: () {},
                label: "Login with Google",
                buttonIcon: const Image(
                  image: AssetImage("assets/icons/google.png"),
                ),
                buttonSize: ButtonSize.large,
                hasBorderLining: true,
              ),
              BaseButton(
                key: UniqueKey(),
                onTap: () {},
                label: "Login with Facebook",
                buttonIcon: const Image(
                  image: AssetImage("assets/icons/facebook.png"),
                ),
                buttonSize: ButtonSize.large,
                hasBorderLining: true,
              ),

              BaseButton(
                key: UniqueKey(),
                onTap: () {},
                label: "Login with Apple",
                buttonIcon: const Image(
                  image: AssetImage("assets/icons/apple.png"),
                ),
                buttonSize: ButtonSize.large,
                hasBorderLining: true,
              ),

              BaseButton(
                key: UniqueKey(),
                onTap: () {},
                label: "Login with Microsoft",
                buttonIcon: const Image(
                  image: AssetImage("assets/icons/microsoft.png"),
                ),
                buttonSize: ButtonSize.large,
                hasBorderLining: true,
              ),
            ],
          ),
        ),
      ),
    );
