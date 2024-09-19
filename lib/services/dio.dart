// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:verified/app_config.dart';
import 'package:verified/helpers/logger.dart';

class VerifySaDioClientService {
  /// instance of dio (singleton)
  static Dio instance = Dio(
    BaseOptions(
      baseUrl: '$baseUrl/verify-id/api/v1/',
      headers: {
        'Authorization': 'Bearer $verifySaApiKey',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    ),
  )..interceptors.addAll(interceptors);

  static List<Interceptor> interceptors = [
    /// logger
    // PrettyDioLogger(),

    /// for the purpose of caching
    InterceptorsWrapper(
      onRequest: onRequest,
      onResponse: onResponse,
      onError: onError,
    ),
  ];

  /// Do something before request is sent.
  /// If you want to resolve the request with custom data,
  /// you can resolve a `Response` using `handler.resolve(response)`.
  /// If you want to reject the request with a error message,
  /// you can reject with a `DioException` using `handler.reject(dioError)`.
  static onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    verifiedLogger(options.headers);
    return handler.next(options);
  }

  /// Do something with response data.
  /// If you want to reject the request with a error message,
  /// you can reject a `DioException` object using `handler.reject(dioError)`.
  static onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  /// Do something with response error.
  /// If you want to resolve the request with some custom data,
  /// you can resolve a `Response` object using `handler.resolve(response)`.
  static onError(DioException e, ErrorInterceptorHandler handler) {
    return handler.next(e);
  }
}

class StoreDioClientService {
  /// instance of dio (singleton)
  static Dio instance = Dio(
    BaseOptions(
      // baseUrl: '$baseUrl/store/api/v1/',
      baseUrl: 'http://192.168.0.132:5400/api/v1/',
      headers: {
        'Authorization': 'Bearer $storeApiKey',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    ),
  )..interceptors.addAll(interceptors);

  static List<Interceptor> interceptors = [
    /// logger
    // PrettyDioLogger(),

    /// for the purpose of caching
    InterceptorsWrapper(
      onRequest: onRequest,
      onResponse: onResponse,
      onError: onError,
    ),
  ];

  /// Do something before request is sent.
  /// If you want to resolve the request with custom data,
  /// you can resolve a `Response` using `handler.resolve(response)`.
  /// If you want to reject the request with a error message,
  /// you can reject with a `DioException` using `handler.reject(dioError)`.
  static onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    verifiedLogger(options.headers);
    return handler.next(options);
  }

  /// Do something with response data.
  /// If you want to reject the request with a error message,
  /// you can reject a `DioException` object using `handler.reject(dioError)`.
  static onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  /// Do something with response error.
  /// If you want to resolve the request with some custom data,
  /// you can resolve a `Response` object using `handler.resolve(response)`.
  static onError(DioException e, ErrorInterceptorHandler handler) {
    return handler.next(e);
  }
}

class PaymentsDioClientService {
  /// instance of dio (singleton)
  static Dio instance = Dio(
    BaseOptions(
      baseUrl: '$baseUrl/payments/api/v1/',
      headers: {
        'Authorization': 'Bearer $storeApiKey',
        // 'x-nonce': 'MjAyM184XzI1XzFfMTc1MTMyYjJmOTkwMDE1NmVkOTIzNmU0YTc3M2Y2ZGNhOGUxNzUxMzJiMmY5MWY3MjM2',
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    ),
  )..interceptors.addAll(interceptors);

  static List<Interceptor> interceptors = [
    /// logger
    PrettyDioLogger(),

    /// for the purpose of caching
    InterceptorsWrapper(
      onRequest: onRequest,
      onResponse: onResponse,
      onError: onError,
    ),
  ];

  /// Do something before request is sent.
  /// If you want to resolve the request with custom data,
  /// you can resolve a `Response` using `handler.resolve(response)`.
  /// If you want to reject the request with a error message,
  /// you can reject with a `DioException` using `handler.reject(dioError)`.
  static onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    verifiedLogger(options.headers);
    return handler.next(options);
  }

  /// Do something with response data.
  /// If you want to reject the request with a error message,
  /// you can reject a `DioException` object using `handler.reject(dioError)`.
  static onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  /// Do something with response error.
  /// If you want to resolve the request with some custom data,
  /// you can resolve a `Response` object using `handler.resolve(response)`.
  static onError(DioException e, ErrorInterceptorHandler handler) {
    return handler.next(e);
  }
}

/// HTTP request is a success
bool httpRequestIsSuccess(int? status) => switch (status) {
      200 => true,
      201 => true,
      204 => true,
      304 => true,
      _ => false,
    };



/// sui - secondary unique-identifier for the  client 