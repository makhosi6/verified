class UserProfile {
  UserProfile({
      this.actualName, 
      this.active, 
      this.avatar, 
      this.softDeleted, 
      this.displayName, 
      this.email, 
      this.id, 
      this.name, 
      this.phone, 
      this.profileId, 
      this.walletId, 
      this.historyId, 
      this.lastLoginAt, 
      this.accountCreatedAt,});

  UserProfile.fromJson(dynamic json) {
    actualName = json['actualName'];
    active = json['active'];
    avatar = json['avatar'];
    softDeleted = json['softDeleted'];
    displayName = json['displayName'];
    email = json['email'];
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    profileId = json['profileId'];
    walletId = json['walletId'];
    historyId = json['historyId'];
    lastLoginAt = json['last_login_at'];
    accountCreatedAt = json['account_created_at'];
  }
  String? actualName;
  bool? active;
  String? avatar;
  bool? softDeleted;
  String? displayName;
  String? email;
  String? id;
  String? name;
  String? phone;
  String? profileId;
  String? walletId;
  String? historyId;
  num? lastLoginAt;
  num? accountCreatedAt;
UserProfile copyWith({  String? actualName,
  bool? active,
  String? avatar,
  bool? softDeleted,
  String? displayName,
  String? email,
  String? id,
  String? name,
  String? phone,
  String? profileId,
  String? walletId,
  String? historyId,
  num? lastLoginAt,
  num? accountCreatedAt,
}) => UserProfile(  actualName: actualName ?? this.actualName,
  active: active ?? this.active,
  avatar: avatar ?? this.avatar,
  softDeleted: softDeleted ?? this.softDeleted,
  displayName: displayName ?? this.displayName,
  email: email ?? this.email,
  id: id ?? this.id,
  name: name ?? this.name,
  phone: phone ?? this.phone,
  profileId: profileId ?? this.profileId,
  walletId: walletId ?? this.walletId,
  historyId: historyId ?? this.historyId,
  lastLoginAt: lastLoginAt ?? this.lastLoginAt,
  accountCreatedAt: accountCreatedAt ?? this.accountCreatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['actualName'] = actualName;
    map['active'] = active;
    map['avatar'] = avatar;
    map['softDeleted'] = softDeleted;
    map['displayName'] = displayName;
    map['email'] = email;
    map['id'] = id;
    map['name'] = name;
    map['phone'] = phone;
    map['profileId'] = profileId;
    map['walletId'] = walletId;
    map['historyId'] = historyId;
    map['last_login_at'] = lastLoginAt;
    map['account_created_at'] = accountCreatedAt;
    return map;
  }

}