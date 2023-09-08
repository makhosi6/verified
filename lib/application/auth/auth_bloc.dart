import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.dart';
part 'auth_event.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authProviderRepository) : super(const AuthState.initial()) {
    on((event, emit) => {});
  }

  final Object _authProviderRepository;
}
