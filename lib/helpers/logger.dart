import 'package:flutter/foundation.dart';

void verifiedErrorLogger(dynamic e) {
  debugPrint('CENTRAL LOG FUNCTION $e');
  debugPrint(e.toString());
  if (kDebugMode) print(e);
}

void verifiedLogger(e) => {if (kDebugMode) print(e)};
