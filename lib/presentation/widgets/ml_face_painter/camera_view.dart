import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/ml_face_painter/face_detector_painter.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
  }) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  static List<CameraDescription> _cameras = [];
  final _cameraLensDirection = CameraLensDirection.front;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  CameraController? _controller;
  XFile? _capturedImage;
  bool _canProcess = true;
  bool _isBusy = false;
  bool _hasFaces = false;
  List<Face> _faces = [];
  CustomPaint? _customPaint;
  bool isFaceCloseEnough = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
      }
    }).whenComplete(_startLiveFeed);
  }

  Future _startLiveFeed() async {
    final camera = _cameras.where((c) => c.lensDirection == _cameraLensDirection).first;
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      _controller?.startImageStream(_processCameraImage);
      if (mounted) setState(() {});
    });
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    final faces = await _faceDetector.processImage(inputImage);
    _hasFaces = faces.isNotEmpty;
    _faces = faces;
    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      isFaceCloseEnough = painter.isFaceCloseEnough;
      _customPaint = CustomPaint(painter: painter);
    } else {
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _canProcess = false;
    _faceDetector.close();
    _controller = null;
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    _processImage(inputImage);
    if (mounted) setState(() {});
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final camera = _cameras.where((c) => c.lensDirection == _cameraLensDirection).first;
    final sensorOrientation = camera.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// safeArea padding
    final tp = MediaQuery.of(context).padding.top;
    final bp = MediaQuery.of(context).padding.bottom;

    /// safeArea height
    final height = MediaQuery.of(context).size.height - (tp + bp);
    final width = MediaQuery.of(context).size.width;

    ///
    if (_cameras.isEmpty) return const SizedBox.shrink();
    if (_controller == null) return const SizedBox.shrink();
    if (_controller?.value.isInitialized == false) return const SizedBox.shrink();

    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: [
       
              Center(
                child: Container(
                  // height: height,
                  // width: width,
                  color: Colors.blue,
                  child: CameraPreview(
                    _controller!,
                    child: _customPaint,
                  ),
                ),
              ),
              // Positioned(
              //   left: 0,
              //   right: 0,
              //   bottom: 0,
              //   child: Container(
              //     color: Colors.black45,
              //     // padding: const EdgeInsets.all(10),
              //     // child: const Text(
              //     //   'Position your face inside the guide.',
              //     //   style: TextStyle(color: Colors.white),
              //     //   textAlign: TextAlign.center,
              //     // ),
              //   ),
              // ),
          
          Positioned(
            bottom: 90,
            left: 20,
            child: Center(
              child: Text(
                'Camera: ${_cameraLensDirection.name}\nHas Faces: $_hasFaces\nNumber Of Faces: ${_faces.length}\nImage: /data/${_capturedImage?.path.split('/').last}\nFace Close Enough: $isFaceCloseEnough\nIs Busy: $_isBusy\nCan Process: $_canProcess',
                style: GoogleFonts.sourceCodePro(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          _backButton(),
          _imagePreview(context),
          _takeOrRetakePhotoBtns(),
        ],
      ),
    );
  }

  _takeOrRetakePhotoBtns() => Positioned(
        bottom: 16,
        left: 16,
        right: 16,
        child: Row(
          children: [
            Flexible(
              child: BaseButton(
                key: UniqueKey(),
                onTap: () => print(_capturedImage),
                label: 'Done ${_capturedImage == null ? ' (Disabled) ' : ''}',
                buttonIcon: const Icon(Icons.done),
                buttonSize: ButtonSize.small,
                hasBorderLining: true,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: BaseButton(
                key: UniqueKey(),
                onTap: () async {
                  if (mounted) {
                    setState(() {
                      _capturedImage = null;
                    });

                    var img = await _controller?.takePicture();
                    setState(() {
                      _capturedImage = img;
                    });

                    FlutterBeep.beep();
                  }
                },
                label: _capturedImage != null
                    ? 'Retake ${_capturedImage == null ? ' (Disabled) ' : ''}'
                    : 'Take Selfie ${_hasFaces ? '' : ' (Disabled) '}',
                buttonIcon: const Icon(Icons.free_breakfast_outlined),
                buttonSize: ButtonSize.small,
                hasBorderLining: true,
              ),
            )
          ],
        ),
      );

  _imagePreview(BuildContext context) {
    /// safeArea padding
    final tp = MediaQuery.of(context).padding.top;
    final bp = MediaQuery.of(context).padding.bottom;

    /// safeArea height
    final height = MediaQuery.of(context).size.height - (tp + bp);
    final width = MediaQuery.of(context).size.width;

    /// preview image
    const previewImageHeight = 250.0;
    const previewImageWidth = previewImageHeight * (4 / 5);

    return AnimatedPositioned(
      width: _capturedImage != null ? previewImageWidth : 0,
      height: _capturedImage != null ? previewImageHeight : 0,
      top: _capturedImage != null ? 18 : height / 2,
      right: _capturedImage != null ? -20 : width / 2,
      duration: const Duration(milliseconds: 700),
      curve: Curves.elasticInOut,
      child: Container(
        color: Colors.transparent,
        child: AspectRatio(
          aspectRatio: 4 / 5,
          child: _capturedImage == null
              ? const SizedBox.shrink()
              : Image.file(
                  File(_capturedImage?.path ?? ''),
                  width: previewImageWidth,
                  height: previewImageHeight,
                ),
        ),
      ),
    );
  }

  Widget _backButton() => Positioned(
        top: 40,
        left: 8,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: FloatingActionButton(
            heroTag: Object(),
            onPressed: () => navigate(context, page: const HomePage(), replaceCurrentPage: true),
            backgroundColor: Colors.black54,
            child: const Icon(
              Icons.arrow_back_ios_outlined,
              size: 20,
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }
}
