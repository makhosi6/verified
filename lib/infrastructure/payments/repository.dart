import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:verified/domain/interfaces/i_payments_repository.dart';
import 'package:verified/domain/models/generic_api_error.dart';
import 'package:verified/domain/models/payment_checkout_request.dart';
import 'package:verified/domain/models/payment_checkout_response.dart';
import 'package:verified/domain/models/payment_metadata.dart';
import 'package:verified/domain/models/payment_refund_response.dart';
import 'package:verified/services/dio.dart';

class PaymentsRepository implements IPaymentsRepository {
  final Dio _httpClient;

  PaymentsRepository(this._httpClient);

  @override
  Future<Either<GenericApiError, PaymentCheckoutResponse>> yocoPayment(PaymentCheckoutRequest payment) async {
    try {
      final response = await _httpClient.post(
        '/payment/yoco',
        data: payment.toJson(),
      );

      if (httpRequestIsSuccess(response.statusCode)) {
        return right(PaymentCheckoutResponse.fromJson(response.data));
      } else {
        return left(
          GenericApiError(
            status: 'unknown',
            error: 'Unknown http error occurred',
          ),
        );
      }
    } catch (e) {
      return left(
        GenericApiError(
          status: 'unknown',
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<GenericApiError, PaymentRefundResponse>> yocoRefund(PaymentMetadata refund) async {
    try {
      final response = await _httpClient.post(
        '/refund/yoco/${refund.checkoutId}',
        data: refund.toJson(),
      );

      if (httpRequestIsSuccess(response.statusCode)) {
        return right(PaymentRefundResponse.fromJson(response.data));
      } else {
        return left(
          GenericApiError(
            status: 'unknown',
            error: 'Unknown http error occurred',
          ),
        );
      }
    } catch (e) {
      return left(
        GenericApiError(
          status: 'unknown',
          error: e.toString(),
        ),
      );
    }
  }
}
