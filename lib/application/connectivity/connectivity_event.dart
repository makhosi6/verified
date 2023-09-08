part of 'connectivity_bloc.dart';

@freezed
class ConnectivityEvent with _$ConnectivityEvent {
  const factory ConnectivityEvent.getStatus() = GetStatus;
  const factory ConnectivityEvent.streamStatus() = StreamStatus;
}
