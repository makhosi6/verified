import 'package:firebase_auth/firebase_auth.dart';

class VerifiedAuthProvider {
  static final google = GoogleAuthProvider();

  static final apple = AppleAuthProvider();

  static final microsoft = MicrosoftAuthProvider();

  static final twitter = TwitterAuthProvider();

  static final facebook = FacebookAuthProvider();

  static final email = PhoneAuthProvider();
}
