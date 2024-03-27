import 'dart:async';

import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/application/auth/auth_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/auth_providers.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/account_page.dart';
import 'package:verified/presentation/pages/webviews/terms_of_use.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

FutureOr triggerAuthBottomSheet({required BuildContext context, required Widget redirect}) async =>
    showModalBottomSheet(
      context: context,
      // showDragHandle: true,
      builder: (context) => BlocListener<StoreBloc, StoreState>(
        listener: (context, state) {
          if (!state.userProfileDataLoading && state.userProfileData != null && state.userProfileData != null) {
            ///
            Navigator.of(context).pop();

            ///
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: const Text(
                    'Logged In!',
                  ),
                  backgroundColor: primaryColor,
                ),
              );

            ///
            navigate(context, page: redirect);
          }
        },
        child: SingleChildScrollView(
          child: Container(
            constraints:  appConstraints,
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                /// sign in text
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      const Text(
                        'Sign in to continue',
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
                                  text: 'New to Verified? ',
                                ),
                                TextSpan(
                                  text: 'Sign Up',
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
                                const TextSpan(text: '! \n'),
                                const TextSpan(
                                  text: 'Read our ',
                                ),
                                TextSpan(
                                  text: 'Terms Of Use',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) => const TermOfUseWebView(),
                                        ),
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
                ...buttons(context, type: 'signin'),
              ],
            ),
          ),
        ),
      ),
    );

///
/// type = "signin" | "signup"
List<Widget> buttons(BuildContext context, {required String type}) {
  void handler(AuthProvider provider) => context.read<AuthBloc>().add(AuthEvent.signInWithProvider(provider));
  final label = type == 'signin' ? 'Log In' : 'Sign Up';
  
  return [
    Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: BaseButton(
        key: UniqueKey(),
        onTap: () => handler(VerifiedAuthProvider.google),
        label: '$label with Google',
        buttonIcon: const Image(
          image: AssetImage('assets/icons/google.png'),
        ),
        buttonSize: ButtonSize.large,
        hasBorderLining: true,
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: BaseButton(
        key: UniqueKey(),
        onTap: () => handler(VerifiedAuthProvider.facebook),
        label: '$label with Facebook',
        buttonIcon: const Image(
          image: AssetImage('assets/icons/facebook.png'),
        ),
        buttonSize: ButtonSize.large,
        hasBorderLining: true,
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: BaseButton(
        key: UniqueKey(),
        onTap: () => handler(VerifiedAuthProvider.apple),
        label: '$label with Apple',
        buttonIcon: const Image(
          image: AssetImage('assets/icons/apple.png'),
        ),
        buttonSize: ButtonSize.large,
        hasBorderLining: true,
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: BaseButton(
        key: UniqueKey(),
        onTap: () => handler(VerifiedAuthProvider.twitter),
        label: '$label with Twitter',
        buttonIcon: const Image(
          image: AssetImage('assets/icons/twitter.png'),
        ),
        buttonSize: ButtonSize.large,
        hasBorderLining: true,
      ),
    ),
    Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: BaseButton(
        key: UniqueKey(),
        onTap: () => handler(VerifiedAuthProvider.microsoft),
        label: '$label with Microsoft',
        buttonIcon: const Image(
          image: AssetImage('assets/icons/microsoft.png'),
        ),
        buttonSize: ButtonSize.large,
        hasBorderLining: true,
      ),
    ),
  ];
}

Future triggerSignUpBottomSheet<bool>({
  required BuildContext context,
}) async =>
    showModalBottomSheet(
      context: context,
      // showDragHandle: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 600.0,
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
                      'Sign Up to continue',
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
                                text: 'Already have an account? ',
                              ),
                              TextSpan(
                                text: 'Sign In',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    try {
                                      Navigator.of(context).pop();
                                      await triggerAuthBottomSheet(context: context, redirect: AccountPage());
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                style: GoogleFonts.ibmPlexSans(
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  color: darkerPrimaryColor,
                                ),
                              ),
                              const TextSpan(text: '! \n'),
                              const TextSpan(
                                text: 'Read our ',
                              ),
                              TextSpan(
                                text: 'Terms Of Use',
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
              ...buttons(context, type: 'signup'),
            ],
          ),
        ),
      ),
    );
