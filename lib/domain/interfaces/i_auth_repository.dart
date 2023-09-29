import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

abstract class IAuthRepository {
  User? get currentUser;

  Stream<User?> authStateChanges();

  Future<void> signOut();

  Future<UserCredential> signInWithProvider(AuthProvider provider);

  Future<UserCredential> signInWithPopup(AuthProvider provider);

  Future<UserCredential> signInAnonymously();
}
