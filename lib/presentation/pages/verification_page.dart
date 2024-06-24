import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/pages/id_document_scanner_page.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';

var _smartCameraGlobalKey = GlobalKey<SmartFaceCameraState>();

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  File? _capturedImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as VerificationPageArgs?;
    final uuid = args?.uuid;

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
                    onTap: () => navigate(context,
                        page: IDDocumentScanner(
                          documentType: DocumentType.id_card,
                          onCapture: (File file, DetectSide side) {},
                          onMessage: (List<String> msgs) {},
                          onStateChanged: (CameraEventsState state) {},
                          onNext: () {},
                        ),
                        replaceCurrentPage: true),
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
                  messageBuilder: (context, face) {
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
                  Center(
                    child: Container(
                      width: previewImageWidth,
                      height: previewImageHeight,
                      color: Colors.black87,
                      child: Image.file(
                        _capturedImage!,
                        width: previewImageWidth,
                        height: previewImageHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (_capturedImage != null)

                  ///
                  AnimatedPositioned(
                    bottom: 20,
                    right: 20,
                    curve: Curves.elasticInOut,
                    duration: const Duration(milliseconds: 250),
                    child: FloatingActionButton.extended(
                      key: UniqueKey(),
                      onPressed: () => navigate(
                        context,
                        page: IDDocumentScanner(
                          documentType: DocumentType.id_card,
                          onCapture: (File file, DetectSide side) {},
                          onMessage: (List<String> msgs) {},
                          onStateChanged: (CameraEventsState state) {},
                          onNext: () {},
                        ),
                        replaceCurrentPage: true,
                      ),
                      label: const Row(
                        children: [
                          Text(' Proceed '),
                          Icon(
                            Icons.arrow_forward,
                            size: 28,
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
