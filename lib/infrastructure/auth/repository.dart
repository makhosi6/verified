import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:verified/domain/interfaces/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth authClient;

  AuthRepository(this.authClient);

  @override
  Stream<User?> authStateChanges() => authClient.authStateChanges();

  @override
  User? get currentUser => authClient.currentUser;

  @override
  Future<UserCredential> signInAnonymously() async => await authClient.signInAnonymously();

  @override
  Future<UserCredential> signInWithPopup(AuthProvider provider) async => await authClient.signInWithPopup(provider);

  @override
  Future<UserCredential> signInWithProvider(AuthProvider provider) async =>
      await authClient.signInWithProvider(provider);

  @override
  Future<void> signOut() async => await authClient.signOut();
}
