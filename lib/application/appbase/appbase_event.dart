part of 'appbase_bloc.dart';

@freezed
class AppbaseEvent with _$AppbaseEvent {
  const factory AppbaseEvent.healthCheck() = HealthCheck;
  const factory AppbaseEvent.getAppInfo() = GetAppInfo;
  const factory AppbaseEvent.getDeviceInfo() = GetDeviceInfo;
  const factory AppbaseEvent.getDevice() = GetDevice;
}
