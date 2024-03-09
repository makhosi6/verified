part of 'verify_sa_bloc.dart';

@freezed
class VerifySaEvent with _$VerifySaEvent {
  const factory VerifySaEvent.apiHealthCheck() = ApiHealthCheck;
  const factory VerifySaEvent.getDhaIdPhoto({required String idNumber,required EnquiryReason reason,required String clientId}) = GetDhaIdPhoto;
  const factory VerifySaEvent.verifyIdNumber({required String idNumber,required EnquiryReason reason,required String clientId}) = VerifyIdNumber;
  const factory VerifySaEvent.contactTracing({required String phoneNumber,required EnquiryReason reason,required String clientId}) = ContactTracing;
}
