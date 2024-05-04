import 'package:firebase_auth/firebase_auth.dart';
import 'package:verified/domain/interfaces/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth _authClient;

  AuthRepository(this._authClient);

  @override
  Stream<User?> authStateChanges() => _authClient.authStateChanges();

  @override
  User? get currentUser => _authClient.currentUser;

  @override
  Future<UserCredential> signInAnonymously() async => await _authClient.signInAnonymously();

  @override
  Future<UserCredential> signInWithPopup(AuthProvider provider) async => await _authClient.signInWithPopup(provider);

  @override
  Future<UserCredential> signInWithProvider(AuthProvider provider) async =>
      await _authClient.signInWithProvider(provider);

  @override
  Future<void> signOut() async => await _authClient.signOut();
}
