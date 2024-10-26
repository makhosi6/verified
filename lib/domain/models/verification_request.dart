import 'package:verified/domain/models/captured_candidate_details.dart';
import 'package:verified/domain/models/permit_upload_data.dart';
import 'package:verified/domain/models/upload_response.dart';
import 'package:verified/domain/models/candidate_request.dart';

class VerificationRequest {
  final CandidateRequest? candidateRequest;
  final CapturedCandidateDetails? capturedCandidateDetails;
  final UploadResponse? backUploadedDocFiles;
  final UploadResponse? frontUploadedDocFiles;
  final UploadResponse? uploadedSelfieImg;
  final PermitVisaUploadBean? permitUploadData;

  VerificationRequest(
      {this.candidateRequest,
      this.permitUploadData,
      this.capturedCandidateDetails,
      this.backUploadedDocFiles,
      this.frontUploadedDocFiles,
      this.uploadedSelfieImg});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'candidateRequest': candidateRequest?.toJson(),
      'capturedCandidateDetails': capturedCandidateDetails?.toJson(),
      'backUploadedDocFiles': backUploadedDocFiles?.toJson(),
      'frontUploadedDocFiles': frontUploadedDocFiles?.toJson(),
      'uploadedSelfieImg': uploadedSelfieImg?.toJson(),
      'permitUploadData': permitUploadData?.toJson(),
    };
  }
}
