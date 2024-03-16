import 'package:flutter/material.dart';
import 'package:verified/presentation/theme.dart';

void navigate(BuildContext context, {required Widget page, bool replaceCurrentPage = false}) {
  try {
    final navigator = replaceCurrentPage ? Navigator.of(context).pushReplacement : Navigator.of(context).push;
    navigator(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => page,
      ),
    );
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: const Text(
            'Navigation failed!',
          ),
          backgroundColor: neutralYellow,
        ),
      );
  }
}
