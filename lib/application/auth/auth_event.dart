part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signOut() = SignOut;
  const factory AuthEvent.signInAnonymously() = SignInAnonymously;
  const factory AuthEvent.signInWithPopup(AuthProvider provider) = SignInWithPopup;
  const factory AuthEvent.signInWithProvider(AuthProvider provider) = SignInWithProvider;
}
