part of 'appbase_bloc.dart';

@freezed
class AppbaseEvent with _$AppbaseEvent {
  const factory AppbaseEvent.healthCheck() = HealthCheck;
}
