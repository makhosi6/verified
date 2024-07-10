import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:verified/app_config.dart';
import 'package:verified/domain/interfaces/i_store_repository.dart';
import 'package:verified/domain/models/generic_api_error.dart';
import 'package:verified/domain/models/generic_response.dart';
import 'package:verified/domain/models/help_ticket.dart';
import 'package:verified/domain/models/passport_response_data.dart';
import 'package:verified/domain/models/promotion.dart';
import 'package:verified/domain/models/resource_health_status_enum.dart';
import 'package:verified/domain/models/transaction_history.dart';
import 'package:verified/domain/models/upload_response.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/domain/models/wallet.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/helpers/security/nonce.dart';
import 'package:verified/services/dio.dart';

class StoreRepository implements IStoreRepository {
  final Dio _httpClient;

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
        'Authorization': 'Bearer $storeApiKey',
        'Content-Type': 'multipart/form-data',
      };

      final dio = Dio();
      final response = await dio.request(
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
    } on DioException {
     print('DioException ============>>>');
      return left(
        GenericApiError(
          error: 'Error Occurred',
          status: 'unknown dio error',
        ),
      );
    } catch (error, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      return left(
        GenericApiError(
          status: 'unknown',
          error: error.toString(),
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
      var headers = {'x-nonce': await generateNonce(), 'Authorization': 'Bearer $storeApiKey'};

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
            status: response.statusCode.toString(),
            error: response.statusMessage,
          ),
        );
      }
    } catch (e) {
      return left(
        GenericApiError(
          status: 'unknown',
          error: e.toString(),
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
      var headers = {'x-nonce': await generateNonce(), 'Authorization': 'Bearer $storeApiKey'};
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
    } catch (e) {
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
      var headers = {'x-nonce': await generateNonce(), 'Authorization': 'Bearer $storeApiKey'};
      var response = await _httpClient.get('$collection/resource/${resourceId ?? ""}',
          options: Options(
            method: 'GET',
            headers: headers,
          ),
          queryParameters: (userId == null) ? null : {'profileId': userId});

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
    } catch (e) {
      debugPrint(e.toString());
      return left(GenericApiError(
        status: 'unknown',
        error: e.toString(),
      ));
    }
  }

  @override
  Future<Either<GenericApiError, UserProfile>> postUserProfile(UserProfile user) async =>
      await _genericPostRequest<UserProfile>('profile', user.toJson(), UserProfile.fromJson);

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
        'Authorization': 'Bearer $storeApiKey'
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
      return (await _genericGetRequest<T>('profile', data['id'], transform));
    } catch (e) {
      return left(
        GenericApiError(
          status: 'unknown',
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<GenericApiError, UserProfile>> putUserProfile(UserProfile user) async =>
      await _genericPutRequest<UserProfile>('profile', user.toJson(), UserProfile.fromJson);

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
        'Authorization': 'Bearer $storeApiKey'
      };
      var response = await _httpClient.put(
        '$collection/resource/${data['id']}',
        options: Options(
          method: 'PUT',
          headers: headers,
        ),
        data: data,
      );
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
    } catch (e) {
      return left(
        GenericApiError(
          status: 'unknown',
          error: e.toString(),
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
        'Authorization': 'Bearer $storeApiKey'
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
    } catch (e) {
      return left(
        GenericApiError(
          status: 'unknown',
          error: 'Error Occurred',
        ),
      );
    }
  }

  @override
  Future<ResourceHealthStatus> getHealthStatus() async {
    try {
      var headers = {'x-nonce': await generateNonce(), 'Authorization': 'Bearer $storeApiKey'};
      var response = await _httpClient.get(
        'health-check',
        options: Options(
          method: 'GET',
          headers: headers,
        ),
      );

      if (httpRequestIsSuccess(response.statusCode)) {
        return ResourceHealthStatus.good;
      }
      return ResourceHealthStatus.bad;
    } catch (e) {
      return ResourceHealthStatus.bad;
    }
  }

  @override
  Future<UploadResponse> uploadFiles(uploads) async {
    try {
      final headers = {
        'Authorization': 'Bearer $storeApiKey',
        'Content-Type': 'multipart/form-data',
      };
      final data = FormData.fromMap({
        'files': uploads,
      });

      final dio = Dio();
      const url = '$CDN/api/v1/media/upload';
      final response = await dio.request(
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
        print(response.statusMessage);
        return UploadResponse(
          files: [],
          message: 'No file uploaded',
        );
      }
    } catch (e) {
      print(e);

      return UploadResponse(
        files: [],
        message: 'No file uploaded',
      );
    }
  }
}
