import 'package:flutter/foundation.dart';

void verifiedErrorLogger(dynamic error, [StackTrace? stackTrace]) {
  debugPrint('===============START(${error.hashCode})===========================');
  debugPrintStack(stackTrace: stackTrace ?? StackTrace.current, label: error.toString());
  debugPrint('--->\nCENTRAL LOG FUNCTION $error');
  debugPrint('===============END(${error.hashCode})===========================');

}

void verifiedLogger(e) {
  if (kDebugMode) print(e);
}
