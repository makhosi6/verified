part of 'payments_bloc.dart';

@freezed
class PaymentsEvent with _$PaymentsEvent {
  const factory PaymentsEvent.yocoPayment(PaymentCheckoutRequest payment) = YocoPayment;
  const factory PaymentsEvent.yocoRefund(PaymentMetadata refund) = YocoRefund;
}
