import 'package:flutter/foundation.dart';

void verifiedErrorLogger(dynamic e) {
  debugPrint('CENTRAL LOG FUNCTION');
  debugPrint(e.toString());
  if (kDebugMode) print(e);
}
