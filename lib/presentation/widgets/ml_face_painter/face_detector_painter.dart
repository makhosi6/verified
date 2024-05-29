import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:verified/presentation/theme.dart';
import 'coordinates_translator.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(
    this.faces,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );
  bool isFaceCloseEnough = false;
  final List<Face> faces;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint ovalPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = primaryColor;

    final Paint overlayPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black.withOpacity(0.2);

    for (final Face face in faces) {
      final faceBoundingBox = face.boundingBox;
      isFaceCloseEnough = _isFaceCloseEnough(faceBoundingBox);
      var faceMarkerBorderColor = (isFaceCloseEnough) ? primaryColor : errorColor;
      ovalPaint.color = faceMarkerBorderColor;
      final left = translateX(
        face.boundingBox.left,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final top = translateY(
        face.boundingBox.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final right = translateX(
        face.boundingBox.right,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final bottom = translateY(
        face.boundingBox.bottom,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );

      // Calculate the oval bounds
      const double factor = 1.15; 
      final double ovalWidth = (right - left) / factor;
      final double ovalHeight = (bottom - top) * factor;
      final double ovalCenterX = (left + right) / 2;
      final double ovalCenterY = (top + bottom) / 2;
      final Rect ovalRect = Rect.fromCenter(
        center: Offset(ovalCenterX, ovalCenterY),
        width: ovalWidth,
        height: ovalHeight,
      );

      // Draw the transparent black overlay
      final Path overlayPath = Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addOval(ovalRect)
        ..fillType = PathFillType.evenOdd;
      canvas.drawPath(overlayPath, overlayPaint);

      // Draw the oval with a thick green border
      canvas.drawOval(ovalRect, ovalPaint);
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
  

  bool _isFaceCloseEnough(Rect boundingBox) {
    const closeThreshold = 0.3;
    final imageWidth = imageSize.width;
    final imageHeight = imageSize.height;

    final faceArea = boundingBox.width * boundingBox.height;
    final imageArea = imageWidth * imageHeight;

    return (faceArea / imageArea) > closeThreshold;
  }
}
