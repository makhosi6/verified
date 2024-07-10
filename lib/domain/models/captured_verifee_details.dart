import 'dart:convert';

import 'package:mrz_parser/mrz_parser.dart';

class CapturedVerifeeDetails {
  String? surname;
  String? names;
  String? sex;
  String? nationality;
  String? identityNumber;
  String? identityNumber2;
  String? passportNumber;
  String? dayOfBirth;
  String? countryOfBirth;
  String? status;
  String? dateOfIssue;
  String? securityNumber;
  String? cardNumber;
  String? pdf417Barcode;
  String? spaceFiller;

  CapturedVerifeeDetails(
      {this.surname,
      this.names,
      this.sex,
      this.nationality,
      this.identityNumber,
      this.identityNumber2,
      this.passportNumber,
      this.dayOfBirth,
      this.countryOfBirth,
      this.status,
      this.dateOfIssue,
      this.securityNumber,
      this.cardNumber,
      this.pdf417Barcode,
      this.spaceFiller});

  CapturedVerifeeDetails.fromPassportString(List<String> data) {
    var results = MRZParser.parse(data);
    surname = results.surnames;
    names = results.givenNames;
    sex = results.sex.name;
    nationality = results.countryCode;
    passportNumber = results.documentNumber;
    dayOfBirth = results.birthDate.toString();
    countryOfBirth = results.nationalityCountryCode;
    cardNumber = results.personalNumber;
    pdf417Barcode = data.join('|');
  }

  CapturedVerifeeDetails.fromIdString(String data) {
    List<String> parts = data.split('|');
    print(parts.length);
    print(parts.join('\n\n'));
    print(parts.toString());
    surname = parts[0];
    names = parts[1];
    sex = parts[2];
    nationality = parts[3];
    identityNumber = parts[4];
    dayOfBirth = parts[5];
    countryOfBirth = parts[6];
    status = parts[7];
    dateOfIssue = parts[8];
    securityNumber = parts[9];
    cardNumber = parts[10];
    pdf417Barcode = data;
    spaceFiller = parts[11];
  }

  CapturedVerifeeDetails.fromJson(Map<String, dynamic> json) {
    surname = json['surname'];
    names = json['names'];
    sex = json['sex'];
    nationality = json['nationality'];
    identityNumber = json['identityNumber'];
    identityNumber2 = json['identityNumber2'];
    passportNumber = json['passportNumber'];
    dayOfBirth = json['dayOfBirth'];
    countryOfBirth = json['countryOfBirth'];
    status = json['status'];
    dateOfIssue = json['dateOfIssue'];
    securityNumber = json['securityNumber'];
    cardNumber = json['cardNumber'];
    pdf417Barcode = json['pdf417Barcode'];
    spaceFiller = json['spaceFiller'];
  }

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['surname'] = surname;
    _data['names'] = names;
    _data['sex'] = sex;
    _data['nationality'] = nationality;
    _data['identityNumber'] = identityNumber;
    _data['identityNumber2'] = identityNumber2;
    _data['passportNumber'] = passportNumber;
    _data['dayOfBirth'] = dayOfBirth;
    _data['countryOfBirth'] = countryOfBirth;
    _data['status'] = status;
    _data['dateOfIssue'] = dateOfIssue;
    _data['securityNumber'] = securityNumber;
    _data['cardNumber'] = cardNumber;
    _data['pdf417Barcode'] = pdf417Barcode;
    _data['spaceFiller'] = spaceFiller;
    return _data;
  }
}
