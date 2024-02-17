import 'package:dartz/dartz.dart';
import 'package:verified/domain/models/generic_api_error.dart';
import 'package:verified/domain/models/payment_checkout_request.dart';
import 'package:verified/domain/models/payment_checkout_response.dart';
import 'package:verified/domain/models/payment_metadata.dart';
import 'package:verified/domain/models/payment_refund_response.dart';

abstract class IPaymentsRepository {
  ///
  Future<Either<GenericApiError, PaymentCheckoutResponse>> yocoPayment(PaymentCheckoutRequest payment);
  Future<Either<GenericApiError, PaymentRefundResponse>> yocoRefund(PaymentMetadata refund);
}
