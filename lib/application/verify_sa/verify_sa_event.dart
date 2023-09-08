part of 'verify_sa_bloc.dart';

@freezed
class VerifySaEvent with _$VerifySaEvent {
  const factory VerifySaEvent.apiHealthCheck() = ApiHealthCheck;
}
