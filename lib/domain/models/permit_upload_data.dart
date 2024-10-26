import 'package:verified/domain/models/permit_type.dart';
import 'package:verified/domain/models/upload_response.dart';

class PermitVisaUploadBean {
  String? jobUuid;
  String? permitType;
  String? permitNumber;
  String? date;
  String? signature;
  List<UploadResponse>? relatedDocuments;
  String? additionalInformation;

  PermitVisaUploadBean(
      {this.permitType,
      this.jobUuid,
      this.permitNumber,
      this.date,
      this.signature,
      this.relatedDocuments,
      this.additionalInformation});

  PermitVisaUploadBean.fromJson(Map<String, dynamic> json) {
    jobUuid = json['jobUuid'];
    permitType = json['permitType'];
    permitNumber = json['permitNumber'];
    date = json['date'];
    signature = json['signature'];
    relatedDocuments = json['relatedDocuments'] == null
        ? null
        : (json['relatedDocuments'] as List).map((e) => UploadResponse.fromJson(e)).toList();
    additionalInformation = json['additionalInformation'];
  }

  PermitVisaUploadBean copyWith(
          {String? jobUuid,
          String? permitType,
          String? permitNumber,
          String? date,
          String? signature,
          List<UploadResponse>? relatedDocuments,
          String? additionalInformation}) =>
      PermitVisaUploadBean(
        jobUuid: jobUuid ?? this.jobUuid,
        permitType: permitType ?? this.permitType,
        permitNumber: permitNumber ?? this.permitNumber,
        date: date ?? this.date,
        signature: signature ?? this.signature,
        relatedDocuments: relatedDocuments ?? this.relatedDocuments,
        additionalInformation: additionalInformation ?? this.additionalInformation,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['jobUuid'] = jobUuid;
    _data['permitType'] = permitType;
    _data['permitNumber'] = permitNumber;
    _data['date'] = date;
    _data['signature'] = signature;
    if (relatedDocuments != null) {
      _data['relatedDocuments'] = relatedDocuments?.map((e) => e.toJson()).toList();
    }
    _data['additionalInformation'] = additionalInformation;
    return _data;
  }
}
