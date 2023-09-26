class Wallet {
  Wallet({
    this.id,
    this.profileId,
    this.balance,
    this.isoCurrencyCode,
    this.accountHolderName,
    this.accountName,
    this.expDate,
    this.card,
    this.lastDepositAt,
    this.historyId,
    this.promotions,
    this.lastLoginAt,
    this.accountCreatedAt,
  });

  Wallet.fromJson(dynamic json) {
    id = json['id'];
    profileId = json['profileId'];
    balance = json['balance'];
    isoCurrencyCode = json['isoCurrencyCode'];
    accountHolderName = json['accountHolderName'];
    accountName = json['accountName'];
    expDate = json['expDate'];
    card = json['card'];
    lastDepositAt = json['lastDepositAt'];
    historyId = json['historyId'];
    if (json['promotions'] != null) {
      promotions = [];
      json['promotions'].forEach((v) {
        promotions?.add(v);
      });
    }
    lastLoginAt = json['lastLoginAt'];
    accountCreatedAt = json['accountCreatedAt'];
  }
  String? id;
  String? profileId;
  num? balance;
  String? isoCurrencyCode;
  String? accountHolderName;
  String? accountName;
  String? expDate;
  String? card;
  num? lastDepositAt;
  String? historyId;
  List<dynamic>? promotions;
  num? lastLoginAt;
  num? accountCreatedAt;
  Wallet copyWith({
    String? id,
    String? profileId,
    num? balance,
    String? isoCurrencyCode,
    String? accountHolderName,
    String? accountName,
    String? expDate,
    String? card,
    num? lastDepositAt,
    String? historyId,
    List<String>? promotions,
    num? lastLoginAt,
    num? accountCreatedAt,
  }) =>
      Wallet(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        balance: balance ?? this.balance,
        isoCurrencyCode: isoCurrencyCode ?? this.isoCurrencyCode,
        accountHolderName: accountHolderName ?? this.accountHolderName,
        accountName: accountName ?? this.accountName,
        expDate: expDate ?? this.expDate,
        card: card ?? this.card,
        lastDepositAt: lastDepositAt ?? this.lastDepositAt,
        historyId: historyId ?? this.historyId,
        promotions: promotions ?? this.promotions,
        lastLoginAt: lastLoginAt ?? this.lastLoginAt,
        accountCreatedAt: accountCreatedAt ?? this.accountCreatedAt,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['profileId'] = profileId;
    map['balance'] = balance;
    map['isoCurrencyCode'] = isoCurrencyCode;
    map['accountHolderName'] = accountHolderName;
    map['accountName'] = accountName;
    map['expDate'] = expDate;
    map['card'] = card;
    map['lastDepositAt'] = lastDepositAt;
    map['historyId'] = historyId;
    if (promotions != null) {
      map['promotions'] = promotions?.map((v) => v.toJson()).toList();
    }
    map['lastLoginAt'] = lastLoginAt;
    map['accountCreatedAt'] = accountCreatedAt;
    return map;
  }
}
