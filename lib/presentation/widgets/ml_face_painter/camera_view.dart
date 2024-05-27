import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

class CameraView extends StatefulWidget {
  CameraView(
      {Key? key,
      required this.customPaint,
      required this.onImage,
      this.onCameraFeedReady,
      this.onDetectorViewModeChanged,
      this.onCameraLensDirectionChanged,
      this.initialCameraLensDirection = CameraLensDirection.back,
      required this.faces,
      required this.hasFaces})
      : super(key: key);

  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final VoidCallback? onCameraFeedReady;
  final VoidCallback? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;
  final List<Face> faces;
  final bool hasFaces;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  ///
  static List<CameraDescription> _cameras = [];

  ///
  CameraController? _controller;

  ///
  int _cameraIndex = -1;

  /// safeArea padding
  var topPadding = 0.0;
  var bottomPadding = 0.0;

  /// safeArea height
  var height = 0.0;
  var width = 0.0;

  @override
  void initState() {
    super.initState();

    ///
    _initialize();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      ///screen size
      topPadding = MediaQuery.of(context).padding.top;
      bottomPadding = MediaQuery.of(context).padding.bottom;
      height = MediaQuery.of(context).size.height - (topPadding + bottomPadding);
      width = MediaQuery.of(context).size.width;
    });

    super.didChangeDependencies();
  }

  var hasCloseEnoughFace = false;

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  XFile? capturedImage;

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(child: _liveFeedBody());
  }

  Widget _liveFeedBody() {
    if (_cameras.isEmpty) return const SizedBox.shrink();
    if (_controller == null) return const SizedBox.shrink();
    if (_controller?.value.isInitialized == false) return const SizedBox.shrink();

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Center(
          child: CameraPreview(
            _controller!,
            child: widget.customPaint,
          ),
        ),
        Positioned(
          bottom: 100,
          left: 20,
          child: Center(
            child: Text(
              'Has Faces: ${widget.hasFaces}\nNumber Of Faces: ${widget.faces.length}\nImage: ${capturedImage?.path.toLowerCase().replaceAll('com.byteestudio.verified', '')}\nFace Close Enough: $hasCloseEnoughFace',
              style: GoogleFonts.silkscreen(color: Colors.white),
            ),
          ),
        ),
        _backButton(),
        _imagePreview(),
        _takeOrRetakePhotoBtns()
      ],
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
                onTap: () => print(capturedImage),
                label: 'Done ${capturedImage == null ? ' (Disabled) ' : ''}',
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
                      capturedImage = null;
                    });

                    var img = await _controller?.takePicture();
                    setState(() {
                      capturedImage = img;
                    });

                    FlutterBeep.beep();
                  }
                },
                label: capturedImage != null
                    ? 'Retake ${capturedImage == null ? ' (Disabled) ' : ''}'
                    : 'Take Selfie ${widget.hasFaces ? '' : ' (Disabled) '}',
                buttonIcon: const Icon(Icons.free_breakfast_outlined),
                buttonSize: ButtonSize.small,
                hasBorderLining: true,
              ),
            )
          ],
        ),
      );

  _imagePreview() {
    /// preview image
    const previewImageHeight = 250.0;
    const previewImageWidth = previewImageHeight * (4 / 5);

    return AnimatedPositioned(
      width: capturedImage != null ? previewImageWidth : 0,
      height: capturedImage != null ? previewImageHeight : 0,
      top: capturedImage != null ? (20 + topPadding) : height / 2,
      right: capturedImage != null ? -20 : width / 2,
      duration: const Duration(milliseconds: 700),
      curve: Curves.elasticInOut,
      child: Container(
        color: Colors.transparent,
        child: AspectRatio(
          aspectRatio: 4 / 5,
          child: capturedImage == null
              ? const SizedBox.shrink()
              : Image.file(
                  File(capturedImage?.path ?? ''),
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

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
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

      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _switchLiveCamera() async {
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    widget.onImage(inputImage);
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
    final camera = _cameras[_cameraIndex];
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

    ///
    if (mounted && widget.faces.isEmpty) {
      setState(() {
        hasCloseEnoughFace = false;
      });
    }

    ///
    for (var i = 0; i < widget.faces.length; i++) {
      final face = widget.faces[i];
      final faceBoundingBox = face.boundingBox;

      setState(() {
        hasCloseEnoughFace = _isFaceCloseEnough(faceBoundingBox, Size(image.width.toDouble(), image.height.toDouble()));
      });
    }
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

  bool _isFaceCloseEnough(Rect boundingBox, Size imageSize) {
    const closeThreshold = 0.3;
    final imageWidth = imageSize.width;
    final imageHeight = imageSize.height;

    final faceArea = boundingBox.width * boundingBox.height;
    final imageArea = imageWidth * imageHeight;

    return (faceArea / imageArea) > closeThreshold;
  }
}
