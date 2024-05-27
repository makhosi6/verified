import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CameraProvider(),
      child: MaterialApp(
        home: FaceDetectionScreen(),
      ),
    );
  }
}

class CameraProvider with ChangeNotifier {
  CameraController? cameraController;
  bool isDetecting = false;
  late FaceDetector faceDetector;
  List<Face> faces = [];

  CameraProvider() {
    initializeCamera();
    faceDetector = GoogleMlKit.vision.faceDetector();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.where((c) => c.lensDirection == CameraLensDirection.front).first;

    cameraController = CameraController(
      camera,
      ResolutionPreset.high,
    );

    await cameraController!.initialize();

    cameraController!.startImageStream((CameraImage image) async {
      if (isDetecting) return;

      isDetecting = true;

      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();
      final InputImage? inputImage = await _inputImageFromCameraImage(image);
      final InputImage inputImage2 = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg, // used only in Android
          format: TargetPlatform.android == defaultTargetPlatform ? InputImageFormat.nv21 : InputImageFormat.bgra8888,
          bytesPerRow: image.planes.first.bytesPerRow, // used only in iOS
        ),
      );

      faces = await faceDetector.processImage(inputImage ?? inputImage2);

      isDetecting = false;
      notifyListeners();
    });
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };
  Future<InputImage?> _inputImageFromCameraImage(CameraImage image) async {
    if (cameraController == null) return null;
    final cameras = await availableCameras();
    final camera = cameras.where((c) => c.lensDirection == CameraLensDirection.front).first;

    final sensorOrientation = camera.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[cameraController!.value.deviceOrientation];
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
  void dispose() {
    cameraController?.dispose();
    faceDetector.close();
    super.dispose();
  }
}

class FaceDetectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(context);

    return Scaffold(
        appBar: AppBar(title: const Text('Face Detection')),
        body: Stack(
          children: [
            CameraPreview(cameraProvider.cameraController!),
            CustomPaint(
              painter: FacePainter(cameraProvider.faces),
            ),
            if (cameraProvider.faces.isNotEmpty)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: ElevatedButton(
                  onPressed: () async {
                    final image = await cameraProvider.cameraController!.takePicture();
                    // Save or use the captured image here.
                  },
                  child: Text('Take Selfie'),
                ),
              ),
            Text('${cameraProvider.cameraController != null} - ${cameraProvider.cameraController!.value.isInitialized}')
          ],
        ));
  }
}

class FacePainter extends CustomPainter {
  final List<Face> faces;

  FacePainter(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    for (final face in faces) {
      canvas.drawRect(
        face.boundingBox,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
