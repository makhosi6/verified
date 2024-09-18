import 'package:verified/domain/models/captured_verifee_details.dart';
import 'package:verified/domain/models/upload_response.dart';
import 'package:verified/domain/models/verifee_request.dart';

class VerificationRequest {
  final VerifeeRequest? verifeeRequest;
  final CapturedVerifeeDetails? capturedVerifeeDetails;
  final UploadResponse? backUploadedDocFiles;
  final UploadResponse? frontUploadedDocFiles;
  final UploadResponse? uploadedSelfieImg;

  VerificationRequest({this.verifeeRequest, this.capturedVerifeeDetails, this.backUploadedDocFiles, this.frontUploadedDocFiles, this.uploadedSelfieImg});


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'verifeeRequest': verifeeRequest?.toJson(),
      'capturedVerifeeDetails': capturedVerifeeDetails?.toJson(),
      'backUploadedDocFiles': backUploadedDocFiles?.toJson(),
      'frontUploadedDocFiles': frontUploadedDocFiles?.toJson(),
      'uploadedSelfieImg': uploadedSelfieImg?.toJson(),
    };
  }

}
