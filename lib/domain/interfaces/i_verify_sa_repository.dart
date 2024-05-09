import 'package:dartz/dartz.dart';
import 'package:verified/domain/models/contact_tracing_response.dart';
import 'package:verified/domain/models/dha_image_response.dart';
import 'package:verified/domain/models/enquiry_reason.dart';
import 'package:verified/domain/models/resource_health_status_enum.dart';
import 'package:verified/domain/models/search_request.dart';
import 'package:verified/domain/models/verify_id_response.dart';

abstract class IVerifySaRepository {
  /// Get HEaLTH StaTUS
  Future<ResourceHealthStatus> getHealthStatus();
  Future<Either<Exception, VerifyIdResponse>> verifyIdNumber({required String idNumber,required EnquiryReason reason,required String clientId});
  Future<Either<Exception, VerifyComprehensiveResponse>> comprehensiveVerification({required SearchPerson? person,required String clientId});
  Future<Either<Exception, DhaImageResponse>> getDhaIdPhoto({required String idNumber,required EnquiryReason reason,required String clientId});
  Future<Either<Exception, ContactTracingResponse>> contactTracing({required String phoneNumber,required EnquiryReason reason, required String clientId});
}
