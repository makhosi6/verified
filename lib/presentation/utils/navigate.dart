import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/presentation/theme.dart';

void navigate(BuildContext context, {required Widget page, bool replaceCurrentPage = false}) {
  try {
    verifiedLogger('Will navigate to $page');
    if (kReleaseMode) {
      FirebaseAnalytics.instance.logEvent(
        name: 'verified_app_new_page_event',
        parameters: {
          'type': 'NEW_SCREEN',
          'page': '$page',
        },
      );
    }
    final navigator = replaceCurrentPage ? Navigator.of(context).pushReplacement : Navigator.of(context).push;
    navigator(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => page,
      ),
    );
  } catch (error, stackTrace) {
    if (kReleaseMode) {
      FirebaseAnalytics.instance.logEvent(
        name: 'verified_app_failed_page_event',
        parameters: {
          'type': 'NEW_SCREEN',
          'page': error.toString(),
        },
      );
    }
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

void navigateToNamedRoute(BuildContext context,
    {Object? arguments, String routeName = '/captured-details-info', bool replaceCurrentPage = false}) {
  bool isRouteOnTop = ModalRoute.of(context)?.settings.name == routeName;
  if (kReleaseMode) {
    FirebaseAnalytics.instance.logEvent(
      name: 'verified_app_new_page_event',
      parameters: {
        'type': 'NEW_NAMED_SCREEN',
        'page': routeName,
      },
    );
  }
  if (!isRouteOnTop) {
    verifiedLogger('Will navigate to $routeName');
    final navigator = replaceCurrentPage ? Navigator.popAndPushNamed : Navigator.pushNamed;
    navigator(context, routeName, arguments: arguments);
  } else {
    if (kReleaseMode) {
      FirebaseAnalytics.instance.logEvent(
        name: 'verified_app_failed_page_event',
        parameters: {'type': 'NEW_NAMED_SCREEN', 'page': routeName, 'error': '$routeName IS already the top item'},
      );
    }
    verifiedLogger('$routeName IS already the top item');
  }
}
