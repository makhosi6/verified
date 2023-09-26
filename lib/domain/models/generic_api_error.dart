class GenericApiError {
  GenericApiError({
      this.status, 
      this.error,});

  GenericApiError.fromJson(dynamic json) {
    status = json['Status'];
    error = json['Error'];
  }
  String? status;
  String? error;
GenericApiError copyWith({  String? status,
  String? error,
}) => GenericApiError(  status: status ?? this.status,
  error: error ?? this.error,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = status;
    map['Error'] = error;
    return map;
  }

}