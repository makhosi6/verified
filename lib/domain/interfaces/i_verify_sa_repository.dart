import 'package:dartz/dartz.dart';
import 'package:verify_sa/domain/models/contact_tracing_response.dart';
import 'package:verify_sa/domain/models/verify_Id_response.dart';

abstract class IVerifySaRepository {
  Future<Either<Exception, VerifyIdResponse>> verifyIdNumber(String idNumber);
  Future<Either<Exception, ContactTracingResponse>> contactTracing(
    String phoneNumber,
  );
}
