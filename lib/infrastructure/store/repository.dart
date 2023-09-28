import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:verified/app_config.dart';
import 'package:verified/domain/interfaces/i_store_repository.dart';
import 'package:verified/domain/models/generic_api_error.dart';
import 'package:verified/domain/models/generic_response.dart';
import 'package:verified/domain/models/help_request.dart';
import 'package:verified/domain/models/help_ticket.dart';
import 'package:verified/domain/models/promotion.dart';
import 'package:verified/domain/models/resource_health_status_enum.dart';
import 'package:verified/domain/models/transaction_history.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/domain/models/wallet.dart';
import 'package:verified/helpers/security/nonce.dart';
import 'package:verified/services/dio.dart';

class StoreRepository implements IStoreRepository {
  final Dio httpClient;

  StoreRepository(this.httpClient);

  @override
  Future<Either<GenericApiError, GenericResponse>> deleteUserProfile(String id) async =>
      await _genericDeleteRequest('profile', id);

  @override
  Future<Either<GenericApiError, GenericResponse>> deleteUserPromotions(String id) async =>
      await _genericDeleteRequest('promotion', id);

  @override
  Future<Either<GenericApiError, GenericResponse>> deleteUserTransaction(String id) async =>
      await _genericDeleteRequest("history", id);

  @override
  Future<Either<GenericApiError, GenericResponse>> deleteUserWallet(String id) async =>
      await _genericDeleteRequest('wallet', id);

  @override
  Future<Either<GenericApiError, GenericResponse>> deleteHelpTicket(String id) async =>
      await _genericDeleteRequest('ticket', id);

