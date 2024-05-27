import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:verified/presentation/widgets/ml_face_painter/face_detector_painter.dart';
import 'package:verified/presentation/widgets/ml_face_painter/camera_view.dart';
import 'package:verified/presentation/widgets/ml_face_painter/face_guide.dart';

class FaceDetectorPage extends StatefulWidget {
  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  bool _hasFaces = false;
  List<Face> _faces = [];
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
      faces: _faces,
      hasFaces: _hasFaces,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
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
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;

      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}

enum DetectorViewMode { liveFeed, gallery }

class DetectorView extends StatefulWidget {
  DetectorView({
    Key? key,
    required this.title,
    required this.onImage,
    this.customPaint,
    this.text,
    this.initialDetectionMode = DetectorViewMode.liveFeed,
    this.initialCameraLensDirection = CameraLensDirection.back,
    this.onCameraFeedReady,
    this.onDetectorViewModeChanged,
    this.onCameraLensDirectionChanged,
    required this.faces,
    required this.hasFaces,
  }) : super(key: key);

  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final DetectorViewMode initialDetectionMode;
  final Function(InputImage inputImage) onImage;
  final Function()? onCameraFeedReady;
  final Function(DetectorViewMode mode)? onDetectorViewModeChanged;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;
  final List<Face> faces;
  final bool hasFaces;

  @override
  State<DetectorView> createState() => _DetectorViewState();
}

class _DetectorViewState extends State<DetectorView> {
  late DetectorViewMode _mode;

  @override
  void initState() {
    _mode = widget.initialDetectionMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              CameraView(
                customPaint: widget.customPaint,
                onImage: widget.onImage,
                onCameraFeedReady: widget.onCameraFeedReady,
                onDetectorViewModeChanged: _onDetectorViewModeChanged,
                initialCameraLensDirection: widget.initialCameraLensDirection,
                onCameraLensDirectionChanged: widget.onCameraLensDirectionChanged,
                faces: widget.faces,
                hasFaces: widget.hasFaces,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.black45,
              )
            ],
          ),
          // Positioned(
          //   left: 0,
          //   right: 0,
          //   bottom: 0,
          //   child: Container(
          //     color: Colors.black45,
          //     padding: const EdgeInsets.all(10),
          //     child: const Text(
          //       'Position your face inside the guide.',
          //       style: TextStyle(color: Colors.white),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _onDetectorViewModeChanged() {
    print('MODE CHANGED: ${_mode}');
    // if (_mode == DetectorViewMode.liveFeed) {
    //   _mode = DetectorViewMode.gallery;
    // } else {
    //   _mode = DetectorViewMode.liveFeed;
    // }
    // if (widget.onDetectorViewModeChanged != null) {
    //   widget.onDetectorViewModeChanged!(_mode);
    // }
    // setState(() {});
  }
}
