class TransactionHistory {
  TransactionHistory({
      this.profileId, 
      this.amount, 
      this.isoCurrencyCode, 
      this.categoryId, 
      this.date, 
      this.details, 
      this.officialName, 
      this.subtype, 
      this.type, 
      this.transactionReferenceNumber, 
      this.transactionId,});

  TransactionHistory.fromJson(dynamic json) {
    profileId = json['profileId'];
    amount = json['amount'];
    isoCurrencyCode = json['isoCurrencyCode'];
    categoryId = json['categoryId'];
    date = json['date'];
    details = json['details'] != null ? Details.fromJson(json['details']) : null;
    officialName = json['officialName'];
    subtype = json['subtype'];
    type = json['type'];
    transactionReferenceNumber = json['transactionReferenceNumber'];
    transactionId = json['transactionId'];
  }
  String? profileId;
  num? amount;
  String? isoCurrencyCode;
  String? categoryId;
  String? date;
  Details? details;
  String? officialName;
  String? subtype;
  String? type;
  dynamic transactionReferenceNumber;
  String? transactionId;
TransactionHistory copyWith({  String? profileId,
  num? amount,
  String? isoCurrencyCode,
  String? categoryId,
  String? date,
  Details? details,
  String? officialName,
  String? subtype,
  String? type,
  dynamic transactionReferenceNumber,
  String? transactionId,
}) => TransactionHistory(  profileId: profileId ?? this.profileId,
  amount: amount ?? this.amount,
  isoCurrencyCode: isoCurrencyCode ?? this.isoCurrencyCode,
  categoryId: categoryId ?? this.categoryId,
  date: date ?? this.date,
  details: details ?? this.details,
  officialName: officialName ?? this.officialName,
  subtype: subtype ?? this.subtype,
  type: type ?? this.type,
  transactionReferenceNumber: transactionReferenceNumber ?? this.transactionReferenceNumber,
  transactionId: transactionId ?? this.transactionId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profileId'] = profileId;
    map['amount'] = amount;
    map['isoCurrencyCode'] = isoCurrencyCode;
    map['categoryId'] = categoryId;
    map['date'] = date;
    if (details != null) {
      map['details'] = details?.toJson();
    }
    map['officialName'] = officialName;
    map['subtype'] = subtype;
    map['type'] = type;
    map['transactionReferenceNumber'] = transactionReferenceNumber;
    map['transactionId'] = transactionId;
    return map;
  }

}

class Details {
  Details({
      this.id, 
      this.query,});

  Details.fromJson(dynamic json) {
    id = json['id'];
    query = json['query'];
  }
  String? id;
  String? query;
Details copyWith({  String? id,
  String? query,
}) => Details(  id: id ?? this.id,
  query: query ?? this.query,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['query'] = query;
    return map;
  }

}