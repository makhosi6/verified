import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/presentation/pages/webviews/terms_of_use.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

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
                                text: "New to Verified? ",
                              ),
                              TextSpan(
                                text: "Sign Up",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    Navigator.of(context).pop();
                                    await triggerSignUpBottomSheet(context: context);
                                  },
                                style: GoogleFonts.ibmPlexSans(
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  color: darkerPrimaryColor,
                                ),
                              ),
                              const TextSpan(text: "! \n\n"),
                              const TextSpan(
                                text: "Read our ",
                              ),
                              TextSpan(
                                text: "Terms Of Use",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                          builder: (BuildContext context) => const TermOfUseWebView()),
                                    );
                                  },
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

FutureOr triggerSignUpBottomSheet({
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
                      "Sign Up to continue",
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
                                text: "Already have an account? ",
                              ),
                              TextSpan(
                                text: "Sign In",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    Navigator.of(context).pop();
                                    await triggerAuthBottomSheet(context: context);
                                  },
                                style: GoogleFonts.ibmPlexSans(
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  color: darkerPrimaryColor,
                                ),
                              ),
                              const TextSpan(text: "! \n\n"),
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
                label: "Sign Up with Google",
                buttonIcon: const Image(
                  image: AssetImage("assets/icons/google.png"),
                ),
                buttonSize: ButtonSize.large,
                hasBorderLining: true,
              ),
              BaseButton(
                key: UniqueKey(),
                onTap: () {},
                label: "Sign Up with Facebook",
                buttonIcon: const Image(
                  image: AssetImage("assets/icons/facebook.png"),
                ),
                buttonSize: ButtonSize.large,
                hasBorderLining: true,
              ),

              BaseButton(
                key: UniqueKey(),
                onTap: () {},
                label: "Sign Up with Apple",
                buttonIcon: const Image(
                  image: AssetImage("assets/icons/apple.png"),
                ),
                buttonSize: ButtonSize.large,
                hasBorderLining: true,
              ),

              BaseButton(
                key: UniqueKey(),
                onTap: () {},
                label: "Sign Up with Microsoft",
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
