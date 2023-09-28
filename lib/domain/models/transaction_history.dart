/// profileId : "e60aecb7-59c2-4659-974e-804b1387b46e"
/// amount : 20.1
/// isoCurrencyCode : "ZAR"
/// categoryId : "19013000"
/// timestamp : 1644698226
/// details : {"id":"000","query":"000 000 0000"}
/// description : "Debited 50 points for subscription renewal."
/// subtype : "credit card"
/// type : "debit"
/// transactionReferenceNumber : null
/// transactionId : "lPNjeW1n-R6CDn5okmGQ-6hEpMo4lL-NoS4zqDje"
/// createdAt : 1644698226
/// id : "87bb8e34-3cfe-4c3c-acf8-ce4ef396e65a"

class TransactionHistory {
  TransactionHistory({
      this.profileId, 
      this.amount, 
      this.isoCurrencyCode, 
      this.categoryId, 
      this.timestamp, 
      this.details, 
      this.description, 
      this.subtype, 
      this.type, 
      this.transactionReferenceNumber, 
      this.transactionId, 
      this.createdAt, 
      this.id,});

  TransactionHistory.fromJson(dynamic json) {
    profileId = json['profileId'];
    amount = json['amount'];
    isoCurrencyCode = json['isoCurrencyCode'];
    categoryId = json['categoryId'];
    timestamp = json['timestamp'];
    details = json['details'] != null ? Details.fromJson(json['details']) : null;
    description = json['description'];
    subtype = json['subtype'];
    type = json['type'];
    transactionReferenceNumber = json['transactionReferenceNumber'];
    transactionId = json['transactionId'];
    createdAt = json['createdAt'];
    id = json['id'];
  }
  String? profileId;
  num? amount;
  String? isoCurrencyCode;
  String? categoryId;
  num? timestamp;
  Details? details;
  String? description;
  String? subtype;
  String? type;
  dynamic transactionReferenceNumber;
  String? transactionId;
  num? createdAt;
  String? id;
TransactionHistory copyWith({  String? profileId,
  num? amount,
  String? isoCurrencyCode,
  String? categoryId,
  num? timestamp,
  Details? details,
  String? description,
  String? subtype,
  String? type,
  dynamic transactionReferenceNumber,
  String? transactionId,
  num? createdAt,
  String? id,
}) => TransactionHistory(  profileId: profileId ?? this.profileId,
  amount: amount ?? this.amount,
  isoCurrencyCode: isoCurrencyCode ?? this.isoCurrencyCode,
  categoryId: categoryId ?? this.categoryId,
  timestamp: timestamp ?? this.timestamp,
  details: details ?? this.details,
  description: description ?? this.description,
  subtype: subtype ?? this.subtype,
  type: type ?? this.type,
  transactionReferenceNumber: transactionReferenceNumber ?? this.transactionReferenceNumber,
  transactionId: transactionId ?? this.transactionId,
  createdAt: createdAt ?? this.createdAt,
  id: id ?? this.id,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profileId'] = profileId;
    map['amount'] = amount;
    map['isoCurrencyCode'] = isoCurrencyCode;
    map['categoryId'] = categoryId;
    map['timestamp'] = timestamp;
    if (details != null) {
      map['details'] = details?.toJson();
    }
    map['description'] = description;
    map['subtype'] = subtype;
    map['type'] = type;
    map['transactionReferenceNumber'] = transactionReferenceNumber;
    map['transactionId'] = transactionId;
    map['createdAt'] = createdAt;
    map['id'] = id;
    return map;
  }

}

/// id : "000"
/// query : "000 000 0000"

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