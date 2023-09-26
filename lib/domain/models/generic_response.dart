class GenericResponse {
  GenericResponse({
    this.status,
    this.code,
  });

  GenericResponse.fromJson(dynamic json) {
    status = json['status'];
    code = json['code'];
  }
  String? status;
  num? code;
  GenericResponse copyWith({
    String? status,
    num? code,
  }) =>
      GenericResponse(
        status: status ?? this.status,
        code: code ?? this.code,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['code'] = code;
    return map;
  }
}
