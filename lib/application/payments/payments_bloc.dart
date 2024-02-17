import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:verified/domain/interfaces/i_payments_repository.dart';
import 'package:verified/domain/models/generic_api_error.dart';
import 'package:verified/domain/models/payment_checkout_request.dart';
import 'package:verified/domain/models/payment_checkout_response.dart';
import 'package:verified/domain/models/payment_metadata.dart';
import 'package:verified/domain/models/payment_refund_response.dart';

part 'payments_event.dart';
part 'payments_state.dart';
part 'payments_bloc.freezed.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc(
    this._paymentsRepository,
  ) : super(PaymentsState.initial()) {
    on<PaymentsEvent>((event, emit) async => event.map(yocoPayment: (e) async {
          emit(
            state.copyWith(
              paymentDataLoading: true,
              paymentData: null,
              paymentError: null,
              paymentHasError: false,
            ),
          );

          final response = await _paymentsRepository.yocoPayment(e.payment);

          response.fold(
              (error) => {
                    emit(
                      state.copyWith(
                        paymentData: null,
                        paymentDataLoading: false,
                        paymentError: error,
                        paymentHasError: true,
                      ),
                    )
                  },
              (data) => {
                    emit(
                      state.copyWith(
                        paymentData: data,
                        paymentDataLoading: true,
                        paymentError: null,
                        paymentHasError: false,
                      ),
                    )
                  });

          return null;
        }, yocoRefund: (e) async {
          emit(
            state.copyWith(
              refundDataLoading: true,
              refundError: null,
              refundHasError: false,
            ),
          );

          final response = await _paymentsRepository.yocoRefund(e.refund);

          response.fold(
              (error) => {
                    emit(
                      state.copyWith(
                        refundData: null,
                        refundDataLoading: false,
                        refundError: error,
                        refundHasError: true,
                      ),
                    )
                  },
              (data) => {
                    emit(
                      state.copyWith(
                        refundData: data,
                        refundDataLoading: true,
                        refundError: null,
                        refundHasError: false,
                      ),
                    )
                  });
          return null;
        }));
  }

  ///
  final IPaymentsRepository _paymentsRepository;
}
