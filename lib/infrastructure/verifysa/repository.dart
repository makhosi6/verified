import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:verify_sa/app_config.dart';
import 'package:verify_sa/domain/interfaces/i_verify_sa_repository.dart';
import 'package:verify_sa/domain/models/contact_tracing_response.dart';
import 'package:verify_sa/domain/models/verify_Id_response.dart';

class VerifySaRepository implements IVerifySaRepository {
  final Dio httpClient;

  VerifySaRepository(this.httpClient);

  @override
  Future<Either<Exception, ContactTracingResponse>> contactTracing(
      String phoneNumber) async {
    try {
      var headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json'
      };
      var data = FormData.fromMap(
          {'api_key': verifySaApiKey, 'contact_number': phoneNumber});

      var response = await httpClient.post(
        '/contact_enquiry',
        options: Options(
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        return right(ContactTracingResponse.fromJson(response.data));
      } else {
        return left(Exception(response.statusMessage));
      }
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, VerifyIdResponse>> verifyIdNumber(
      String idNumber) async {
    try {
      var headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json'
      };
      var data = FormData.fromMap({
        'api_key': verifySaApiKey,
        'id_number': idNumber,
      });

      var response = await httpClient.post(
        '/said_verification',
        options: Options(
          headers: headers,
        ),
        data: data,
      );
      if (response.statusCode == 200) {
        return right(VerifyIdResponse.fromJson(response.data));
      } else {
        return left(Exception(response.statusMessage));
      }
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }
}
