import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_sa_state.dart';
part 'verify_sa_event.dart';
part 'verify_sa_bloc.freezed.dart';

class VerifySaBloc extends Bloc<VerifySaEvent, VerifySaState> {
  VerifySaBloc(this._verifySaRepository)
      : super(const VerifySaState.initial()) {
    on((event, emit) => {});
  }

  final Object _verifySaRepository;
}
