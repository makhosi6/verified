class DhaImageResponse {
  DhaImageResponse({
    this.status,
    this.realTimeResults,
    this.transactionId,
  });

  DhaImageResponse.fromJson(dynamic json) {
    status = json['Status'];
    realTimeResults = json['realTimeResults'] != null ? RealTimeResults.fromJson(json['realTimeResults']) : null;
    transactionId = json['transaction_id'];
  }
  String? status;
  RealTimeResults? realTimeResults;
  String? transactionId;
  DhaImageResponse copyWith({
    String? status,
    RealTimeResults? realTimeResults,
    String? transactionId,
  }) =>
      DhaImageResponse(
        status: status ?? this.status,
        realTimeResults: realTimeResults ?? this.realTimeResults,
        transactionId: transactionId ?? this.transactionId,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = status;
    if (realTimeResults != null) {
      map['realTimeResults'] = realTimeResults?.toJson();
    }
    map['transaction_id'] = transactionId;
    return map;
  }
}

class RealTimeResults {
  RealTimeResults({
    this.iDPhoto,
    this.idNumber,
    this.inputIdno,
    this.haIdno,
    this.idnoMatchStatus,
    this.haIdBookIssuedDate,
    this.idCardInd,
    this.idCardDate,
    this.idBlocked,
    this.firstNames,
    this.surname,
    this.dob,
    this.age,
    this.gender,
    this.citizenship,
    this.countryofBirth,
    this.deceasedStatus,
    this.deceasedDate,
    this.maritalStatus,
    this.marriageDate,
  });

  RealTimeResults.fromJson(dynamic json) {
    iDPhoto = json['IDPhoto'];
    idNumber = json['idNumber'];
    inputIdno = json['inputIdno'];
    haIdno = json['haIdno'];
    idnoMatchStatus = json['idnoMatchStatus'];
    haIdBookIssuedDate = json['haIdBookIssuedDate'];
    idCardInd = json['idCardInd'];
    idCardDate = json['idCardDate'];
    idBlocked = json['idBlocked'];
    firstNames = json['firstNames'];
    surname = json['surname'];
    dob = json['dob'];
    age = json['age'];
    gender = json['gender'];
    citizenship = json['citizenship'];
    countryofBirth = json['countryofBirth'];
    deceasedStatus = json['deceasedStatus'];
    deceasedDate = json['deceasedDate'];
    maritalStatus = json['maritalStatus'];
    marriageDate = json['marriageDate'];
  }
  String? iDPhoto;
  String? idNumber;
  String? inputIdno;
  String? haIdno;
  String? idnoMatchStatus;
  String? haIdBookIssuedDate;
  String? idCardInd;
  String? idCardDate;
  String? idBlocked;
  String? firstNames;
  String? surname;
  String? dob;
  num? age;
  String? gender;
  String? citizenship;
  String? countryofBirth;
  String? deceasedStatus;
  String? deceasedDate;
  String? maritalStatus;
  String? marriageDate;
  RealTimeResults copyWith({
    String? iDPhoto,
    String? idNumber,
    String? inputIdno,
    String? haIdno,
    String? idnoMatchStatus,
    String? haIdBookIssuedDate,
    String? idCardInd,
    String? idCardDate,
    String? idBlocked,
    String? firstNames,
    String? surname,
    String? dob,
    num? age,
    String? gender,
    String? citizenship,
    String? countryofBirth,
    String? deceasedStatus,
    String? deceasedDate,
    String? maritalStatus,
    String? marriageDate,
  }) =>
      RealTimeResults(
        iDPhoto: iDPhoto ?? this.iDPhoto,
        idNumber: idNumber ?? this.idNumber,
        inputIdno: inputIdno ?? this.inputIdno,
        haIdno: haIdno ?? this.haIdno,
        idnoMatchStatus: idnoMatchStatus ?? this.idnoMatchStatus,
        haIdBookIssuedDate: haIdBookIssuedDate ?? this.haIdBookIssuedDate,
        idCardInd: idCardInd ?? this.idCardInd,
        idCardDate: idCardDate ?? this.idCardDate,
        idBlocked: idBlocked ?? this.idBlocked,
        firstNames: firstNames ?? this.firstNames,
        surname: surname ?? this.surname,
        dob: dob ?? this.dob,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        citizenship: citizenship ?? this.citizenship,
        countryofBirth: countryofBirth ?? this.countryofBirth,
        deceasedStatus: deceasedStatus ?? this.deceasedStatus,
        deceasedDate: deceasedDate ?? this.deceasedDate,
        maritalStatus: maritalStatus ?? this.maritalStatus,
        marriageDate: marriageDate ?? this.marriageDate,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['IDPhoto'] = iDPhoto;
    map['idNumber'] = idNumber;
    map['inputIdno'] = inputIdno;
    map['haIdno'] = haIdno;
    map['idnoMatchStatus'] = idnoMatchStatus;
    map['haIdBookIssuedDate'] = haIdBookIssuedDate;
    map['idCardInd'] = idCardInd;
    map['idCardDate'] = idCardDate;
    map['idBlocked'] = idBlocked;
    map['firstNames'] = firstNames;
    map['surname'] = surname;
    map['dob'] = dob;
    map['age'] = age;
    map['gender'] = gender;
    map['citizenship'] = citizenship;
    map['countryofBirth'] = countryofBirth;
    map['deceasedStatus'] = deceasedStatus;
    map['deceasedDate'] = deceasedDate;
    map['maritalStatus'] = maritalStatus;
    map['marriageDate'] = marriageDate;
    return map;
  }
}
