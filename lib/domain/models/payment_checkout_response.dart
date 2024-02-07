import 'package:verified/domain/models/payment_metadata.dart';

class PaymentCheckoutResponse {
  PaymentCheckoutResponse({
    this.id,
    this.redirectUrl,
    this.status,
    this.amount,
    this.currency,
    this.paymentId,
    this.cancelUrl,
    this.successUrl,
    this.failureUrl,
    this.metadata,
    this.merchantId,
    this.totalDiscount,
    this.totalTaxAmount,
    this.subtotalAmount,
    this.lineItems,
    this.externalId,
    this.processingMode,
  });

  PaymentCheckoutResponse.fromJson(dynamic json) {
    id = json['id'];
    redirectUrl = json['redirectUrl'];
    status = json['status'];
    amount = json['amount'];
    currency = json['currency'];
    paymentId = json['paymentId'];
    cancelUrl = json['cancelUrl'];
    successUrl = json['successUrl'];
    failureUrl = json['failureUrl'];
    metadata = json['metadata'] != null ? PaymentMetadata.fromJson(json['metadata']) : null;
    merchantId = json['merchantId'];
    totalDiscount = json['totalDiscount'];
    totalTaxAmount = json['totalTaxAmount'];
    subtotalAmount = json['subtotalAmount'];
    lineItems = json['lineItems'];
    externalId = json['externalId'];
    processingMode = json['processingMode'];
  }
  String? id;
  String? redirectUrl;
  String? status;
  num? amount;
  String? currency;
  dynamic paymentId;
  dynamic cancelUrl;
  dynamic successUrl;
  dynamic failureUrl;
  PaymentMetadata? metadata;
  String? merchantId;
  dynamic totalDiscount;
  dynamic totalTaxAmount;
  dynamic subtotalAmount;
  dynamic lineItems;
  dynamic externalId;
  String? processingMode;
  PaymentCheckoutResponse copyWith({
    String? id,
    String? redirectUrl,
    String? status,
    num? amount,
    String? currency,
    dynamic paymentId,
    dynamic cancelUrl,
    dynamic successUrl,
    dynamic failureUrl,
    PaymentMetadata? metadata,
    String? merchantId,
    dynamic totalDiscount,
    dynamic totalTaxAmount,
    dynamic subtotalAmount,
    dynamic lineItems,
    dynamic externalId,
    String? processingMode,
  }) =>
      PaymentCheckoutResponse(
        id: id ?? this.id,
        redirectUrl: redirectUrl ?? this.redirectUrl,
        status: status ?? this.status,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        paymentId: paymentId ?? this.paymentId,
        cancelUrl: cancelUrl ?? this.cancelUrl,
        successUrl: successUrl ?? this.successUrl,
        failureUrl: failureUrl ?? this.failureUrl,
        metadata: metadata ?? this.metadata,
        merchantId: merchantId ?? this.merchantId,
        totalDiscount: totalDiscount ?? this.totalDiscount,
        totalTaxAmount: totalTaxAmount ?? this.totalTaxAmount,
        subtotalAmount: subtotalAmount ?? this.subtotalAmount,
        lineItems: lineItems ?? this.lineItems,
        externalId: externalId ?? this.externalId,
        processingMode: processingMode ?? this.processingMode,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['redirectUrl'] = redirectUrl;
    map['status'] = status;
    map['amount'] = amount;
    map['currency'] = currency;
    map['paymentId'] = paymentId;
    map['cancelUrl'] = cancelUrl;
    map['successUrl'] = successUrl;
    map['failureUrl'] = failureUrl;
    if (metadata != null) {
      map['metadata'] = metadata?.toJson();
    }
    map['merchantId'] = merchantId;
    map['totalDiscount'] = totalDiscount;
    map['totalTaxAmount'] = totalTaxAmount;
    map['subtotalAmount'] = subtotalAmount;
    map['lineItems'] = lineItems;
    map['externalId'] = externalId;
    map['processingMode'] = processingMode;
    return map;
  }
}
