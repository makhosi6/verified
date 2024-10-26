class GenericResponse {
  GenericResponse({
    this.status,
    this.code,
    this.id,
    this.data,
  });

  GenericResponse.fromJson(dynamic json) {
    status = json['status'];
    code = json['code'];
    id = json['id'];
    data = json;
  }
  String? status;
  num? code;
  String? id;
  Map<String, dynamic>? data;

  GenericResponse copyWith({
    String? status,
    num? code,
    String? id,
    Map<String, dynamic>? data,
  }) =>
      GenericResponse(
        status: status ?? this.status,
        code: code ?? this.code,
        id: id ?? this.id,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['code'] = code;
    map['id'] = id;
    map['data'] = data;
    return map;
  }
}
