/// public file used to expose the secret/private name [_generateNonce] function.
/// To run the App create the [nonce.private.dart] file.
/// Then create a private function that returns a Future<String>, like, `Future<String> Function();`
///

part of 'nonce.private.dart';

Future<String> generateNonce() async => await _generateNonce();
