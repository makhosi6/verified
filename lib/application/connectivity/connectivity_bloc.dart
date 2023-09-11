import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'connectivity_state.dart';
part 'connectivity_event.dart';
part 'connectivity_bloc.freezed.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc(this._connectivityRepository)
      : super(const ConnectivityState.initial()) {
    on((event, emit) => {});
  }

  final Object _connectivityRepository;
}
