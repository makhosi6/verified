class PaymentRefundResponse {
  PaymentRefundResponse({
    this.id,
    this.refundId,
    this.message,
    this.description,
    this.status,
  });

  PaymentRefundResponse.fromJson(dynamic json) {
    id = json['id'];
    refundId = json['refundId'];
    message = json['message'];
    description = json['description'];
    status = json['status'];
  }
  String? id;
  String? refundId;
  String? message;
  String? description;
  String? status;
  PaymentRefundResponse copyWith({
    String? id,
    String? refundId,
    String? message,
    String? description,
    String? status,
  }) =>
      PaymentRefundResponse(
        id: id ?? this.id,
        refundId: refundId ?? this.refundId,
        message: message ?? this.message,
        description: description ?? this.description,
        status: status ?? this.status,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['refundId'] = refundId;
    map['message'] = message;
    map['description'] = description;
    map['status'] = status;
    return map;
  }
}
