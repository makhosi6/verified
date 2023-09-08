part of 'verify_sa_bloc.dart';

@freezed
class VerifySaState with _$VerifySaState {
  const factory VerifySaState.initial() = _Initial;
  const factory VerifySaState.fetching() = _Fetching;
}
