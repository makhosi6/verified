class IdNotFoundError {
  IdNotFoundError({
      this.status, 
      this.contactEnquiry, 
      this.transactionId,});

  IdNotFoundError.fromJson(dynamic json) {
    status = json['Status'];
    contactEnquiry = json['Contact_Enquiry'] != null ? ContactEnquiry.fromJson(json['Contact_Enquiry']) : null;
    transactionId = json['transaction_id'];
  }
  String? status;
  ContactEnquiry? contactEnquiry;
  String? transactionId;
IdNotFoundError copyWith({  String? status,
  ContactEnquiry? contactEnquiry,
  String? transactionId,
}) => IdNotFoundError(  status: status ?? this.status,
  contactEnquiry: contactEnquiry ?? this.contactEnquiry,
  transactionId: transactionId ?? this.transactionId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Status'] = status;
    if (contactEnquiry != null) {
      map['Contact_Enquiry'] = contactEnquiry?.toJson();
    }
    map['transaction_id'] = transactionId;
    return map;
  }

}

class ContactEnquiry {
  ContactEnquiry({
      this.error, 
      this.errorString,});

  ContactEnquiry.fromJson(dynamic json) {
    error = json['error'];
    errorString = json['errorString'];
  }
  String? error;
  String? errorString;
ContactEnquiry copyWith({  String? error,
  String? errorString,
}) => ContactEnquiry(  error: error ?? this.error,
  errorString: errorString ?? this.errorString,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['errorString'] = errorString;
    return map;
  }

}