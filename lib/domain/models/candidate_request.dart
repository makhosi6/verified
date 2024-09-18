class CandidateRequest {
  CandidateRequest({
    this.jobUuid,
    this.image,
    this.preferredName,
    this.phoneNumber,
    this.email,
    this.description,
    this.idNumber,
    this.nationality,
  });

  CandidateRequest.fromJson(dynamic json) {
    jobUuid = json['jobUuid'];
    image = json['image'];
    preferredName = json['preferredName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    description = json['description'];
    idNumber = json['idNumber'];
    nationality = json['nationality'];
  }
  String? jobUuid;
  String? image;
  String? preferredName;
  String? idNumber;
  String? phoneNumber;
  String? email;
  String? description;
  String? nationality;
  CandidateRequest copyWith({
    String? jobUuid,
    String? image,
    String? preferredName,
    String? phoneNumber,
    String? email,
    String? description,
    String? idNumber,
    String? nationality,
  }) =>
      CandidateRequest(
        jobUuid: jobUuid ?? this.jobUuid,
        image: image ?? this.image,
        preferredName: preferredName ?? this.preferredName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        description: description ?? this.description,
        idNumber: idNumber ?? this.idNumber,
        nationality: nationality ?? this.nationality,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['jobUuid'] = jobUuid;
    map['image'] = image;
    map['preferredName'] = preferredName;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['description'] = description;
    map['idNumber'] = idNumber;
    map['nationality'] = nationality;
    return map;
  }
}
