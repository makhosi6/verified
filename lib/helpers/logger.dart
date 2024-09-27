import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

void verifiedErrorLogger(dynamic error, [StackTrace? stackTrace]) {
  try {
    debugPrint('===============START(${error.hashCode})===========================');
    debugPrintStack(stackTrace: stackTrace ?? StackTrace.current, label: error.toString());
    debugPrint('--->\nCENTRAL LOG FUNCTION $error');
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: error.toString,
      fatal: true,
    );
  } catch (error, stackTrace) {
    debugPrintStack(stackTrace: stackTrace, label: error.toString());
  } finally {
    debugPrint('===============END(${error.hashCode})===========================');
  }
}

void verifiedLogger(e) {
  if (kDebugMode) print(e);
}
