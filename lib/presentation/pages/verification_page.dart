import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/presentation/pages/choose_document_type_page.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/blinking_animation.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/scanner_guidelines.dart';
import 'package:verified/presentation/utils/select_media.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';

var _smartCameraGlobalKey = GlobalKey<SmartFaceCameraState>();

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  File? _capturedImage;
  bool hasPoorLighting = false;
  num brightnessLevel = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///
    final verificationArgs = ModalRoute.of(context)?.settings.arguments as VerificationPageArgs?;

    /// safeArea padding
    final tp = MediaQuery.of(context).padding.top;
    final bp = MediaQuery.of(context).padding.bottom;

    /// safeArea height
    final height = MediaQuery.of(context).size.height - (tp + bp);
    final width = MediaQuery.of(context).size.width;

    /// preview image
    final previewImageHeight = height;
    final previewImageWidth = width;

    return WillPopScope(
      onWillPop: () async {
        navigate(context, page: const HomePage(), replaceCurrentPage: true);
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: SizedBox(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SmartFaceCamera(
                  key: _smartCameraGlobalKey,
                  backBtn: VerifiedBackButton(
                    key: UniqueKey(),
                    isLight: true,
                    onTap: () => navigate(
                      context,
                      page: const HomePage(),
                      replaceCurrentPage: true,
                    ),
                  ),
                  onCapture: (image) {
                    ///
                    if (mounted && image != null) {
                      FlutterBeep.beep();
                      setState(() {
                        _capturedImage = image;
                      });
                    }
                  },
                  messageBuilder: (context, face, lighting, brLevel) {
                    ///
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        hasPoorLighting = lighting ?? false;
                        brightnessLevel = brLevel;
                      });
                    });
                    if (lighting == true) {
                      return _message('Lighting is too dim to capture images');
                    }

                    ///
                    if (face == null) {
                      return _message('Place your face in the camera');
                    }

                    ///
                    if (!face.wellPositioned) {
                      return _message('Center your face in the square');
                    }

                    ///
                    return null;
                  },
                ),

                if (_capturedImage != null)
                  Container(
                    width: height,
                    height: width,
                    color: Colors.black,
                  ),
                if (_capturedImage != null)
                  SafeArea(
                    child: Center(
                      child: Container(
                        width: previewImageWidth,
                        height: previewImageHeight,
                        color: Colors.black,
                        child: Image.file(
                          _capturedImage!,
                          width: previewImageWidth,
                          height: previewImageHeight,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                ///
                if (_capturedImage != null)
                  Positioned(
                    top: 30,
                    right: 30,
                    child: SafeArea(
                      child: IconButton(
                          alignment: Alignment.topLeft,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(errorColor),
                            padding: MaterialStateProperty.all(primaryPadding),
                          ),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            try {
                              setState(() {
                                _capturedImage = null;
                              });
                              _smartCameraGlobalKey.currentState?.controller.initialize();
                            } catch (err, stackTrace) {
                              debugPrintStack(stackTrace: stackTrace, label: err.toString());
                            }
                          }),
                    ),
                  )
                else
                  const ScanDocsGuidelines(documentType: null),

                ///
                if (hasPoorLighting && _capturedImage == null && brightnessLevel < 120)
                  BlinkingAnimation(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 50, minHeight: 0),
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 0.874),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.light_mode_outlined,
                                  color: Colors.amberAccent.shade400,
                                ),
                                const Text('Poor Lighting Detected!'),
                              ],
                            ),
                            Text('Brightness Level:  ${brightnessLevel.ceil()} / 120')
                          ],
                        ),
                      ),
                    ),
                  ),

                ///
                if (_capturedImage != null)
                Positioned(
                    bottom: 20,
                    right: 20,
                    // curve: Curves.elasticInOut,
                    // duration: const Duration(milliseconds: 250),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        convertToFormData(_capturedImage).then((fileData) {
                          if (_capturedImage != null && fileData != null) {
                            context.read<StoreBloc>().add(
                                  StoreEvent.uploadSelfieImage(fileData),
                                );
                          }
                        }).catchError((err) {
                          verifiedErrorLogger(err);
                        }, test: (_) {
                          return true;
                        });

                        navigate(
                          context,
                          page: ChooseDocumentPage(verificationArgs: verificationArgs),
                          replaceCurrentPage: true,
                        );
                      },
                      label: const Row(
                        children: [
                          Text(' Proceed '),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),

                ///
              ],
            ),
          )),
    );
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
        ),
      );

  @override
  void dispose() {
    super.dispose();
  }
}

class VerificationPageArgs {
  final String uuid;
  VerificationPageArgs(this.uuid);
}
