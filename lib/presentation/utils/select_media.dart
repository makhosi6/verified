import 'dart:io';

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
