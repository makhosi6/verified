import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:verified/app_config.dart';
import 'package:verified/domain/interfaces/i_verify_sa_repository.dart';
import 'package:verified/domain/models/contact_tracing_response.dart';
import 'package:verified/domain/models/dha_image_response.dart';
import 'package:verified/domain/models/enquiry_reason.dart';
import 'package:verified/domain/models/resource_health_status_enum.dart';
import 'package:verified/domain/models/verify_id_response.dart';
import 'package:verified/helpers/security/nonce.dart';
import 'package:verified/services/dio.dart';

class VerifySaRepository implements IVerifySaRepository {
  final Dio _httpClient;

  VerifySaRepository(this._httpClient);

  @override
  Future<Either<Exception, ContactTracingResponse>> contactTracing({
    required String phoneNumber,
    required EnquiryReason reason,
    required String clientId,
  }) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final data = {
        'contact_number': phoneNumber,
        'reason': reason.value,
      };

      final response = await _httpClient.post(
        '/contact_enquiry?client=$clientId',
        options: Options(
          headers: headers,
        ),
        data: data,
      );

      if (httpRequestIsSuccess(response.statusCode)) {
        return right(ContactTracingResponse.fromJson(response.data));
      } else {
        return left(Exception(response.statusMessage));
      }
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, VerifyIdResponse>> verifyIdNumber({
    required String idNumber,
    required EnquiryReason reason,
    required String clientId,
  }) async {
    try {
      final headers = {'Content-Type':'application/json'};
      final data = {
        'id_number': idNumber,
        'reason': reason.value,
      };

      final response = await _httpClient.post(
        '/said_verification?client=$clientId',
        options: Options(
          headers: headers,
        ),
        data: data,
      );
      if (httpRequestIsSuccess(response.statusCode)) {
        return right(VerifyIdResponse.fromJson(response.data));
      } else {
        return left(Exception(response.statusMessage));
      }
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, DhaImageResponse>> getDhaIdPhoto({
    required String idNumber,
    required EnquiryReason reason,
    required String clientId,
  }) async {
    try {
      final headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      };
      final data = 
        {
          'api_key': verifySaApiKey,
          'id_number': idNumber,
          'enquiry_reason': reason.value,
        };

      final response = await _httpClient.post(
        '/home_affairs_id_photo?client=$clientId',
        options: Options(
          headers: headers,
        ),
        data: data,
      );
      if (httpRequestIsSuccess(response.statusCode)) {
        return right(DhaImageResponse.fromJson(response.data));
      } else {
        return left(Exception(response.statusMessage));
      }
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<ResourceHealthStatus> getHealthStatus() async {
    try {
      final headers = {'x-nonce': await generateNonce(), 'Authorization': 'Bearer $storeApiKey'};
      final response = await _httpClient.get(
        'health-check?client=system',
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
