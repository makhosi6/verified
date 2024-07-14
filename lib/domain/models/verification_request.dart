import 'package:verified/domain/models/captured_verifee_details.dart';
import 'package:verified/domain/models/upload_response.dart';
import 'package:verified/domain/models/verifee_request.dart';

class VerificationRequest {
  final VerifeeRequest? verifeeRequest;
  final CapturedVerifeeDetails? capturedVerifeeDetails;
  final UploadResponse? uploadedDocFiles;
  final UploadResponse? uploadedSelfieImg;

  VerificationRequest({this.verifeeRequest, this.capturedVerifeeDetails, this.uploadedDocFiles, this.uploadedSelfieImg});


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'verifeeRequest': verifeeRequest?.toJson(),
      'capturedVerifeeDetails': capturedVerifeeDetails?.toJson(),
      'uploadedDocFiles': uploadedDocFiles?.toJson(),
      'uploadedSelfieImg': uploadedSelfieImg?.toJson(),
    };
  }

}
