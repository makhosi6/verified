import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as Image;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_asset_picker/gallery_asset_picker.dart';
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

Future<MultipartFile?> convertToFormData(File? file) async {
  if (file == null) return null;
  String fileName = file.path.split('/').last;
  MultipartFile multipartFile = await MultipartFile.fromFile(file.path, filename: fileName);
  return multipartFile;
}

/// Compress an input file to 320x320
Future<File> compressForProfilePicture(File imageFile) async {
  try {
    final filename = imageFile.path.split('/').last;
    final ogFileName = filename.split('.').first;
    final ogFileExt = filename.split('.').last;
    
    // Read image bytes
    final imageBytes = await imageFile.readAsBytes();

    // Decode image
    final decodedImage = Image.decodeImage(imageBytes);

    // Resize image to 320x320
    final resizedImage = Image.copyResize(decodedImage!, width: 320, height: 320);

    // Convert resized image to Uint8List
    final resizedImageData = Image.encodePng(resizedImage);

    // Compress the resized image data
    final compressedImageData = await FlutterImageCompress.compressWithList(
      resizedImageData,
      quality: 50,
    );

    // Create a temporary path for the compressed file
    final tempDir = await getTemporaryDirectory(); // Get a temporary directory path
    final compressedFile = File('${tempDir.path}/${ogFileName}_compressed.$ogFileExt');

    // Write compressed data to the file
    await compressedFile.writeAsBytes(compressedImageData);

    return compressedFile;
  } catch (e) {
    print('\n\ncompressForProfilePicture Error: $e');

    return imageFile;
  }
}
