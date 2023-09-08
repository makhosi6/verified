import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'appbase_state.dart';
part 'appbase_event.dart';
part 'appbase_bloc.freezed.dart';

class AppbaseBloc extends Bloc<AppbaseEvent, AppbaseState> {
  AppbaseBloc(this._appbaseRepository) : super(const AppbaseState.initial()) {
    on((event, emit) => {});
  }

  final Object _appbaseRepository;
}
