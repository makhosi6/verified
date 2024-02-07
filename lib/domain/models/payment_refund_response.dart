class PaymentRefundResponse {
  PaymentRefundResponse({
      this.id, 
      this.refundId, 
      this.message, 
      this.status,});

  PaymentRefundResponse.fromJson(dynamic json) {
    id = json['id'];
    refundId = json['refundId'];
    message = json['message'];
    status = json['status'];
  }
  String? id;
  String? refundId;
  String? message;
  String? status;
PaymentRefundResponse copyWith({  String? id,
  String? refundId,
  String? message,
  String? status,
}) => PaymentRefundResponse(  id: id ?? this.id,
  refundId: refundId ?? this.refundId,
  message: message ?? this.message,
  status: status ?? this.status,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['refundId'] = refundId;
    map['message'] = message;
    map['status'] = status;
    return map;
  }

}