import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:verified/domain/interfaces/i_auth_repository.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/infrastructure/auth/local_user.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth authClient;

  AuthRepository(this.authClient);

  @override
  Stream<User?> authStateChanges() => authClient.authStateChanges().map((user) {
        Future.microtask(() async {
          try {
            if (user == null) {
              debugPrint('User is currently signed out!');
            } else {
              debugPrint('User is signed in!');

              var localUser = await LocalUser.getUser();
              LocalUser.setUser(
                UserProfile.fromJson(
                  {
                    "profileId": user.uid,
                    "actualName": user.displayName,
                    "email": user.email,
                    "name": user.displayName,
                    ...localUser!.toJson()
                  },
                ),
              );
            }
          } catch (e) {
            debugPrint(e.toString());
          }
        });
        return user;
      });

  @override
  User? get currentUser => authClient.currentUser;

  @override
  Future<UserCredential> signInAnonymously() async => await signInAnonymously();

  @override
  Future<UserCredential> signInWithPopup(AuthProvider provider) async => await signInWithPopup(provider);

  @override
  Future<UserCredential> signInWithProvider(AuthProvider provider) async => await signInWithProvider(provider);

  @override
  Future<void> signOut() async => await authClient.signOut();
}
