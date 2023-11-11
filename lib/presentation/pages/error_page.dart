import 'package:flutter/material.dart';
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
                        iconBgColor: errorColor,
                        buttonIcon: const Icon(
                          Icons.replay_circle_filled_outlined,
                          color: Colors.white,
                        ),
                        hasBorderLining: true,
                        buttonSize: ButtonSize.small,
                        label: 'Refresh',
                        color: errorColor,
                        onTap: () {}),
                    BaseButton(
                        iconBgColor: warningColor,
                        buttonIcon: const Icon(
                          Icons.close_outlined,
                          color: Colors.white,
                        ),
                        hasBorderLining: true,
                        buttonSize: ButtonSize.small,
                        label: 'Close',
                        color: warningColor,
                        onTap: () {}),
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
