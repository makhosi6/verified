import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/application/auth/auth_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/auth_providers.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/presentation/pages/account_page.dart';
import 'package:verified/presentation/pages/webviews/terms_of_use.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/widget_generator_options.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

FutureOr triggerAuthBottomSheet({required BuildContext context, required Widget redirect}) async =>
    showModalBottomSheet(
      context: context,
      showDragHandle: true, //TargetPlatform.android != defaultTargetPlatform,
      builder: (context) => BlocListener<StoreBloc, StoreState>(
        listener: (context, state) async {
          if (!state.userProfileDataLoading && state.userProfileData != null && state.userProfileData != null) {
            ///
            //     Navigator.of(context).pop();
            //  await Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
            //       builder: (BuildContext context) => CreateAccountPage(),
            //     ));
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
            navigate(context, page: redirect, replaceCurrentPage: true);
          }
        },
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 600,
            ),
            // padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                /// sign in text
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Column(
                    children: [
                      const Text(
                        'Sign in to continue',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: neutralDarkGrey,
                                fontSize: 14,
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
                                      await triggerSignUpBottomSheet(context: context, redirect: redirect);
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
                const SizedBox(
                  height: 30,
                )
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
  // void handle2(url) => navigate(
  //       context,
  //   page: VerifiedAuthWebView(
  //     url: url,
  //     onPageCancelled: () {
  //       ScaffoldMessenger.of(context)
  //         ..clearSnackBars()
  //         ..showSnackBar(
  //           SnackBar(
  //             content: const Text(
  //               'Logged In Cancelled!',
  //             ),
  //             backgroundColor: warningColor,
  //           ),
  //         );
  //     },
  //     onPageSuccess: (data) {
  //       if (type == 'signin') {
  //         context.read<AuthBloc>().add(AuthEvent.webSignIn(data));
  //       } else if (type == 'signup') {
  //         context.read<AuthBloc>().add(AuthEvent.webSignUp(data));
  //       }
  //       Navigator.pop(context);
  //       ScaffoldMessenger.of(context)
  //         ..clearSnackBars()
  //         ..showSnackBar(
  //           SnackBar(
  //             content: const Text(
  //               'Logged In!',
  //             ),
  //             backgroundColor: primaryColor,
  //           ),
  //         );
  //     },
  //     onPageFailed: (_) {
  //       Navigator.pop(context);
  //       ScaffoldMessenger.of(context)
  //         ..clearSnackBars()
  //         ..showSnackBar(
  //           SnackBar(
  //             content: const Text(
  //               'Logged In Failed!',
  //             ),
  //             backgroundColor: errorColor,
  //           ),
  //         );
  //     },
  //   ),
  // );
  final label = type == 'signin' ? 'Log In' : 'Sign Up';
  // var loginUrl = '$WEB_AUTH_SERVER/login';
  // var registerUrl = '$WEB_AUTH_SERVER/register';
  return [
    // AuthButtonsOption(
    //   onTapHandler: () => handle2(
    //     type == 'signin' ? loginUrl : registerUrl,
    //   ),
    //   label: type == 'signin' ? 'Login with an Email' : 'Create an Account',
    //   icon: const Image(
    //     image: AssetImage('assets/icons/email.png'),
    //   ),
    // ),
    AuthButtonsOption(
      onTapHandler: () => handler(VerifiedAuthProvider.google),
      label: '$label with Google',
      icon: const Image(
        image: AssetImage('assets/icons/google.png'),
      ),
    ),
    AuthButtonsOption(
      onTapHandler: () => handler(VerifiedAuthProvider.apple),
      label: '$label with Apple',
      icon: const Image(
        image: AssetImage('assets/icons/apple.png'),
      ),
    ),
    AuthButtonsOption(
      onTapHandler: () => handler(VerifiedAuthProvider.microsoft),
      label: '$label with Microsoft',
      icon: const Image(
        image: AssetImage('assets/icons/microsoft.png'),
      ),
    ),
    AuthButtonsOption(
      onTapHandler: () => handler(VerifiedAuthProvider.twitter),
      label: '$label with Twitter',
      icon: const Image(
        image: AssetImage('assets/icons/twitter.png'),
      ),
    ),
  ]
      .map((btnOptions) => Padding(
            padding: TargetPlatform.android == defaultTargetPlatform
                ? primaryPadding.copyWith(
                    bottom: 8,
                    top: 0,
                  )
                : const EdgeInsets.only(bottom: 8),
            child: BaseButton(
              key: UniqueKey(),
              onTap: btnOptions.onTapHandler,
              label: btnOptions.label,
              buttonIcon: btnOptions.icon,
              buttonSize: ButtonSize.large,
              hasBorderLining: true,
            ),
          ))
      .toList();
}

Future triggerSignUpBottomSheet<bool>({required BuildContext context, required Widget redirect}) async =>
    showModalBottomSheet(
      context: context,
      showDragHandle: TargetPlatform.android != defaultTargetPlatform,
      builder: (context) => BlocListener<StoreBloc, StoreState>(
        listener: (context, state) async {
          if (!state.userProfileDataLoading && state.userProfileData != null && state.userProfileData != null) {
            ///
            Navigator.of(context).pop();

            // await Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
            //   builder: (BuildContext context) => CreateAccountPage(),
            // ),);

            ///
            // ignore: use_build_context_synchronously
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
            // ignore: use_build_context_synchronously
            navigate(context, page: redirect, replaceCurrentPage: true);
          }
        },
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 600,
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                /// sign in text
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      const Text(
                        'Sign Up to continue',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: neutralDarkGrey,
                                fontSize: 14,
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
                                      } catch (error, stackTrace) {
                                        verifiedErrorLogger(error, stackTrace);
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
                ...buttons(context, type: 'signup'),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