  Future<Either<GenericApiError, GenericResponse>> _genericDeleteRequest(String collection, String id) async {
    try {
      var headers = {'x-nonce': await generateNonce(), 'Authorization': 'Bearer $storeApiKey'};

      var response = await httpClient.delete(
        '$collection/resource/$id',
        options: Options(
          method: 'DELETE',
          headers: headers,
        ),
      );

      if (httpRequestIsSuccess(response.statusCode)) {
        return right(GenericResponse(status: "OK", code: response.statusCode));
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
  Future<Either<Exception, HelpTicket>> getTicket(String resourceId) async =>
      await _genericGetRequest<HelpTicket>("ticket", resourceId, HelpTicket.fromJson);
  @override
  Future<Either<Exception, UserProfile>> getUserProfile(String userId) async =>
      await _genericGetRequest<UserProfile>("profile", userId, UserProfile.fromJson);

  @override
  Future<Either<Exception, Promotion>> getPromotion(String resourceId) async =>
      await _genericGetRequest<Promotion>("promotion", resourceId, Promotion.fromJson);

  @override
  Future<Either<Exception, TransactionHistory>> getUserTransaction(String resourceId) async =>
      await _genericGetRequest<TransactionHistory>("history", resourceId, TransactionHistory.fromJson);

  @override
  Future<Either<Exception, Wallet>> getUserWallet(String resourceId) async =>
      await _genericGetRequest<Wallet>("wallet", resourceId, Wallet.fromJson);

  ///
  // @override
  // Future<Either<Exception, dynamic>> getAllUserPromotions(String userId) async =>
  //     await _genericGetAllRequest<Promotion>(
  //       collection: "promotion",
  //       resourceId: null,
  //       userId: userId,
  //     );
  @override
  Future<Either<Exception, dynamic>> getAllTickets(String userId) async => await _genericGetAllRequest<HelpRequest>(
      collection: "ticket", resourceId: null, userId: userId, transform: HelpRequest.fromJson);

  @override
  Future<Either<Exception, dynamic>> getAllUserTransaction(String userId) async =>
      await _genericGetAllRequest<TransactionHistory>(
          collection: "history", resourceId: null, userId: userId, transform: TransactionHistory.fromJson);

  Future<Either<Exception, T>> _genericGetRequest<T>(
      String collection, String resourceId, T Function(dynamic json) transform) async {
    try {
      var headers = {'x-nonce': await generateNonce(), 'Authorization': 'Bearer $storeApiKey'};
      var response = await httpClient.get(
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
        Exception(response.statusMessage),
      );
    } catch (e) {
      return left(
        Exception(
          e.toString(),
        ),
      );
    }
  }

  Future<Either<Exception, List<T>>> _genericGetAllRequest<T>(
      {required String collection,
      required String? resourceId,
      required String? userId,
      required T Function(dynamic json) transform}) async {
    try {
      var headers = {'x-nonce': await generateNonce(), 'Authorization': 'Bearer $storeApiKey'};
      var response = await httpClient.get('$collection/resource/${resourceId ?? ""}',
          options: Options(
            method: 'GET',
            headers: headers,
          ),
          queryParameters: (userId == null) ? null : {"profileId": userId});

      if (httpRequestIsSuccess(response.statusCode)) {
        return right(
          List.from(response.data).map((item) => transform(item)).toList(),
        );
      }
      return left(
        Exception(response.statusMessage),
      );
    } catch (e) {
      debugPrint(e.toString());
      return left(
        Exception(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<GenericApiError, UserProfile>> postUserProfile(UserProfile user) async =>
      await _genericPostRequest<UserProfile>("profile", user.toJson(), UserProfile.fromJson);

  @override
  Future<Either<GenericApiError, Promotion>> postUserPromotions(Promotion promotion) async =>
      await _genericPostRequest<Promotion>("promotion", promotion.toJson(), Promotion.fromJson);

  @override
  Future<Either<GenericApiError, TransactionHistory>> postUserTransaction(TransactionHistory transaction) async =>
      await _genericPostRequest<TransactionHistory>("history", transaction.toJson(), TransactionHistory.fromJson);

  @override
  Future<Either<GenericApiError, HelpTicket>> postHelpTicket(HelpTicket helpTicket) async =>
      await _genericPostRequest("ticket", helpTicket.toJson(), HelpTicket.fromJson);

  @override
  Future<Either<GenericApiError, Wallet>> postUserWallet(Wallet wallet) async =>
      await _genericPostRequest<Wallet>("wallet", wallet.toJson(), Wallet.fromJson);

  Future<Either<GenericApiError, T>> _genericPostRequest<T>(
      String collection, dynamic data, T Function(dynamic json) transform) async {
    try {
      var headers = {
        'x-nonce': await generateNonce(),
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $storeApiKey'
      };
      var response = await httpClient.post(
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
        return left(GenericApiError(error: "Error Occurred", status: "$statusCode"));
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
  Future<Either<GenericApiError, UserProfile>> putUserProfile(UserProfile user) async =>
      await _genericPutRequest<UserProfile>("profile", user.toJson(), UserProfile.fromJson);

  @override
  Future<Either<GenericApiError, Promotion>> putUserPromotions(Promotion promotion) async =>
      await _genericPutRequest<Promotion>("promotion", promotion.toJson(), Promotion.fromJson);

  @override
  Future<Either<GenericApiError, TransactionHistory>> putUserTransaction(TransactionHistory transaction) async =>
      await _genericPutRequest<TransactionHistory>("history", transaction.toJson(), TransactionHistory.fromJson);

  @override
  Future<Either<GenericApiError, Wallet>> putUserWallet(Wallet wallet) async =>
      await _genericPutRequest<Wallet>("wallet", wallet.toJson(), Wallet.fromJson);

  @override
  Future<Either<GenericApiError, HelpTicket>> putHelpTicket(HelpTicket helpTicket) async =>
      _genericPutRequest("ticket", helpTicket.toJson(), HelpTicket.fromJson);

  Future<Either<GenericApiError, T>> _genericPutRequest<T>(
      String collection, dynamic data, T Function(dynamic json) transform) async {
    try {
      var headers = {
        'x-nonce': await generateNonce(),
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $storeApiKey'
      };
      var response = await httpClient.put(
        '$collection/resource',
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
        return left(GenericApiError(error: "Error Occurred", status: "$statusCode"));
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
  Future<Either<Exception, GenericResponse>> requestHelp(HelpRequest help) async {
    try {
      var headers = {
        'x-nonce': await generateNonce(),
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $storeApiKey'
      };

      var response = await httpClient.post(
        'help',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: help.toJson(),
      );
      var statusCode = response.statusCode;
      if (httpRequestIsSuccess(response.statusCode)) {
        return right(GenericResponse(status: "OK", code: statusCode));
      } else {
        return left(Exception("Error Occurred"));
      }
    } catch (e) {
      return left(
        Exception(e.toString()),
      );
    }
  }

  @override
  Future<ResourceHealthStatus> getHealthStatus() async {
    try {
      var headers = {'x-nonce': await generateNonce(), 'Authorization': 'Bearer $storeApiKey'};
      var response = await httpClient.get(
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
}
