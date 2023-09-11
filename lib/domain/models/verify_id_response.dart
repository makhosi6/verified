class VerifyIdResponse {
  VerifyIdResponse({
    this.status,
    this.verification,
  });

  VerifyIdResponse.fromJson(dynamic json) {
    status = json['status'];
    verification = json['verification'] != null
        ? Verification.fromJson(json['verification'])
        : null;
  }
  String? status;
  Verification? verification;
  VerifyIdResponse copyWith({
    String? status,
    Verification? verification,
  }) =>
      VerifyIdResponse(
        status: status ?? this.status,
        verification: verification ?? this.verification,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (verification != null) {
      map['verification'] = verification?.toJson();
    }
    return map;
  }
}

class Verification {
  Verification({
    this.firstnames,
    this.lastname,
    this.dob,
    this.age,
    this.gender,
    this.citizenship,
    this.dateIssued,
  });

  Verification.fromJson(dynamic json) {
    firstnames = json['firstnames'];
    lastname = json['lastname'];
    dob = json['dob'];
    age = json['age'];
    gender = json['gender'];
    citizenship = json['citizenship'];
    dateIssued = json['dateIssued'];
  }
  String? firstnames;
  String? lastname;
  String? dob;
  num? age;
  String? gender;
  String? citizenship;
  String? dateIssued;
  Verification copyWith({
    String? firstnames,
    String? lastname,
    String? dob,
    num? age,
    String? gender,
    String? citizenship,
    String? dateIssued,
  }) =>
      Verification(
        firstnames: firstnames ?? this.firstnames,
        lastname: lastname ?? this.lastname,
        dob: dob ?? this.dob,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        citizenship: citizenship ?? this.citizenship,
        dateIssued: dateIssued ?? this.dateIssued,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstnames'] = firstnames;
    map['lastname'] = lastname;
    map['dob'] = dob;
    map['age'] = age;
    map['gender'] = gender;
    map['citizenship'] = citizenship;
    map['dateIssued'] = dateIssued;
    return map;
  }
}
