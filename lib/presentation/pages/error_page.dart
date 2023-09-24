import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:verify_sa/presentation/theme.dart';
import 'package:verify_sa/presentation/widgets/buttons/base_buttons.dart';

class VerifiedErrorPage extends StatelessWidget {
  const VerifiedErrorPage({
    super.key,
    this.message,
  });
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kDebugMode ? AppBar() : null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "🙁",
              style: TextStyle(fontSize: 30),
            ),
            Text(message ?? "Error Occurred"),
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
                      label: "Refresh",
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
                      label: "Close",
                      color: warningColor,
                      onTap: () {}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
