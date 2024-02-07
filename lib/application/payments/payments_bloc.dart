import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payments_event.dart';
part 'payments_state.dart';
part 'payments_bloc.freezed.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc() : super(_Initial()) {
    on<PaymentsEvent>((event, emit) {});
  }
}
