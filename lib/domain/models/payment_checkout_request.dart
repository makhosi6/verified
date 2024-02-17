import 'package:verified/domain/models/payment_metadata.dart';

class PaymentCheckoutRequest {
  PaymentCheckoutRequest({
    this.amount,
    this.currency,
    this.paymentId,
    this.cancelUrl,
    this.successUrl,
    this.failureUrl,
    this.metadata,
    this.totalDiscount,
    this.totalTaxAmount,
    this.subtotalAmount,
    this.lineItems,
    this.processingMode,
  });

  PaymentCheckoutRequest.fromJson(dynamic json) {
    amount = json['amount'];
    currency = json['currency'];
    paymentId = json['paymentId'];
    cancelUrl = json['cancelUrl'];
    successUrl = json['successUrl'];
    failureUrl = json['failureUrl'];
    metadata = json['metadata'] != null ? PaymentMetadata.fromJson(json['metadata']) : null;
    totalDiscount = json['totalDiscount'];
    totalTaxAmount = json['totalTaxAmount'];
    subtotalAmount = json['subtotalAmount'];
    lineItems = json['lineItems'];
  }
  num? amount;
  String? currency = 'ZAR';
  dynamic paymentId;
  dynamic cancelUrl = 'https://verified.byteestudio.com/cancel';
  dynamic successUrl = 'https://verified.byteestudio.com/success';
  dynamic failureUrl = 'https://verified.byteestudio.com/failed';
  PaymentMetadata? metadata;
  dynamic totalDiscount;
  dynamic totalTaxAmount;
  dynamic subtotalAmount;
  dynamic lineItems;
  dynamic processingMode = 'test';
  PaymentCheckoutRequest copyWith({
    num? amount,
    String? currency,
    dynamic paymentId,
    dynamic cancelUrl,
    dynamic successUrl,
    dynamic failureUrl,
    PaymentMetadata? metadata,
    dynamic totalDiscount,
    dynamic totalTaxAmount,
    dynamic subtotalAmount,
    dynamic lineItems,
    dynamic processingMode,
  }) =>
      PaymentCheckoutRequest(
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        paymentId: paymentId ?? this.paymentId,
        cancelUrl: cancelUrl ?? this.cancelUrl,
        successUrl: successUrl ?? this.successUrl,
        failureUrl: failureUrl ?? this.failureUrl,
        metadata: metadata ?? this.metadata,
        totalDiscount: totalDiscount ?? this.totalDiscount,
        totalTaxAmount: totalTaxAmount ?? this.totalTaxAmount,
        subtotalAmount: subtotalAmount ?? this.subtotalAmount,
        lineItems: lineItems ?? this.lineItems,
        processingMode: processingMode ?? this.processingMode,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['amount'] = amount;
    map['currency'] = currency;
    map['paymentId'] = paymentId;
    map['cancelUrl'] = cancelUrl;
    map['successUrl'] = successUrl;
    map['failureUrl'] = failureUrl;
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    map['totalDiscount'] = totalDiscount;
    map['totalTaxAmount'] = totalTaxAmount;
    map['subtotalAmount'] = subtotalAmount;
    map['lineItems'] = lineItems;
    map['processingMode'] = processingMode;
    return map;
  }
}
