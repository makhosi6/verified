part of 'payments_bloc.dart';

@freezed
class PaymentsState with _$PaymentsState {
  factory PaymentsState({
    // payment
    required GenericApiError? paymentError,
    required bool paymentHasError,
    required bool paymentDataLoading,
    required PaymentCheckoutResponse? paymentData,
    // refund
    required GenericApiError? refundError,
    required bool refundHasError,
    required bool refundDataLoading,
    required PaymentRefundResponse? refundData,
  }) = _PaymentsState;

  factory PaymentsState.initial() => PaymentsState(
        ///
        paymentError: null,
        paymentHasError: false,
        paymentDataLoading: false,
        paymentData: null,

        ///
        refundHasError: false,
        refundDataLoading: false,
        refundError: null,
        refundData: null,
      );
}
