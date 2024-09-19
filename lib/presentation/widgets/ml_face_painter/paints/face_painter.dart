import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/presentation/widgets/ml_face_painter/res/app_images.dart';
import 'package:verified/presentation/widgets/ml_face_painter/res/enums.dart';

class FacePainter extends CustomPainter {
  FacePainter({required this.imageSize, this.face, required this.indicatorShape, this.indicatorAssetImage});
  final Size imageSize;
  double? scaleX, scaleY;
  final Face? face;
  final IndicatorShape indicatorShape;
  final String? indicatorAssetImage;
  @override
  void paint(Canvas canvas, Size size) {
    if (face == null) return;

    Paint paint;

    if (face!.headEulerAngleY! > 10 || face!.headEulerAngleY! < -10) {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.red;
    } else {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.green;
    }

    scaleX = size.width / imageSize.width;
    scaleY = size.height / imageSize.height;

    switch (indicatorShape) {
      case IndicatorShape.defaultShape:
        canvas.drawPath(
          _defaultPath(rect: face!.boundingBox, widgetSize: size, scaleX: scaleX, scaleY: scaleY),
          paint, // Adjust color as needed
        );
        break;
      case IndicatorShape.square:
        canvas.drawRRect(_scaleRect(rect: face!.boundingBox, widgetSize: size, scaleX: scaleX, scaleY: scaleY), paint);
        break;
      case IndicatorShape.circle:
        canvas.drawCircle(
          _circleOffset(rect: face!.boundingBox, widgetSize: size, scaleX: scaleX, scaleY: scaleY),
          face!.boundingBox.width / 2 * scaleX!,
          paint, // Adjust color as needed
        );
        break;
      case IndicatorShape.triangle:
      case IndicatorShape.triangleInverted:
        canvas.drawPath(
          _trianglePath(
              rect: face!.boundingBox,
              widgetSize: size,
              scaleX: scaleX,
              scaleY: scaleY,
              isInverted: indicatorShape == IndicatorShape.triangleInverted),
          paint, // Adjust color as needed
        );
        break;
      case IndicatorShape.image:
        final AssetImage image = AssetImage(indicatorAssetImage ?? AppImages.faceNet);
        final ImageStream imageStream = image.resolve(ImageConfiguration.empty);

        imageStream.addListener(ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
          final rect = face!.boundingBox;
          final Rect destinationRect = Rect.fromPoints(
            Offset(size.width - rect.left.toDouble() * scaleX!, rect.top.toDouble() * scaleY!),
            Offset(size.width - rect.right.toDouble() * scaleX!, rect.bottom.toDouble() * scaleY!),
          );

          canvas.drawImageRect(
            imageInfo.image,
            Rect.fromLTRB(0, 0, imageInfo.image.width.toDouble(), imageInfo.image.height.toDouble()),
            destinationRect,
            Paint(),
          );
        }));
        break;
      case IndicatorShape.none:
        break;
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.face != face;
  }
}

Path _defaultPath({required Rect rect, required Size widgetSize, double? scaleX, double? scaleY}) {
  double cornerExtension = 30.0; // Adjust the length of the corner extensions as needed

  double left = widgetSize.width - rect.left.toDouble() * scaleX!;
  double right = widgetSize.width - rect.right.toDouble() * scaleX;
  double top = rect.top.toDouble() * scaleY!;
  double bottom = rect.bottom.toDouble() * scaleY;
  return Path()
    ..moveTo(left - cornerExtension, top)
    ..lineTo(left, top)
    ..lineTo(left, top + cornerExtension)
    ..moveTo(right + cornerExtension, top)
    ..lineTo(right, top)
    ..lineTo(right, top + cornerExtension)
    ..moveTo(left - cornerExtension, bottom)
    ..lineTo(left, bottom)
    ..lineTo(left, bottom - cornerExtension)
    ..moveTo(right + cornerExtension, bottom)
    ..lineTo(right, bottom)
    ..lineTo(right, bottom - cornerExtension);
}

RRect _scaleRect({required Rect rect, required Size widgetSize, double? scaleX, double? scaleY}) {
  return RRect.fromLTRBR((widgetSize.width - rect.left.toDouble() * scaleX!), rect.top.toDouble() * scaleY!,
      widgetSize.width - rect.right.toDouble() * scaleX, rect.bottom.toDouble() * scaleY, const Radius.circular(10));
}

Offset _circleOffset({required Rect rect, required Size widgetSize, double? scaleX, double? scaleY}) {
  return Offset(
    (widgetSize.width - rect.center.dx * scaleX!),
    rect.center.dy * scaleY!,
  );
}

Path _trianglePath(
    {required Rect rect, required Size widgetSize, double? scaleX, double? scaleY, bool isInverted = false}) {
  if (isInverted) {
    return Path()
      ..moveTo(widgetSize.width - rect.center.dx * scaleX!, rect.bottom.toDouble() * scaleY!)
      ..lineTo(widgetSize.width - rect.left.toDouble() * scaleX, rect.top.toDouble() * scaleY)
      ..lineTo(widgetSize.width - rect.right.toDouble() * scaleX, rect.top.toDouble() * scaleY)
      ..close();
  }
  return Path()
    ..moveTo(widgetSize.width - rect.center.dx * scaleX!, rect.top.toDouble() * scaleY!)
    ..lineTo(widgetSize.width - rect.left.toDouble() * scaleX, rect.bottom.toDouble() * scaleY)
    ..lineTo(widgetSize.width - rect.right.toDouble() * scaleX, rect.bottom.toDouble() * scaleY)
    ..close();
}

class FaceCamera {
  static List<CameraDescription> _cameras = [];

  /// Initialize device cameras
  static Future<void> initialize() async {
    /// Fetch the available cameras before initializing the app.
    try {
      _cameras = await availableCameras();
    } on CameraException catch (error) {
      verifiedErrorLogger(error, StackTrace.current);
    }
  }

  /// Returns available cameras
  static List<CameraDescription> get cameras {
    return _cameras;
  }
}
