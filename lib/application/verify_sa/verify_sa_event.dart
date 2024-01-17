part of 'verify_sa_bloc.dart';

@freezed
class VerifySaEvent with _$VerifySaEvent {
  const factory VerifySaEvent.apiHealthCheck() = ApiHealthCheck;
  const factory VerifySaEvent.getDhaIdPhoto(String idNumber, EnquiryReason reason) = GetDhaIdPhoto;
  const factory VerifySaEvent.verifyIdNumber(String idNumber, EnquiryReason reason) = VerifyIdNumber;
  const factory VerifySaEvent.contactTracing(String phoneNumber, EnquiryReason reason) = ContactTracing;
}
