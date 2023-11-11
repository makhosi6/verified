import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/infrastructure/auth/local_user.dart';
import 'package:verified/infrastructure/auth/repository.dart';
import 'package:verified/infrastructure/store/repository.dart';

part 'auth_state.dart';
part 'auth_event.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authProviderRepository, this._storeRepository) : super(AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      if (state.authStateChanges == null) {
        emit(
          state.copyWith(
            authStateChanges: _authProviderRepository.authStateChanges().asBroadcastStream()
              ..listen((user) {
                try {
                  if (user != null && state.userProfile == null) {
                    ///

                    add(AuthEvent.interceptStreamedAuthUser(user));
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              }),
          ),
        );
      }
      await event.map(
        signOut: (e) async {
          emit(state.copyWith(processing: true, error: null, hasError: false));
          // sign out
          await _authProviderRepository.signOut();

          // clear local data
          await LocalUser.clearUser();

          // update the state
          emit(AuthState.initial());
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
                'id': user?.uid,
                'profileId': user?.uid,
                'email': user?.email,
                'actualName': user?.displayName,
                'displayName': user?.displayName,
                'name': user?.displayName,
                'avatar': user?.photoURL,
                'phone': user?.phoneNumber,
                'dataProvider': user?.providerData,
                'active': true,
                'softDeleted': false,
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
                'id': user?.uid,
                'profileId': user?.uid,
                'email': user?.email,
                'actualName': user?.displayName,
                'displayName': user?.displayName,
                'name': user?.displayName,
                'avatar': user?.photoURL,
                'phone': user?.phoneNumber,
                'dataProvider': user?.providerData,
                'active': true,
                'softDeleted': false,
                // if (state.userProfile is UserProfile) ...state.userProfile!.toJson()
              }),
            ),
          );
          return null;
        },
        signInWithProvider: (e) async {
          emit(state.copyWith(processing: true, error: null, hasError: false));

          final userCredential = await _authProviderRepository.signInWithProvider(e.provider);

          final user = userCredential.user;

          await _storeRepository
              .postUserProfile(
                UserProfile.fromJson({
                  'id': user?.uid,
                  'profileId': user?.uid,
                  'email': user?.email,
                  'actualName': user?.displayName,
                  'displayName': user?.displayName,
                  'name': user?.displayName,
                  'avatar': user?.photoURL,
                  'phone': user?.phoneNumber,
                  'dataProvider': user?.providerData,
                  'active': true,
                  'softDeleted': false,
                  // if (state.userProfile is UserProfile) ...state.userProfile!.toJson()
                }),
              )
              .then((userProfile) => {
                    userProfile.fold(
                        (err) => emit(
                              state.copyWith(
                                processing: false,
                                isLoggedIn: true,
                                user: userCredential.user,
                                userProfile: UserProfile.fromJson({
                                  'id': user?.uid,
                                  'profileId': user?.uid,
                                  'email': user?.email,
                                  'actualName': user?.displayName,
                                  'displayName': user?.displayName,
                                  'name': user?.displayName,
                                  'avatar': user?.photoURL,
                                  'phone': user?.phoneNumber,
                                  'dataProvider': user?.providerData,
                                  'active': true,
                                  'softDeleted': false,
                                  // if (state.userProfile is UserProfile) ...state.userProfile!.toJson()
                                }),
                              ),
                            ), (data) {
                      ///
                      emit(
                        state.copyWith(
                          processing: false,
                          isLoggedIn: true,
                          user: userCredential.user,
                          userProfile: data,
                        ),
                      );

                      ///
                      LocalUser.setUser(data);
                    })
                  });
        },
        addUserFromStore: (e) {
          var userProfile = e.user;
          if (userProfile != null) {
            emit(
              state.copyWith(
                processing: false,
                isLoggedIn: true,
                userProfile: userProfile,
              ),
            );
          }
        },
        interceptStreamedAuthUser: (e) {
          var user = e.user;

          /// set bloc user
          emit(
            state.copyWith(
              isLoggedIn: true,
              user: user,
              userProfile: UserProfile.fromJson({
                'id': user?.uid,
                'profileId': user?.uid,
                'email': user?.email,
                'actualName': user?.displayName,
                'displayName': user?.displayName,
                'name': user?.displayName,
                'avatar': user?.photoURL,
                'phone': user?.phoneNumber,
                'dataProvider': user?.providerData,
                'active': true,
                'softDeleted': false,
                // if (state.userProfile is UserProfile) ...state.userProfile!.toJson()
              }),
            ),
          );

          ///set local user
          LocalUser.setUser(
            UserProfile.fromJson(
              {
                'id': user?.uid,
                'profileId': user?.uid,
                'email': user?.email,
                'actualName': user?.displayName,
                'displayName': user?.displayName,
                'name': user?.displayName,
                'avatar': user?.photoURL,
                'phone': user?.phoneNumber,
                'dataProvider': user?.providerData,
                'active': true,
                'softDeleted': false,
              },
            ),
          );
        },
        deleteAccount: (e) async {
          emit(state.copyWith(processing: true, error: null, hasError: false));
          // sign out
          await _authProviderRepository.signOut();
          // clear local data
          await LocalUser.clearUser();

          // update the state
          emit(AuthState.initial());
          return null;
        },
      );
    });
  }

  ///
  final AuthRepository _authProviderRepository;

  ///
  final StoreRepository _storeRepository;
}
