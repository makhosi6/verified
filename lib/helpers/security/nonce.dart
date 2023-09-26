import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

/// public file used to expose the secret/private function named [_generateNonce].
/// To run the App create the [nonce.private.dart] file.
/// Then create a private function that returns a Future<String>, like, `Future<String> Function() _generateNonce;`
///

part 'nonce.private.dart';

Future<String> generateNonce() async => await _generateNonce();
