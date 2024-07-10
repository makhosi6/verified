import 'dart:convert';
import 'package:flutter/foundation.dart';

///
String bytesToDataUrl(Uint8List bytes, String? extension) {
  String mimeType;
  switch (extension?.toLowerCase()) {
    case 'jpg':
    case 'jpeg':
      mimeType = 'image/jpeg';
      break;
    case 'png':
      mimeType = 'image/png';
      break;
    case 'gif':
      mimeType = 'image/gif';
      break;
    case 'bmp':
      mimeType = 'image/bmp';
      break;
    case 'webp':
      mimeType = 'image/webp';
      break;
    default:
      mimeType = 'image/jpeg';
  }

  String base64Data = base64Encode(bytes);

  return 'data:$mimeType;base64,$base64Data';
}

///
String getExtension(String filename) {
  int lastDotIndex = filename.lastIndexOf('.');

  if (lastDotIndex == -1 || lastDotIndex == filename.length - 1) {
    return '';
  }

  return filename.substring(lastDotIndex + 1).toLowerCase();
}
