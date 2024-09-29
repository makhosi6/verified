import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:verified/helpers/logger.dart';

class VerifiedNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is ModalRoute) {
    if (kReleaseMode) {
      FirebaseAnalytics.instance.logEvent(
        name: 'verified_app_navigation_event',
        parameters: {
          'type': 'modal_route',
          'to_name': route.settings.name,
          'from_name': previousRoute?.settings.name,
        },
      );
    }
      verifiedLogger('\n\nModal route opened: ${route.settings.name}');
    } else {
    if (kReleaseMode) {
      FirebaseAnalytics.instance.logEvent(
        name: 'verified_app_navigation_event',
        parameters: {
          'type': 'navigator_route',
          'to_name': route.settings.name,
          'from_name': previousRoute?.settings.name,
        },
      );
    }
      verifiedLogger('\n\nRoute opened: ${route.settings.name}');
    }
  }
}
