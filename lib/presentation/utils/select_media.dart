// ignore_for_file: prefer_single_quotes

import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as Image;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_asset_picker/gallery_asset_picker.dart';
import 'package:verified/app_config.dart';
import 'package:verified/domain/models/help_ticket.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/presentation/theme.dart';

dynamic selectMediaConfig() => GalleryAssetPicker.initialize(GalleryConfig(
      enableCamera: true,
      crossAxisCount: 3,
      colorScheme: ColorScheme.light(primary: primaryColor),
      onReachMaximum: () {
        Fluttertoast.showToast(
          msg: 'You have reached the allowed number of images',
        );
      },
    ));

Future<MultipartFile?> convertToFormData(File? file, {String side = 'file'}) async {
  if (file == null) return null;
  String fileName = file.path.split('/').last;
  MultipartFile multipartFile = await MultipartFile.fromFile(file.path, filename: "${side}_$fileName");
  return multipartFile;
}

/// Compress an input file to 320x320
Future<File> compressForProfilePicture(File imageFile) async {
  try {
    final filename = imageFile.path.split('/').last;
    final ogFileName = filename.split('.').first;
    final ogFileExt = filename.split('.').last;

    final imageBytes = await imageFile.readAsBytes();

    final decodedImage = Image.decodeImage(imageBytes);

    // Resize image to 320x320
    final resizedImage = Image.copyResize(decodedImage!, width: 320, height: 320);

    final resizedImageData = Image.encodePng(resizedImage);

    final compressedImageData = await FlutterImageCompress.compressWithList(
      resizedImageData,
      quality: 50,
    );

    // Create a temporary path for the compressed file
    final tempDir = await getTemporaryDirectory(); 
    final compressedFile = File('${tempDir.path}/${ogFileName}_compressed.$ogFileExt');

    // Write compressed data to the file
    await compressedFile.writeAsBytes(compressedImageData);

    return compressedFile;
  } catch (error, stackTrace) {
      verifiedErrorLogger(error, stackTrace);

    return imageFile;
  }
}

/// Check if a given list of files exceed the maximum allow side for uploads.
/// - If it over the size the function will fail with Future of false,
/// - If it is below it will pass with a Future of true
bool checkTotalFileSizeIsWithLimits(List<Upload> files) {
  if (files.isEmpty) return true;
  int totalSize = 0;
  for (var file in files) {
    final fileSize = file.size?.toInt() ?? 0;
    totalSize += fileSize;
    verifiedLogger('  - File: ${file.filename}, Size: ${formatSize(fileSize)}');
    if (totalSize > MAX_FILE_SIZE_ALLOWED) {
      verifiedLogger('  - Total size exceeds limit (${formatSize(totalSize)}/${formatSize(MAX_FILE_SIZE_ALLOWED)}})');
      verifiedLogger('>>>> File size exceeds limit! ');
      return false;
    }
  }

  verifiedLogger('All files fit within the allowed size (${formatSize(totalSize)}/${formatSize(MAX_FILE_SIZE_ALLOWED)}).');
  verifiedLogger('>>>> File size is within limit.');
  return true;
}

// Helper function to format size in a readable way (optional)
String formatSize(int bytes) {
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
  const divisor = 1024;
  var value = bytes.toDouble();
  for (var i = 0; i < suffixes.length; i++) {
    if (value < divisor) {
      return "${value.toStringAsFixed(2)}${suffixes[i]}";
    }
    value /= divisor;
  }
  return "${value.toStringAsFixed(2)}${suffixes.last}";
}
