// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/ml_face_painter/face_detector_painter.dart';
import 'package:verified/presentation/widgets/ml_face_painter/paints/face_painter.dart';
import 'package:verified/presentation/widgets/ml_face_painter/res/enums.dart';

final buttonTheme = _SecondaryCameraButtonTheme();

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
  // bool isFaceCloseEnough = false;
  var _activeAspectRatioOption = PortraitAspectRatio.a916;

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
    final faces = await _faceDetector.processImage(inputImage);
    _hasFaces = faces.isNotEmpty;
    _faces = faces;
    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
      final painter = FacePainter(
          imageSize: inputImage.metadata!.size,
          indicatorShape: IndicatorShape.defaultShape,
          face: (faces.isNotEmpty) ? faces.first : null);
// faces,
      // inputImage.metadata!.size,
      // inputImage.metadata!.rotation,
      // _cameraLensDirection,
      ///
      // isFaceCloseEnough = painter.isFaceCloseEnough;
      _customPaint = CustomPaint(painter: painter);
    } else {
      _customPaint = null;
    }
// print("${faces.length} ENOUGH FACES ${isFaceCloseEnough}");
    if (mounted) {
      setState(() {});
    }
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _canProcess = false;
    // _faceDetector.close();
    _controller = null;
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    print('WILLMPROCEED: $inputImage');
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

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _activeAspectRatioOption.toDouble(),
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

        // Positioned(
        //   bottom: 90,
        //   left: 20,
        //   child: Center(
        //     child: Text(
        //       'Camera: ${_cameraLensDirection.name}\nHas Faces: $_hasFaces\nNumber Of Faces: ${_faces.length}\nImage: /data/${_capturedImage?.path.split('/').last}\nFace Close Enough: $isFaceCloseEnough\nIs Busy: $_isBusy\nCan Process: $_canProcess',
        //       style: GoogleFonts.sourceCodePro(
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            width: width,
            height: height * 0.15,
            color: const Color.fromARGB(116, 0, 0, 0),
            child: Row(
              children: [_backButton()],
            ),
          ),
        ),
        _imagePreview(context),
        // _takeOrRetakePhotoBtns(),
        Positioned(
          bottom: height * 0.2,
          child: Align(
            alignment: Alignment.center,
            child: AspectRatioOptionsBtnGrp(
              setActiveAspectRatioOption: (value) {
                setState(() {
                  _activeAspectRatioOption = value;
                });
              },
              activeAspectRatioOption: _activeAspectRatioOption,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: width,
            height: height * 0.2,
            color: Colors.black54,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _faces.length > 1
                        ? 'Please ensure only one face is in frame'
                        : (
                            kReleaseMode
                                ? 'Please move closer to the camera '
                                : (_hasFaces == false ? 'No Face Detected' : '')),
                    style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Tooltip(
                    message: 'Done',
                    child: GestureDetector(
                      child: CircleSecondaryCameraBtn.icon(
                        icon: Icons.done_rounded,
                        iconColor: _capturedImage != null ? Colors.white : const Color.fromARGB(93, 193, 193, 193),
                        bgColor: _capturedImage != null ? primaryColor : null,
                      ),
                    ),
                  ),
                  IOSCameraButton(
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
                  ),
                  const CircleSecondaryCameraBtn.icon(
                    icon: Icons.flip_camera_android,
                    iconColor: Color.fromARGB(93, 193, 193, 193),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _takeOrRetakePhotoBtns() => Positioned(
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

  Widget _imagePreview(BuildContext context) {
    /// safeArea padding
    final tp = MediaQuery.of(context).padding.top;
    final bp = MediaQuery.of(context).padding.bottom;

    /// safeArea height
    final height = MediaQuery.of(context).size.height - (tp + bp);
    final width = MediaQuery.of(context).size.width;

    /// preview image
    const previewImageHeight = 180.0;
    const previewImageWidth = previewImageHeight * (2 / 3);

    return AnimatedPositioned(
      width: _capturedImage != null ? previewImageWidth : 0,
      height: _capturedImage != null ? previewImageHeight : 0,
      top: _capturedImage != null ? 18 : height / 2,
      right: _capturedImage != null ? 20 : width / 2,
      duration: const Duration(milliseconds: 700),
      curve: Curves.elasticInOut,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        clipBehavior: Clip.hardEdge,
        child: AspectRatio(
          aspectRatio: PortraitAspectRatio.a916.value,
          child: _capturedImage == null
              ? const SizedBox.shrink()
              : Image.file(
                  File(_capturedImage?.path ?? ''),
                  width: previewImageWidth,
                  height: previewImageHeight,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget _backButton() => VerifiedBackButton(
        key: UniqueKey(),
        isLight: true,
        onTap: () => navigate(context, page: const HomePage(), replaceCurrentPage: true),
      );

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }
}

enum PortraitAspectRatio {
  a23(2 / 3),
  a916(9 / 16),
  a45(4 / 5);
  // a11(1 / 1);

  const PortraitAspectRatio(this.value);

  final double value;

  @override
  String toString() => switch (this) {
        PortraitAspectRatio.a916 => '9:16',
        PortraitAspectRatio.a23 => '2:3',
        PortraitAspectRatio.a45 => '4:5',
        _ => '1:1'
      };

  double toDouble() => switch (this) {
        PortraitAspectRatio.a916 => PortraitAspectRatio.a916.value,
        PortraitAspectRatio.a23 => PortraitAspectRatio.a916.value,
        PortraitAspectRatio.a45 => PortraitAspectRatio.a916.value,
        _ => PortraitAspectRatio.a916.value
      };
}

class CircleSecondaryCameraBtn extends StatelessWidget {
  final Widget? child;
  final IconData? icon;
  final double size;
  final double scale;
  final Color? iconColor;
  final Color? bgColor;

  const CircleSecondaryCameraBtn.icon({
    super.key,
    this.size = 50.0,
    required IconData this.icon,
    this.scale = 1.0,
    this.iconColor,
    this.bgColor,
  }) : child = null;

  CircleSecondaryCameraBtn({
    super.key,
    this.size = 50.0,
    required Widget this.child,
    this.scale = 1.3,
    this.iconColor,
    this.bgColor,
  }) : icon = null;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: buttonTheme.shape,
      color: bgColor ?? buttonTheme.backgroundColor,
      child: Padding(
        padding: buttonTheme.padding * scale,
        child: child ??
            Icon(
              icon,
              color: iconColor ?? buttonTheme.foregroundColor,
              size: buttonTheme.iconSize * scale,
            ),
      ),
    );
  }
}

class _SecondaryCameraButtonTheme {
  final Color foregroundColor;
  final Color backgroundColor;
  final double iconSize;
  final EdgeInsets padding;
  final ShapeBorder shape;
  final bool rotateWithCamera;
  static const double baseIconSize = 25;

  _SecondaryCameraButtonTheme({
    this.foregroundColor = Colors.white,
    this.backgroundColor = Colors.black12,
    this.iconSize = baseIconSize,
    this.padding = const EdgeInsets.all(12),
    this.shape = const CircleBorder(),
    this.rotateWithCamera = true,
  });
}

class IOSCameraButton extends StatelessWidget {
  final VoidCallback onTap;
  const IOSCameraButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72.0,
        height: 72.0,
        decoration: const BoxDecoration(
          color: Color.fromARGB(70, 237, 237, 237),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(90, 222, 222, 222),
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AspectRatioOptionsBtnGrp extends StatelessWidget {
  final PortraitAspectRatio activeAspectRatioOption;

  final void Function(PortraitAspectRatio) setActiveAspectRatioOption;

  const AspectRatioOptionsBtnGrp({
    Key? key,
    required this.activeAspectRatioOption,
    required this.setActiveAspectRatioOption,
  }) : super(key: key);

  Widget _buildAspectRatioOptionsButton(PortraitAspectRatio value) {
    bool isActive = activeAspectRatioOption == value;
    return GestureDetector(
      onTap: () => setActiveAspectRatioOption(value),
      child: AnimatedContainer(
        padding: EdgeInsets.all(isActive ? 10 : 6),
        margin: EdgeInsets.symmetric(horizontal: isActive ? 4 : 2),
        duration: const Duration(milliseconds: 250),
        width: isActive ? 60 : 40,
        decoration: BoxDecoration(color: buttonTheme.backgroundColor, borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              value.toString(),
              style: TextStyle(
                color: isActive ? Colors.amber[700] : Colors.white,
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: primaryPadding,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: buttonTheme.backgroundColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: PortraitAspectRatio.values.map(_buildAspectRatioOptionsButton).toList(),
          ),
        ),
      ),
    );
  }
}

