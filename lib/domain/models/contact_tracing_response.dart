class ContactTracingResponse {
  ContactTracingResponse({
    this.status,
    this.contactEnquiry,
    this.transactionId,
  });

  ContactTracingResponse.fromJson(dynamic json) {
    status = json['status'];
    contactEnquiry = json['contactEnquiry'] != null
        ? ContactEnquiry.fromJson(json['contactEnquiry'])
        : null;
    transactionId = json['transaction_id'];
  }
  String? status;
  ContactEnquiry? contactEnquiry;
  String? transactionId;
  ContactTracingResponse copyWith({
    String? status,
    ContactEnquiry? contactEnquiry,
    String? transactionId,
  }) =>
      ContactTracingResponse(
        status: status ?? this.status,
        contactEnquiry: contactEnquiry ?? this.contactEnquiry,
        transactionId: transactionId ?? this.transactionId,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (contactEnquiry != null) {
      map['contactEnquiry'] = contactEnquiry?.toJson();
    }
    map['transaction_id'] = transactionId;
    return map;
  }
}

class ContactEnquiry {
  ContactEnquiry({
    this.results,
  });

  ContactEnquiry.fromJson(dynamic json) {
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(Results.fromJson(v));
      });
    }
  }
  List<Results>? results;
  ContactEnquiry copyWith({
    List<Results>? results,
  }) =>
      ContactEnquiry(
        results: results ?? this.results,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (results != null) {
      map['results'] = results?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Results {
  Results({
    this.idnumber,
    this.forename1,
    this.forename2,
    this.surname,
  });

  Results.fromJson(dynamic json) {
    idnumber = json['idnumber'];
    forename1 = json['forename1'];
    forename2 = json['forename2'];
    surname = json['surname'];
  }
  String? idnumber;
  String? forename1;
  String? forename2;
  String? surname;
  Results copyWith({
    String? idnumber,
    String? forename1,
    String? forename2,
    String? surname,
  }) =>
      Results(
        idnumber: idnumber ?? this.idnumber,
        forename1: forename1 ?? this.forename1,
        forename2: forename2 ?? this.forename2,
        surname: surname ?? this.surname,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idnumber'] = idnumber;
    map['forename1'] = forename1;
    map['forename2'] = forename2;
    map['surname'] = surname;
    return map;
  }
}
