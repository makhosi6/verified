import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_asset_picker/gallery_asset_picker.dart';
import 'package:verified/presentation/theme.dart';

selectMediaConfig() => GalleryAssetPicker.initialize(GalleryConfig(
      enableCamera: true,
      crossAxisCount: 3,
      colorScheme: ColorScheme.light(primary: primaryColor),
      onReachMaximum: () {
        Fluttertoast.showToast(
          msg: 'You have reached the allowed number of images',
        );
      },
    ));
