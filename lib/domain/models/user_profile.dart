import 'package:verified/domain/models/device.dart';

class UserProfile {
  UserProfile({
    this.actualName,
    this.active,
    this.avatar,
    this.dataProvider,
    this.metadata,
    this.softDeleted,
    this.displayName,
    this.email,
    this.id,
    this.name,
    this.phone,
    this.profileId,
    this.notificationToken,
    this.walletId,
    this.historyId,
    this.lastLoginAt,
    this.devices,
    this.currentSui,
    this.env,
    this.accountCreatedAt,
  });

  static var empty = UserProfile.fromJson({
    'actualName': 'Hello',
    'active': true,
    'dataProvider': null,
    'devices': [],
    'currentSui': '',
    'env': '',
    'metadata': null,
    'avatar': 'https://robohash.org/avatar.png',
    'softDeleted': null,
    'displayName': null,
    'email': 'nomail@example.com',
    'id': 'ec87944f-4000-426b-b6f8-6649d6a8a387',
    'name': 'Hello',
    'phone': null,
    'notificationToken': null,
    'profileId': 'rEFR3yIt8j3d2FQQX7TrjH7WjFRY',
    'walletId': null,
    'historyId': null,
    'last_login_at': null,
    'account_created_at': null,
    'createdAt': 1698947881950
  });

  UserProfile.fromJson(dynamic json) {
    actualName = json['actualName'];
    active = json['active'];
    avatar = json['avatar'];
    dataProvider = json['dataProvider'];
    metadata = json['metadata'];
    softDeleted = json['softDeleted'];
    displayName = json['displayName'];
    email = json['email'];
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    notificationToken = json['notificationToken'];
    profileId = json['profileId'];
    walletId = json['walletId'];
    historyId = json['historyId'];
    lastLoginAt = json['last_login_at'];
    accountCreatedAt = json['account_created_at'];
    devices = json['devices'];
    currentSui = json['currentSui'];
    env = json['env'];
  }
  String? actualName;
  bool? active;
  String? avatar;
  String? dataProvider;
  dynamic metadata;
  bool? softDeleted;
  String? displayName;
  String? email;
  String? id;
  String? name;
  String? phone;
  String? notificationToken;
  String? profileId;
  String? walletId;
  String? historyId;
  num? lastLoginAt;
  num? accountCreatedAt;
  List<Device>? devices;
  String? currentSui;
  String? env;

  UserProfile copyWith({
    String? actualName,
    bool? active,
    String? avatar,
    String? dataProvider,
    dynamic metadata,
    bool? softDeleted,
    String? displayName,
    String? email,
    String? id,
    String? name,
    String? phone,
    String? notificationToken,
    String? profileId,
    String? walletId,
    String? historyId,
    num? lastLoginAt,
    num? accountCreatedAt,
    List<Device>? devices,
    String? currentSui,
    String? env,
  }) =>
      UserProfile(
        actualName: actualName ?? this.actualName,
        active: active ?? this.active,
        avatar: avatar ?? this.avatar,
        dataProvider: dataProvider ?? this.dataProvider,
        metadata: metadata ?? this.metadata,
        softDeleted: softDeleted ?? this.softDeleted,
        displayName: displayName ?? this.displayName,
        email: email ?? this.email,
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        notificationToken: notificationToken ?? this.notificationToken,
        profileId: profileId ?? this.profileId,
        walletId: walletId ?? this.walletId,
        historyId: historyId ?? this.historyId,
        lastLoginAt: lastLoginAt ?? this.lastLoginAt,
        accountCreatedAt: accountCreatedAt ?? this.accountCreatedAt,
        devices: devices ?? this.devices,
        currentSui: currentSui ?? this.currentSui,
        env: this.env,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['actualName'] = actualName;
    map['active'] = active;
    map['avatar'] = avatar;
    map['dataProvider'] = dataProvider;
    map['metadata'] = metadata;
    map['softDeleted'] = softDeleted;
    map['displayName'] = displayName;
    map['email'] = email;
    map['id'] = id;
    map['name'] = name;
    map['phone'] = phone;
    map['notificationToken'] = notificationToken;
    map['profileId'] = profileId;
    map['walletId'] = walletId;
    map['historyId'] = historyId;
    map['last_login_at'] = lastLoginAt;
    map['account_created_at'] = accountCreatedAt;
    map['devices'] = devices;
    map['currentSui'] = currentSui;
    map['env'] = env;
    return map;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfile &&
        other.actualName == actualName &&
        other.active == active &&
        other.avatar == avatar &&
        other.dataProvider == dataProvider &&
        other.metadata == metadata &&
        other.softDeleted == softDeleted &&
        other.displayName == displayName &&
        other.email == email &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.profileId == profileId &&
        other.notificationToken == notificationToken &&
        other.walletId == walletId &&
        other.historyId == historyId &&
        other.lastLoginAt == lastLoginAt &&
        // other.devices == devices &&
        other.currentSui == currentSui &&
        other.env == env &&
        other.accountCreatedAt == accountCreatedAt;
  }

  @override
  int get hashCode {
    return actualName.hashCode ^
        active.hashCode ^
        avatar.hashCode ^
        dataProvider.hashCode ^
        metadata.hashCode ^
        softDeleted.hashCode ^
        displayName.hashCode ^
        email.hashCode ^
        id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        profileId.hashCode ^
        notificationToken.hashCode ^
        walletId.hashCode ^
        historyId.hashCode ^
        lastLoginAt.hashCode ^
        // devices.hashCode ^
        currentSui.hashCode ^
        env.hashCode ^
        accountCreatedAt.hashCode;
  }
}
