import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/infrastructure/auth/local_user.dart';
import 'package:verified/infrastructure/auth/repository.dart';

part 'auth_state.dart';
part 'auth_event.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authProviderRepository, this._storeBloc) : super(AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      if (state.authStateChanges == null) {
        emit(
          state.copyWith(
            authStateChanges: _authProviderRepository.authStateChanges().asBroadcastStream()
              ..listen((user) {
                try {
                  if (user != null && _storeBloc.state.userProfileData == null) {
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
          throw UnimplementedError();
        },
        signInWithPopup: (e) async {
          throw UnimplementedError();
        },
        signInWithProvider: (e) async {
          emit(state.copyWith(processing: true, error: null, hasError: false));

          final userCredential = await _authProviderRepository.signInWithProvider(e.provider);

          final user = userCredential.user;

          final userProfile = UserProfile.fromJson({
            'id': user?.uid,
            'profileId': user?.uid,
            'email': user?.email,
            'actualName': user?.displayName,
            'displayName': user?.displayName,
            'name': user?.displayName,
            'avatar': user?.photoURL ??
                'https://robohash.org/${(user?.displayName?.replaceAll(" ", "_") ?? user?.uid)?.toLowerCase()}.png',
            // 'walletId': 'logged-in-user-wallet',
            'walletId': null,
            'phone': user?.phoneNumber,
            'dataProvider': user?.providerData.map((e) => e.providerId).toString(),
            'metadata': {
              'creationTime': (user?.metadata.creationTime?.millisecondsSinceEpoch ?? 0) ~/ 1000,
              'lastSignInTime': (user?.metadata.lastSignInTime?.millisecondsSinceEpoch ?? 0) ~/ 1000,
            },
            'active': true,
            'softDeleted': false,
          });
          _storeBloc.add(
            StoreEvent.createUserProfile(userProfile),
          );

          ///
          emit(
            state.copyWith(
              processing: false,
              isLoggedIn: true,
            ),
          );

          ///
          LocalUser.setUser(userProfile);
        },
        interceptStreamedAuthUser: (e) {
          var user = e.user;

          /// set bloc user
          _storeBloc.add(
            StoreEvent.addUser(
              UserProfile.fromJson({
                'id': user?.uid,
                'profileId': user?.uid,
                'email': user?.email,
                'actualName': user?.displayName,
                'displayName': user?.displayName,
                'name': user?.displayName,
                'avatar': user?.photoURL ??
                    'https://robohash.org/${(user?.displayName?.replaceAll(" ", "_") ?? user?.uid)?.toLowerCase()}.png',
                'phone': user?.phoneNumber,
                'dataProvider': user?.providerData.map((e) => e.providerId).toString(),
                'metadata': {
                  'creationTime': (user?.metadata.creationTime?.millisecondsSinceEpoch ?? 0) ~/ 1000,
                  'lastSignInTime': (user?.metadata.lastSignInTime?.millisecondsSinceEpoch ?? 0) ~/ 1000,
                },
                'walletId': null,
                'active': true,
                'softDeleted': false,
              }),
            ),
          );

          ///
          emit(
            state.copyWith(
              isLoggedIn: true,
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
                'avatar': user?.photoURL ??
                    'https://robohash.org/${(user?.displayName?.replaceAll(" ", "_") ?? user?.uid)?.toLowerCase()}.png',
                'phone': user?.phoneNumber,
                // 'walletId': 'logged-in-user-wallet',
                'walletId': null,
                'dataProvider': user?.providerData.map((e) => e.providerId).toString(),
                'metadata': {
                  'creationTime': (user?.metadata.creationTime?.millisecondsSinceEpoch ?? 0) ~/ 1000,
                  'lastSignInTime': (user?.metadata.lastSignInTime?.millisecondsSinceEpoch ?? 0) ~/ 1000,
                },
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
          _storeBloc.add(const StoreEvent.clearUser());
          return null;
        },
      );
    });
  }

  ///
  final AuthRepository _authProviderRepository;

  ///
  final StoreBloc _storeBloc;
}
