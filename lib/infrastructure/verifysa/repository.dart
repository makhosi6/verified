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
  final Dio httpClient;

  VerifySaRepository(this.httpClient);

  @override
  Future<Either<Exception, ContactTracingResponse>> contactTracing(String phoneNumber, EnquiryReason reason) async {
    try {
      var headers = {'Content-Type': 'multipart/form-data', 'Accept': 'application/json'};
      var data = FormData.fromMap({
        'api_key': verifySaApiKey,
        'contact_number': phoneNumber,
        'reason': reason.value,
      });

      var response = await httpClient.post(
        '/contact_enquiry',
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
  Future<Either<Exception, VerifyIdResponse>> verifyIdNumber(String idNumber, EnquiryReason reason) async {
    try {
      var headers = {'Content-Type': 'multipart/form-data', 'Accept': 'application/json'};
      var data = FormData.fromMap({
        'api_key': verifySaApiKey,
        'id_number': idNumber,
        'reason': reason.value,
      });

      var response = await httpClient.post(
        '/said_verification',
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
  Future<Either<Exception, DhaImageResponse>> getDhaIdPhoto(String idNumber, EnquiryReason reason) async {
    try {
      var headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
      };
      var data = FormData.fromMap(
        {
          'api_key': verifySaApiKey,
          'id_number': idNumber,
          'enquiry_reason': reason.value,
        },
      );

      var response = await httpClient.post(
        '/home_affairs_id_photo',
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
