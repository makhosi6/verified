// ignore_for_file: prefer_single_quotes

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:verified/app_config.dart';
import 'package:verified/domain/models/help_ticket.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/app_info.dart';
import 'package:verified/presentation/utils/device_info.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/auth/auth_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';

/// Create key
final _pinFormKey = GlobalKey<FormState>(debugLabel: 'PinFormKey');

///
void onLogInAsTestUser(BuildContext context) {
  try {
    // Current device and package info
    Map<String, dynamic>? device;
    Map<String, dynamic>? appInfo;

    Future.microtask(() async {
      try {
        /// set device info
        device = await getCurrentDeviceInfo();
        appInfo = await getVerifiedPackageInfo();

        /// vibrate/confirmation
        if ((await Vibration.hasCustomVibrationsSupport()) == true) {
          Vibration.vibrate(duration: 1000);
        } else {
          Vibration.vibrate();
          await Future.delayed(const Duration(milliseconds: 500));
          Vibration.vibrate();
        }
      } catch (e) {
        print(e);
      }
    });

    ///
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: const Color.fromARGB(106, 0, 0, 0),
          child: Center(
            child: Container(
              color: const Color.fromARGB(159, 5, 181, 87),
              padding: primaryPadding,
              constraints: appConstraints,
              child: Form(
                key: _pinFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  autofocus: true,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 20,),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(primaryPadding.top),
                    ),
                  ),
                  obscureText: true,
                  validator: (code) {
                    if (code == ADMIN_CODE) {
                      final testUserProfile = UserProfile.fromJson(testUser);

                      ///clear current user
                      context.read<AuthBloc>().add(const AuthEvent.signOut());
                      context.read<StoreBloc>().add(const StoreEvent.clearUser());

                      ///
                      context.read<StoreBloc>()

                        /// notify admin
                        ..add(
                          StoreEvent.requestHelp(
                            HelpTicket(
                              id: const Uuid().v4(),
                              profileId: testUserProfile.id,
                              type: 'test_user_logged',
                              preferredCommunicationChannel: 'email',
                              timestamp: DateTime.now().millisecondsSinceEpoch,
                              isResolved: false,
                              comment: Comment(
                                title: 'New Device Login by Test User at ${DateTime.now().toIso8601String()}',
                                body:
                                    'Hi Admin,\nA new device has logged into the app using a test user account. We wanted to inform you about this activity for your records.\nIf this was expected, no action is needed. However, if you didn\'t authorize this login, please investigate further.\n\n Device:\n - ${device.toString()}\n\n App Package:\n - ${appInfo.toString()}\n\nUser: ${testUserProfile.toJson().toString()} \n\nBest regards,\nVerified.',
                              ),
                              uploads: [],
                              responses: [],
                            ),
                          ),
                        )

                        /// login as test user
                        ..add(StoreEvent.createUserProfile(testUserProfile));

                      /// confirmation
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              showCloseIcon: true,
                              closeIconColor: const Color.fromARGB(255, 254, 226, 226),
                              content: const Text(
                                'Log-in as a Test User!',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 254, 226, 226),
                                ),
                              ),
                              backgroundColor: errorColor,
                            ),
                          ),
                      );

                      ///
                      Navigator.of(context).pop();
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    ///
  } catch (e) {
    print(e);
  }
}
