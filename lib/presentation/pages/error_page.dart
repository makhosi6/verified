import 'package:flutter/material.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/infrastructure/native_scripts/main.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

class VerifiedErrorPage extends StatelessWidget {
  const VerifiedErrorPage({
    super.key,
    this.message,
  });
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: primaryPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🙁\n',
                style: TextStyle(fontSize: 30),
              ),
              Text(message ?? 'Error Occurred'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  children: [
                    BaseButton(
                      iconBgColor: warningColor,
                      buttonIcon: const Icon(
                        Icons.replay_circle_filled_outlined,
                        color: Colors.white,
                      ),
                      hasBorderLining: true,
                      buttonSize: ButtonSize.small,
                      label: 'Refresh',
                      color: warningColor,
                      onTap: () {
                        VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_REFRESH_APP_FROM_ERROR_PAGE);
                        VerifiedAppNativeCalls.restartApp();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: primaryPadding.top),
                      child: BaseButton(
                        iconBgColor: errorColor,
                        buttonIcon: const Icon(
                          Icons.close_outlined,
                          color: Colors.white,
                        ),
                        hasBorderLining: true,
                        buttonSize: ButtonSize.small,
                        label: 'Close',
                        color: errorColor,
                        onTap: () {
                          VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_CLOSE_APP_FROM_ERROR_PAGE);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
