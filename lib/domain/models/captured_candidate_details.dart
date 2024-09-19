import 'dart:convert';

import 'package:mrz_parser/mrz_parser.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/presentation/utils/document_type.dart';

class CapturedCandidateDetails {
  String? surname;
  String? names;
  String? sex;
  String? documentType;
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
  String? rawInput;
  String? spaceFiller;
  String? jobUuid;
  Map<String, dynamic>? cameraState;

  CapturedCandidateDetails(
      {this.surname,
      this.names,
      this.sex,
      this.documentType,
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
      this.rawInput,
      this.jobUuid,
      this.cameraState,
      this.spaceFiller});

  CapturedCandidateDetails.fromPassportString(List<String> data) {
    try {
      var results = MRZParser.parse(data);
      surname = results.surnames;
      names = results.givenNames;
      sex = results.sex.name;
      documentType = DocumentType.passport.name;
      nationality = results.countryCode;
      passportNumber = results.documentNumber;
      dayOfBirth = results.birthDate.toString();
      countryOfBirth = results.nationalityCountryCode;
      cardNumber = results.personalNumber;
      rawInput = data.join('');
    } catch (error, stackTrace) {
      verifiedErrorLogger(error, stackTrace);
    }
  }

  CapturedCandidateDetails.fromIdString(String data) {
    try {
      List<String> parts = data.split('|');
      verifiedLogger(parts.length);
      verifiedLogger(parts.join('\n\n'));
      verifiedLogger(parts.toString());
      surname = parts[0];
      names = parts[1];
      sex = parts[2];
      documentType = DocumentType.id_card.name;
      nationality = parts[3];
      identityNumber = parts[4];
      dayOfBirth = parts[5];
      countryOfBirth = parts[6];
      status = parts[7];
      dateOfIssue = parts[8];
      securityNumber = parts[9];
      cardNumber = parts[10];
      rawInput = data;
      spaceFiller = parts[11];
    } catch (error, stackTrace) {
      verifiedErrorLogger(error, stackTrace);
    }
  }

  CapturedCandidateDetails.fromJson(Map<String, dynamic> json) {
    try {
      surname = json['surname'];
      names = json['names'];
      sex = json['sex'];
      documentType = json['documentType'];
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
      rawInput = json['rawInput'];
      spaceFiller = json['spaceFiller'];
      jobUuid = json['jobUuid'];
      cameraState = json['cameraState'];
    } catch (error, stackTrace) {
      verifiedErrorLogger(error, stackTrace);
    }
  }

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['surname'] = surname;
    _data['names'] = names;
    _data['sex'] = sex;
    _data['documentType'] = documentType;
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
    _data['rawInput'] = rawInput;
    _data['jobUuid'] = jobUuid;
    _data['cameraState'] = cameraState;
    _data['spaceFiller'] = spaceFiller;
    return _data;
  }
}
