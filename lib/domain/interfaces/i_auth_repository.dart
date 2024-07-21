import 'package:firebase_auth/firebase_auth.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/domain/models/verified_web_auth_user.dart';

abstract class IAuthRepository {
  User? get currentUser;

  Stream<User?> authStateChanges();

  Future<void> signOut();

  Future<void> webDeleteAccount(AuthUserDetails data);

  Future<UserProfile?> storeLoginRequest(AuthUserDetails data);

  Future<VerifiedWebUser?> webSignIn(AuthUserDetails data);

  Future<VerifiedWebUser?> webSignUp(AuthUserDetails data, VerifiedWebUser user);

  Future<UserCredential> signInWithProvider(AuthProvider provider);

  Future<UserCredential> signInWithPopup(AuthProvider provider);

  Future<UserCredential> signInAnonymously();
}
