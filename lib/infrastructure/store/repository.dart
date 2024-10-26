import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:verified/app_config.dart';
import 'package:verified/domain/interfaces/i_store_repository.dart';
import 'package:verified/domain/models/communication_channels.dart';
import 'package:verified/domain/models/generic_api_error.dart';
import 'package:verified/domain/models/generic_response.dart';
import 'package:verified/domain/models/help_ticket.dart';
import 'package:verified/domain/models/passport_response_data.dart';
import 'package:verified/domain/models/promotion.dart';
import 'package:verified/domain/models/search_request.dart';
import 'package:verified/domain/models/transaction_history.dart';
import 'package:verified/domain/models/upload_response.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/domain/models/verification_request.dart';
import 'package:verified/domain/models/wallet.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/helpers/security/nonce.dart';
import 'package:verified/services/dio.dart';

class StoreRepository implements IStoreRepository {
  final Dio _httpClient;
  String _phone = '-';
  String _user = '-';
  String _env = '-';

  StoreRepository(this._httpClient) {
    (_httpClient.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient dioClient) => dioClient
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) {
        verifiedErrorLogger(
          'CERT: $cert \n HOST: $host:$port \n Error: Bad Certificate Error',
        );
        return true;
      });
  }

  @override
  Future<Either<GenericApiError, PassportResponseData>> decodePassportData(FormData data) async {
    try {
      final headers = {
        'x-nonce': await generateNonce(),
        'Authorization': 'Bearer $storeApiKey',
        'Content-Type': 'multipart/form-data',
        'x-client': _user,
        'x-client-sui': _phone,
        'x-client-env': _env,
      };

      final response = await _httpClient.request(
        OCR_URL,
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      var statusCode = response.statusCode;

      if (httpRequestIsSuccess(response.statusCode)) {
        var data = PassportResponseData.fromJson(response.data);
        if (data.error is String || data.message != 'successful') {
          return left(
            GenericApiError(
              error: data.error,
              status: 'unknown error',
            ),
          );
        }

        return right(data);
      } else {
        return left(
          GenericApiError(
            error: 'Error Occurred',
            status: '$statusCode',
          ),
        );
      }
    } on DioException catch (error, stackTrace) {
      verifiedErrorLogger(error, stackTrace);
      return left(
        GenericApiError(
          error: 'Error Occurred',
          status: 'unknown dio error',
        ),
      );
    } catch (error, stackTrace) {
       verifiedErrorLogger(error, stackTrace);
      return left(
        GenericApiError(
          status: 'unknown',
          error: '$error',
        ),
      );
    }
  }

  @override
  Future<Either<GenericApiError, GenericResponse>> deleteUserProfile(String id) async =>
      await _genericDeleteRequest('profile', id);

  @override
  Future<Either<GenericApiError, GenericResponse>> deleteUserPromotions(String id) async =>
      await _genericDeleteRequest('promotion', id);

  @override
  Future<Either<GenericApiError, GenericResponse>> deleteUserTransaction(String id) async =>
      await _genericDeleteRequest('history', id);

  @override
  Future<Either<GenericApiError, GenericResponse>> deleteUserWallet(String id) async =>
      await _genericDeleteRequest('wallet', id);

  @override
  Future<Either<GenericApiError, GenericResponse>> deleteHelpTicket(String id) async =>
      await _genericDeleteRequest('ticket', id);

  Future<Either<GenericApiError, GenericResponse>> _genericDeleteRequest(String collection, String id) async {
    try {
      var headers = {
        'x-nonce': await generateNonce(),
        'Authorization': 'Bearer $storeApiKey',
        'x-client': _user,
        'x-client-sui': _phone,
        'x-client-env': _env,
      };

      var response = await _httpClient.delete(
        '$collection/resource/$id',
        options: Options(
          method: 'DELETE',
          headers: headers,
        ),
      );

      if (httpRequestIsSuccess(response.statusCode)) {
        return right(GenericResponse(status: 'OK', code: response.statusCode));
      } else {
        return left(
          GenericApiError(
            status: '${response.statusCode}',
            error: response.statusMessage,
          ),
        );
      }
    } catch (error, stackTrace) {
       verifiedErrorLogger(error, stackTrace);
      return left(
        GenericApiError(
          status: 'unknown',
          error: '$error',
        ),
      );
    }
  }

  ///
  @override
  Future<Either<GenericApiError, HelpTicket>> getTicket(String resourceId) async =>
      await _genericGetRequest<HelpTicket>('ticket', resourceId, HelpTicket.fromJson);
  @override
  Future<Either<GenericApiError, UserProfile>> getUserProfile(String userId) async =>
      await _genericGetRequest<UserProfile>('profile', userId, UserProfile.fromJson);

  @override
  Future<Either<GenericApiError, Promotion>> getPromotion(String resourceId) async =>
      await _genericGetRequest<Promotion>('promotion', resourceId, Promotion.fromJson);

  @override
  Future<Either<GenericApiError, TransactionHistory>> getUserTransaction(String resourceId) async =>
      await _genericGetRequest<TransactionHistory>('history', resourceId, TransactionHistory.fromJson);

  @override
  Future<Either<GenericApiError, Wallet>> getUserWallet(String resourceId) async =>
      await _genericGetRequest<Wallet>('wallet', resourceId, Wallet.fromJson);

  ///
  // @override
  // Future<Either<GenericApiError, dynamic>> getAllUserPromotions(String userId) async =>
  //     await _genericGetAllRequest<Promotion>(
  //       collection: "promotion",
  //       resourceId: null,
  //       userId: userId,
  //     );

  @override
  Future<Either<GenericApiError, dynamic>> getAllTickets(String userId) async =>
      await _genericGetAllRequest<HelpTicket>(
          collection: 'ticket', resourceId: null, userId: userId, transform: HelpTicket.fromJson);

  @override
  Future<Either<GenericApiError, dynamic>> getAllUserTransaction(String userId) async =>
      await _genericGetAllRequest<TransactionHistory>(
          collection: 'history', resourceId: null, userId: userId, transform: TransactionHistory.fromJson);

  Future<Either<GenericApiError, T>> _genericGetRequest<T>(
      String collection, String resourceId, T Function(dynamic json) transform) async {
    try {
      var headers = {
        'x-nonce': await generateNonce(),
        'Authorization': 'Bearer $storeApiKey',
        'x-client': _user,
        'x-client-sui': _phone,
        'x-client-env': _env,
      };
      var response = await _httpClient.get(
        '$collection/resource/$resourceId',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (httpRequestIsSuccess(response.statusCode)) {
        return right(
          transform(response.data),
        );
      }

      return left(
        GenericApiError(
          status: 'unknown',
          error: 'Error Occurred',
        ),
      );
    } catch (error, stackTrace) {
       verifiedErrorLogger(error, stackTrace);
      return left(
        GenericApiError(
          status: 'unknown',
          error: 'Error Occurred',
        ),
      );
    }
  }

  Future<Either<GenericApiError, List<T>>> _genericGetAllRequest<T>(
      {required String collection,
      required String? resourceId,
      required String? userId,
      required T Function(dynamic json) transform}) async {
    try {
      var headers = {
        'x-nonce': await generateNonce(),
        'Authorization': 'Bearer $storeApiKey',
        'x-client': _user,
        'x-client-sui': _phone,
        'x-client-env': _env,
      };
      var response = await _httpClient.get('$collection/resource/${resourceId ?? ""}',
          options: Options(
            method: 'GET',
            headers: headers,
          ),
          queryParameters: (userId == null) ? null : {'profileId': userId, '': ''});

      if (httpRequestIsSuccess(response.statusCode)) {
        return right(
          List.from(response.data).map((item) => transform(item)).toList(),
        );
      }
      return left(
        GenericApiError(
          status: 'unknown',
          error: 'Error Occurred',
        ),
      );
    } catch (error, stackTrace) {
      verifiedErrorLogger(error, stackTrace);
      return left(GenericApiError(
        status: 'unknown',
        error: '$error',
      ));
    }
  }

  @override
  Future<Either<GenericApiError, UserProfile>> postUserProfile(UserProfile _user) async =>
      await _genericPostRequest<UserProfile>('profile', _user.toJson(), UserProfile.fromJson);

  @override
  Future<Either<GenericApiError, Promotion>> postUserPromotions(Promotion promotion) async =>
      await _genericPostRequest<Promotion>('promotion', promotion.toJson(), Promotion.fromJson);

  @override
  Future<Either<GenericApiError, TransactionHistory>> postUserTransaction(TransactionHistory transaction) async =>
      await _genericPostRequest<TransactionHistory>('history', transaction.toJson(), TransactionHistory.fromJson);

  @override
  Future<Either<GenericApiError, HelpTicket>> postHelpTicket(HelpTicket helpTicket) async =>
      await _genericPostRequest('ticket', helpTicket.toJson(), HelpTicket.fromJson);

  @override
  Future<Either<GenericApiError, Wallet>> postUserWallet(Wallet wallet) async =>
      await _genericPostRequest<Wallet>('wallet', wallet.toJson(), Wallet.fromJson);

  Future<Either<GenericApiError, T>> _genericPostRequest<T>(
      String collection, dynamic data, T Function(dynamic json) transform) async {
    try {
      var headers = {
        'x-nonce': await generateNonce(),
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $storeApiKey',
        'x-client': _user,
        'x-client-sui': _phone,
        'x-client-env': _env,
      };
      var response = await _httpClient.post(
        '$collection/resource',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );
      var statusCode = response.statusCode;
      if (httpRequestIsSuccess(response.statusCode)) {
        return right(transform(response.data));
      } else {
        return left(GenericApiError(
          error: 'Error Occurred',
          status: '$statusCode',
        ));
      }
    } on DioException {
      var id = data['id'] ?? data['uuid'] ?? data['jobUuid'];
      return (await _genericGetRequest<T>('profile', id, transform));
    } catch (error, stackTrace) {
       verifiedErrorLogger(error, stackTrace);
      return left(
        GenericApiError(
          status: 'unknown',
          error: '$error'
        ),
      );
    }
  }

  @override
  Future<Either<GenericApiError, UserProfile>> putUserProfile(UserProfile _user) async =>
      await _genericPutRequest<UserProfile>('profile', _user.toJson(), UserProfile.fromJson);

  @override
  Future<Either<GenericApiError, Promotion>> putUserPromotions(Promotion promotion) async =>
      await _genericPutRequest<Promotion>('promotion', promotion.toJson(), Promotion.fromJson);

  @override
  Future<Either<GenericApiError, TransactionHistory>> putUserTransaction(TransactionHistory transaction) async =>
      await _genericPutRequest<TransactionHistory>('history', transaction.toJson(), TransactionHistory.fromJson);

  @override
  Future<Either<GenericApiError, Wallet>> putUserWallet(Wallet wallet) async =>
      await _genericPutRequest<Wallet>('wallet', wallet.toJson(), Wallet.fromJson);

  @override
  Future<Either<GenericApiError, HelpTicket>> putHelpTicket(HelpTicket helpTicket) async =>
      _genericPutRequest('ticket', helpTicket.toJson(), HelpTicket.fromJson);

  Future<Either<GenericApiError, T>> _genericPutRequest<T>(
      String collection, Map data, T Function(dynamic json) transform) async {
    try {
      var headers = {
        'x-nonce': await generateNonce(),
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $storeApiKey',
        'x-client': _user,
        'x-client-sui': _phone,
        'x-client-env': _env,
      };
      var id = data['id'] ?? data['uuid'] ?? data['jobUuid'];
      var response = await _httpClient.put(
        '$collection/resource/$id',
        options: Options(
          method: 'PUT',
          headers: headers,
        ),
        data: data,
      );
      if (response.statusCode == 404) {
        response = await _httpClient.post(
          '$collection/resource',
          options: Options(
            method: 'POST',
            headers: headers,
          ),
          data: data,
        );
      }

      var statusCode = response.statusCode;
      if (httpRequestIsSuccess(response.statusCode)) {
        return right(
          transform(response.data),
        );
      } else {
        return left(GenericApiError(
          error: 'Error Occurred',
          status: '$statusCode',
        ));
      }
    } catch (error, stackTrace) {
       verifiedErrorLogger(error, stackTrace);
      return left(
        GenericApiError(
          status: 'unknown',
          error: '$error',
        ),
      );
    }
  }

  @override
  Future<Either<GenericApiError, GenericResponse>> requestHelp(HelpTicket help) async {
    try {
      var headers = {
        'x-nonce': await generateNonce(),
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $storeApiKey',
        'x-client': _user,
        'x-client-sui': _phone,
        'x-client-env': _env,
      };

      var response = await _httpClient.post(
        'help',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: help.toJson(),
      );
      var statusCode = response.statusCode;
      if (httpRequestIsSuccess(response.statusCode)) {
        return right(GenericResponse(status: 'OK', code: statusCode));
      } else {
        return left(GenericApiError(
          status: 'unknown',
          error: 'Error Occurred',
        ));
      }
    } catch (error, stackTrace) {
       verifiedErrorLogger(error, stackTrace);
      return left(
        GenericApiError(
          status: 'unknown',
          error: 'Error Occurred',
        ),
      );
    }
  }

  @override
  Future<Either<GenericApiError, GenericResponse>> getHealthStatus() async {
    try {
      var headers = {
        'x-nonce': await generateNonce(),
        'Authorization': 'Bearer $storeApiKey',
        'x-client': _user,
        'x-client-sui': _phone,
        'x-client-env': _env,
      };
      var response = await _httpClient.get(
        'health-check',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (httpRequestIsSuccess(response.statusCode)) {
        return right(GenericResponse(status: 'OK', code: response.statusCode));
      }
      return left(
        GenericApiError(
          status: 'unknown',
          error: 'Error Occurred',
        ),
      );
    } catch (error, stackTrace) {
       verifiedErrorLogger(error, stackTrace);
      return left(
        GenericApiError(
          status: 'unknown',
          error: 'Error Occurred',
        ),
      );
    }
  }

  @override
  Future<UploadResponse> uploadFiles(uploads) async {
    try {
      final headers = {
        'x-nonce': await generateNonce(),
        'Authorization': 'Bearer $storeApiKey',
        'x-client': _user,
        'x-client-sui': _phone,
        'x-client-env': _env,
        'Content-Type': 'multipart/form-data',
      };
      final data = FormData.fromMap({
        'files': uploads,
      });

      const url = '$CDN/api/v1/media/upload';
      final response = await _httpClient.request(
        url,
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      ///
      if (response.statusCode == 413) {
        return UploadResponse(
          files: [],
          message: 'Entity Too Large',
        );
      }

      ///
      if (httpRequestIsSuccess(response.statusCode)) {
        return UploadResponse.fromJson(response.data);
      } else {
        verifiedLogger(response.statusMessage);
        return UploadResponse(
          files: [],
          message: 'No file uploaded',
        );
      }
    } catch (error, stackTrace) {
      verifiedErrorLogger(error, stackTrace);

      return UploadResponse(
        files: [],
        message: 'No file uploaded',
      );
    }
  }

  @override
  Future<Either<GenericApiError, GenericResponse>> makeIdVerificationRequest(VerificationRequest data) =>
      _genericPostRequest('verification', data.toJson(), GenericResponse.fromJson);

  @override
  Future<Either<GenericApiError, GenericResponse>> makePassportVerificationRequest(VerificationRequest data) =>
      _genericPostRequest('verification', data.toJson(), GenericResponse.fromJson);

  @override
  Future<Either<Exception, VerifyComprehensiveResponse>> comprehensiveVerification(
      {required SearchPerson? person, required String clientId}) async {
    try {
      if (person == null) return left(Exception('Empty request Object'));
      var headers = {
        'x-nonce': await generateNonce(),
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $storeApiKey',
        'x-client': clientId,
        'x-client-sui': _phone,
        'x-client-env': _env,
      };

      final response = await _httpClient.post(
        '/comprehensive_verification?client=$clientId',
        options: Options(
          headers: headers,
        ),
        data: json.encode(person.toJson()..addAll({'id': person.instanceId})),
      );
      if (httpRequestIsSuccess(response.statusCode)) {
        // if (response.statusCode == 200) throw Exception('Some made up error.');

        return right(
          VerifyComprehensiveResponse.fromJson(
            {'status': response.statusCode, 'data': response.data, 'message': response.data['message']},
          ),
        );
      } else {
        return left(Exception(response.statusMessage));
      }
    } catch (error, stackTrace) {
       verifiedErrorLogger(error, stackTrace);
      return left(Exception('$error'));
    }
  }

  @override
  Future<GenericResponse?> willSendNotificationAfterVerification(CommsChannels data) async {
    try {
      if (data.instanceId == '' || data.instanceId.isEmpty) return null;
      final headers = {
        'x-nonce': await generateNonce(),
        'x-client': _user,
        'x-client-sui': _phone,
        'x-client-env': _env,
      };
      final response = await _httpClient.post(
        '/send-comms',
        options: Options(
          headers: headers,
        ),
        data: data.toJson(),
      );
      if (httpRequestIsSuccess(response.statusCode)) {
        return GenericResponse(status: 'success', code: response.statusCode);
      }
      return null;
    } catch (error, stackTrace) {
       verifiedErrorLogger(error, stackTrace);
      return null;
    }
  }
  
  @override
  Future<Either<GenericApiError, GenericResponse>> getVerificationJob({required String jobUuid}) async => await _genericGetRequest<GenericResponse>('jobs', jobUuid, GenericResponse.fromJson);

  @override
  Future<Either<GenericApiError, GenericResponse>> postDeviceData(Map<String, dynamic> device) =>
      _genericPostRequest('devices', device, GenericResponse.fromJson);

  @override
  void setUserAndVariables({required String phone, required String user, required String env}) {
    _phone = phone;
    _user = user;
    _env = env;

    verifiedLogger('SET VARIABLES:::  $phone as $_phone  | $user  | $env');
  }

}
