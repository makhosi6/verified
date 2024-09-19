import 'package:flutter/material.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/presentation/theme.dart';

void navigate(BuildContext context, {required Widget page, bool replaceCurrentPage = false}) {
  try {
    verifiedLogger('Will navigate to $page');
    final navigator = replaceCurrentPage ? Navigator.of(context).pushReplacement : Navigator.of(context).push;
    navigator(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => page,
      ),
    );
  } catch (error, stackTrace) {
    verifiedErrorLogger(error, stackTrace);
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

void navigateToNamedRoute(BuildContext context,  { Object? arguments, String routeName = '/captured-details-info', bool replaceCurrentPage = false }) {
  bool isRouteOnTop = ModalRoute.of(context)?.settings.name == routeName;

  if (!isRouteOnTop) {
    verifiedLogger('Will navigate to $routeName');
    final navigator = replaceCurrentPage ? Navigator.popAndPushNamed : Navigator.pushNamed;
    navigator(context, routeName,arguments: arguments);
  } else {
    verifiedLogger('$routeName IS already the top item');
  }
}
