import 'package:dartz/dartz.dart';
import 'package:verify_sa/domain/models/contact_tracing_response.dart';
import 'package:verify_sa/domain/models/dha_image_response.dart';
import 'package:verify_sa/domain/models/enquiry_reason.dart';
import 'package:verify_sa/domain/models/resource_health_status_enum.dart';
import 'package:verify_sa/domain/models/verify_id_response.dart';

abstract class IVerifySaRepository {
  /// Get HEaLTH StaTUS
  Future<ResourceHealthStatus> getHealthStatus();
  Future<Either<Exception, VerifyIdResponse>> verifyIdNumber(String idNumber);
  Future<Either<Exception, DhaImageResponse>> getDhaIdPhoto(String idNumber, EnquiryReason reason);
  Future<Either<Exception, ContactTracingResponse>> contactTracing(
    String phoneNumber,
  );
}
