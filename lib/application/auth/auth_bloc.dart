import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/infrastructure/auth/repository.dart';

part 'auth_state.dart';
part 'auth_event.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authProviderRepository) : super(AuthState.initial()) {
    on<AuthEvent>((event, emit) {
      if (state.authStateChanges == null) {
        emit(state.copyWith(authStateChanges: _authProviderRepository.authStateChanges()));
      }
      event.map(
        signOut: (e) async {
          emit(state.copyWith(processing: true, error: null, hasError: false));
          await _authProviderRepository.signOut().then((_) {
            emit(
              state.copyWith(
                isLoggedIn: false,
                processing: false,
                user: null,
                userProfile: null,
              ),
            );
          }).onError(
            (error, stackTrace) {
              emit(
                state.copyWith(
                  error: error,
                  hasError: true,
                ),
              );
            },
          );

          return null;
        },
        signInAnonymously: (e) async {
          emit(state.copyWith(processing: true, error: null, hasError: false));

          final userCredential = await _authProviderRepository.signInAnonymously();

          final user = userCredential.user;
          emit(
            state.copyWith(
              isLoggedIn: true,
              user: userCredential.user,
              userProfile: UserProfile.fromJson({
                "profileId": user?.uid ?? 'user',
                "actualName": user?.displayName,
                "email": user?.email,
                "name": user?.displayName,
              }),
            ),
          );

          return null;
        },
        signInWithPopup: (e) async {
          emit(state.copyWith(processing: true, error: null, hasError: false));

          final userCredential = await _authProviderRepository.signInWithPopup(e.provider);

          final user = userCredential.user;
          emit(
            state.copyWith(
              isLoggedIn: true,
              user: userCredential.user,
              userProfile: UserProfile.fromJson({
                "profileId": user?.uid ?? 'user',
                "actualName": user?.displayName,
                "email": user?.email,
                "name": user?.displayName,
              }),
            ),
          );
          return null;
        },
        signInWithProvider: (e) async {
          emit(state.copyWith(processing: true, error: null, hasError: false));

          final userCredential = await _authProviderRepository.signInWithProvider(e.provider);

          final user = userCredential.user;
          emit(
            state.copyWith(
              isLoggedIn: true,
              user: userCredential.user,
              userProfile: UserProfile.fromJson({
                "profileId": user?.uid ?? 'user',
                "actualName": user?.displayName,
                "email": user?.email,
                "name": user?.displayName,
              }),
            ),
          );
          return null;
        },
      );
    });
  }

  final AuthRepository _authProviderRepository;
}
