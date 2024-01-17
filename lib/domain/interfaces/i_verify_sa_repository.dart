import 'package:dartz/dartz.dart';
import 'package:verified/domain/models/contact_tracing_response.dart';
import 'package:verified/domain/models/dha_image_response.dart';
import 'package:verified/domain/models/enquiry_reason.dart';
import 'package:verified/domain/models/resource_health_status_enum.dart';
import 'package:verified/domain/models/verify_id_response.dart';

abstract class IVerifySaRepository {
  /// Get HEaLTH StaTUS
  Future<ResourceHealthStatus> getHealthStatus();
  Future<Either<Exception, VerifyIdResponse>> verifyIdNumber(String idNumber, EnquiryReason reason);
  Future<Either<Exception, DhaImageResponse>> getDhaIdPhoto(String idNumber, EnquiryReason reason);
  Future<Either<Exception, ContactTracingResponse>> contactTracing(String phoneNumber, EnquiryReason reason);
}
