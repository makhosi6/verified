import 'package:verified/domain/models/help_ticket.dart';

class UploadResponse {
  UploadResponse({
    this.message,
    this.files,
    this.file,
  });

  UploadResponse.fromJson(dynamic json) {
    message = json['message'];
    file = json['file'];
    if (json['files'] != null) {
      files = [];
      json['files'].forEach((v) {
        files?.add(Upload.fromJson(v));
      });
    }
  }
  String? message;
  List<Upload>? files;
  Upload? file;
  UploadResponse copyWith({
    String? message,
    Upload? file,
    List<Upload>? files,
  }) =>
      UploadResponse(
        message: message ?? this.message,
        files: files ?? files,
        file: file ?? file,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['file'] = file;
    if (files != null) {
      map['files'] = files?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
