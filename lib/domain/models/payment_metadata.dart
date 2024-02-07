class PaymentMetadata {
  PaymentMetadata({
    this.checkoutId,
    this.paymentFacilitator,
    this.payerId,
    this.walletId,
    this.amount,
    this.transactionId,
  });

  PaymentMetadata.fromJson(dynamic json) {
    checkoutId = json['checkoutId'];
    paymentFacilitator = json['paymentFacilitator'];
    payerId = json['payerId'];
    walletId = json['walletId'];
    amount = json['amount'];
    transactionId = json['transactionId'];
  }
  String? checkoutId;
  String? paymentFacilitator;
  String? payerId;
  String? walletId;
  String? amount;
  String? transactionId;
  PaymentMetadata copyWith({
    String? checkoutId,
    String? paymentFacilitator,
    String? payerId,
    String? walletId,
    String? amount,
    String? transactionId,
  }) =>
      PaymentMetadata(
        checkoutId: checkoutId ?? this.checkoutId,
        paymentFacilitator: paymentFacilitator ?? this.paymentFacilitator,
        payerId: payerId ?? this.payerId,
        walletId: walletId ?? this.walletId,
        amount: amount ?? this.amount,
        transactionId: transactionId ?? this.transactionId,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['checkoutId'] = checkoutId;
    map['paymentFacilitator'] = paymentFacilitator;
    map['payerId'] = payerId;
    map['walletId'] = walletId;
    map['amount'] = amount;
    map['transactionId'] = transactionId;
    return map;
  }
}
