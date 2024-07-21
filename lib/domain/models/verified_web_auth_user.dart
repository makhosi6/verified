import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

class AuthUserDetails {
  final String? token;
  final String? userId;

  AuthUserDetails({required this.token, required this.userId});
}

class VerifiedWebUser {
  String? displayName;
  String? email;
  bool? isEmailVerified;
  bool? isAnonymous;
  UserMetadata? metadata;
  String? phoneNumber;
  String? photoUrl;
  List<UserInfo>? providerData;
  String? refreshToken;
  String? tenantId;
  String? uid;

  VerifiedWebUser(
      {this.displayName,
      this.email,
      this.isEmailVerified,
      this.isAnonymous,
      this.metadata,
      this.phoneNumber,
      this.photoUrl,
      this.providerData,
      this.refreshToken,
      this.tenantId,
      this.uid});

  VerifiedWebUser.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];
    email = json['email'];
    isEmailVerified = json['isEmailVerified'];
    isAnonymous = json['isAnonymous'];
    metadata = json['metadata'];
    phoneNumber = json['phoneNumber'];
    photoUrl = json['photoURL'];
    providerData = json['providerData'];
    refreshToken = json['refreshToken'];
    tenantId = json['tenantId'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['displayName'] = displayName;
    _data['email'] = email;
    _data['isEmailVerified'] = isEmailVerified;
    _data['isAnonymous'] = isAnonymous;
    _data['metadata'] = metadata;
    _data['phoneNumber'] = phoneNumber;
    _data['photoURL'] = photoUrl;
    _data['providerData'] = providerData;
    _data['refreshToken'] = refreshToken;
    _data['tenantId'] = tenantId;
    _data['uid'] = uid;
    return _data;
  }
}
