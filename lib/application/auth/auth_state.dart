part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required bool isLoggedIn,
    required bool processing,
    // required User? user,
    // required UserProfile? userProfile,
    required Object? error,
    required bool hasError,
    required Stream<User?>? authStateChanges,
  }) = _AuthState;

  factory AuthState.initial() => const AuthState(
        isLoggedIn: false,
        // userProfile: null,
        // user: null,
        processing: false,
        error: null,
        hasError: false,
        authStateChanges: null,
      );
}
