class VerifeeRequest {
  VerifeeRequest({
    this.image,
    this.preferredName,
    this.phoneNumber,
    this.email,
    this.description,
    this.idNumber,
  });

  VerifeeRequest.fromJson(dynamic json) {
    image = json['image'];
    preferredName = json['preferredName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    description = json['description'];
    idNumber = json['idNumber'];
  }
  String? image;
  String? preferredName;
  String? idNumber;
  String? phoneNumber;
  String? email;
  String? description;
  VerifeeRequest copyWith({
    String? image,
    String? preferredName,
    String? phoneNumber,
    String? email,
    String? description,
    String? idNumber,
  }) =>
      VerifeeRequest(
        image: image ?? this.image,
        preferredName: preferredName ?? this.preferredName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        description: description ?? this.description,
        idNumber: idNumber ?? this.idNumber,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = image;
    map['preferredName'] = preferredName;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['description'] = description;
    map['idNumber'] = idNumber;
    return map;
  }
}
