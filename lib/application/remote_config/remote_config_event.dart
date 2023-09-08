part of 'remote_config_bloc.dart';

@freezed
class RemoteConfigEvent with _$RemoteConfigEvent {
  const factory RemoteConfigEvent.burstCache() = BurstCache;
}
