import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:verified/app_config.dart';
import 'package:verified/domain/interfaces/i_auth_repository.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/domain/models/verified_web_auth_user.dart';
import 'package:verified/helpers/security/nonce.dart';
import 'package:verified/services/dio.dart';

class AuthRepository implements IAuthRepository {
  final FirebaseAuth _authClient;

  AuthRepository(this._authClient);

  @override
  Stream<User?> authStateChanges() => _authClient.authStateChanges();

  @override
  User? get currentUser => _authClient.currentUser;

  @override
  Future<UserCredential> signInAnonymously() async => await _authClient.signInAnonymously();

  @override
  Future<UserCredential> signInWithPopup(AuthProvider provider) async => await _authClient.signInWithPopup(provider);

  @override
  Future<UserCredential> signInWithProvider(AuthProvider provider) async =>
      await _authClient.signInWithProvider(provider);

  @override
  Future<void> signOut() async => await _authClient.signOut();

  @override
  Future<void> webDeleteAccount(AuthUserDetails data) async {
    var headers = {'Authorization': 'Bearer ${data.token}'};
    var dio = Dio();
    var _ = await dio.request(
      '$WEB_AUTH_SERVER/api/delete-account',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );
  }

  @override
  Future<UserProfile?> storeLoginRequest(AuthUserDetails data) async {
    try {
      var headers = {'x-nonce': await generateNonce(), 'Authorization': 'Bearer $storeApiKey'};
      var dio = Dio();
      var response = await dio.request(
        '${baseUrl}api/v1/profile/resource/${data.userId}',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (httpRequestIsSuccess(response.statusCode)) {
        var id = response.data['id'];
        if (id is String && id.length > 1) return UserProfile.fromJson(response.data);
        return null;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<VerifiedWebUser?> webSignIn(AuthUserDetails data) async {
    try {
      var headers = {'Authorization': 'Bearer ${data.token}'};
      var dio = Dio();
      var response = await dio.request(
        '$WEB_AUTH_SERVER/api/user',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (httpRequestIsSuccess(response.statusCode)) {
        return VerifiedWebUser(
          uid: response.data['id'],
          displayName: response.data['name'],
          email: response.data['email'],
          isEmailVerified: response.data['email_verified_at'] != null,
          isAnonymous: false,
          metadata: UserMetadata(
            DateTime.tryParse(response.data['created_at'])?.millisecondsSinceEpoch,
            DateTime.now().millisecondsSinceEpoch,
          ),
          phoneNumber: null,
          photoUrl: 'https://robohash.org/${(response.data['id'].replaceRange(0, 2, "P_"))?.toLowerCase()}.png',
          providerData: [
            UserInfo.fromJson({'providerId': 'byteestudio.com'})
          ],
          refreshToken: data.token,
          tenantId: null,
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<VerifiedWebUser?> webSignUp(AuthUserDetails data, VerifiedWebUser user) async {
    try {
      var headers = {'Authorization': 'Bearer ${data.token}'};
      var dio = Dio();
      var response = await dio.put(
        'profile/resource/${data.userId}',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: user.toJson(),
      );

      if (httpRequestIsSuccess(response.statusCode)) {
        return VerifiedWebUser(
          uid: response.data['id'],
          displayName: response.data['name'],
          email: response.data['email'],
          isEmailVerified: response.data['email_verified_at'] != null,
          isAnonymous: false,
          metadata: UserMetadata(
            DateTime.tryParse(response.data['created_at'])?.millisecondsSinceEpoch,
            DateTime.now().millisecondsSinceEpoch,
          ),
          phoneNumber: null,
          photoUrl: 'https://robohash.org/${(response.data['id'].replaceRange(0, 2, "P_"))?.toLowerCase()}.png',
          providerData: [
            UserInfo.fromJson({'providerId': 'byteestudio.com'})
          ],
          refreshToken: data.token,
          tenantId: null,
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
