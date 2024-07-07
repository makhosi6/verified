import 'package:flutter/material.dart';
import 'package:verified/presentation/theme.dart';

void navigate(BuildContext context, {required Widget page, bool replaceCurrentPage = false}) {
  try {
    print('Will navigate to $page');
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

void navigateToNamedRoute(BuildContext context,  { Object? arguments, String routeName = '/capture-details-info', bool replaceCurrentPage = false }) {
  bool isRouteOnTop = ModalRoute.of(context)?.settings.name == routeName;

  if (!isRouteOnTop) {
    print('Will navigate to $routeName');
    final navigator = replaceCurrentPage ? Navigator.popAndPushNamed : Navigator.pushNamed;
    navigator(context, routeName,arguments: arguments);
  } else {
    print('$routeName IS already the top item');
  }
}
