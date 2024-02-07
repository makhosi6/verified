part of 'payments_bloc.dart';

@freezed
class PaymentsEvent with _$PaymentsEvent {
  const factory PaymentsEvent.checkout() = CheckOut;
}
