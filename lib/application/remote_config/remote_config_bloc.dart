import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_state.dart';
part 'remote_config_event.dart';
part 'remote_config_bloc.freezed.dart';

class RemoteConfigBloc extends Bloc<RemoteConfigEvent, RemoteConfigState> {
  RemoteConfigBloc(this._remoteConfigRepository)
      : super(const RemoteConfigState.initial());

  final Object _remoteConfigRepository;
}
