import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/globals.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/dotted_line.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/history/history_list_item.dart';

class SuccessfulPaymentModal extends StatefulWidget {
  final String topUpAmount;
  const SuccessfulPaymentModal({super.key, required this.topUpAmount});

  /// convert to stateless and use a confetti with Bloc
  @override
  State<SuccessfulPaymentModal> createState() => _SuccessfulPaymentModalState();
}

class _SuccessfulPaymentModalState extends State<SuccessfulPaymentModal> {
  ///
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();

    _controllerCenter = ConfettiController(
      duration: const Duration(seconds: 5),
    )..play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: appConstraints.maxWidth,
              minWidth: 400.0,
              maxHeight: 550.0,
            ),
            padding: primaryPadding,
            margin: primaryPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  const _Polygon8(),

                  ///header for the explainer
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        const Text(
                          'Payment Success',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0,
                            fontStyle: FontStyle.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0,
                            vertical: 12.0,
                          ),
                          child: Text(
                            'Your payment of ${widget.topUpAmount} has been successfully processed. Thank you for your top-up! 🎉',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: neutralDarkGrey,
                              fontSize: 14.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ///
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      children: [
                        Text(
                          'Total payment',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: neutralDarkGrey,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          widget.topUpAmount,
                          style: GoogleFonts.dmSans(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          ),
                          textAlign: TextAlign.right,
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: DottedLine(
                      color: neutralDarkGrey,
                    ),
                  ),

                  ListItemBanner(
                    type: BannerType.learn_more,
                    bgColor: scaffoldBackgroundColor,
                    leadingIcon: Icons.rocket_launch_outlined,
                    leadingBgColor: primaryColor,
                    title: 'Get the most out of Verified',
                    subtitle: '',
                    buttonText: 'Learn More',
                    onTap: () {},
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: BaseButton(
                      key: UniqueKey(),
                      onTap: () => Navigator.pop(context),
                      label: 'Done',
                      color: neutralGrey,
                      hasIcon: false,
                      bgColor: primaryColor,
                      buttonIcon: Icon(
                        Icons.lock_outline,
                        color: primaryColor,
                      ),
                      buttonSize: ButtonSize.large,
                      hasBorderLining: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        /// confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality.explosive, // don't specify a direction, blast randomly
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
            createParticlePath: createParticlePath,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }
}

class _Polygon8 extends StatelessWidget {
  const _Polygon8();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ///
        SizedBox(
          width: 100.0,
          child: ClipPolygon(
            sides: 8,
            borderRadius: 8.0,
            rotate: 90.0,
            boxShadows: [
              PolygonBoxShadow(color: darkerPrimaryColor, elevation: 1.0),
              PolygonBoxShadow(color: Colors.grey, elevation: 1.0)
            ],
            child: Container(
              color: darkerPrimaryColor,
              width: 30.0,
              height: 30.0,
            ),
          ),
        ),

        ///
        SizedBox(
          width: 80.0,
          child: ClipPolygon(
            sides: 8,
            borderRadius: 8.0,
            rotate: 90.0,
            boxShadows: const [],
            child: Container(
              color: neutralYellow,
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 54.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum ConfettiShape { Circle, Square, Triangle, Star, Heart, Flower, Animal, Letter, Number, AndMore }

Path createParticlePath(Size size) {
  try {
    var path;
    final random = Random();
    final shape = ConfettiShape.values[random.nextInt(ConfettiShape.values.length)];

    switch (shape) {
      case ConfettiShape.Circle:
        path = drawRectangle(size);
        break;
      case ConfettiShape.Square:
        path = drawSquare(size);
        break;
      case ConfettiShape.Triangle:
        path = drawCircle(size);
        break;
      case ConfettiShape.Star:
        path = drawCircle2(size);
        break;
      case ConfettiShape.Heart:
        path = drawRectangle(size, curvedEdges: true);
        break;
      case ConfettiShape.Flower:
        path = drawRectangle2(size);
        break;
      case ConfettiShape.Animal:
        path = drawSquare2(size);
        break;
      case ConfettiShape.Letter:
        path = drawRectangle(size, curvedEdges: true);
        break;
      case ConfettiShape.Number:
        path = drawRectangle(size, curvedEdges: true);
        break;
      case ConfettiShape.AndMore:
        path = drawStar(size);
        break;
    }

    path ??= drawStar(size);

    return path;
  } catch (error, stackTrace) {
      verifiedErrorLogger(error, stackTrace);
    return drawStar(size);
  }
}

Path drawStar(Size size) {
  // Method to convert degree to radians
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 3.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}

Path drawRectangle(Size size, {bool curvedEdges = false, double cornerRadius = 10.0}) {
  final path = Path();
  final double maxSize = min(size.width, size.height); // Get the smaller dimension

  // Adjust based on star size (assuming star uses externalRadius)
  final double adjustedWidth = maxSize;
  final double adjustedHeight = maxSize / 2.5; // Similar to internal radius of star

  if (curvedEdges) {
    path.moveTo(adjustedWidth / 2, 0);
    path.arcToPoint(Offset(adjustedWidth, adjustedHeight), radius: Radius.circular(cornerRadius), clockwise: false);
    path.lineTo(adjustedWidth, maxSize);
    path.arcToPoint(Offset(adjustedWidth / 2, maxSize), radius: Radius.circular(cornerRadius), clockwise: false);
    path.lineTo(0, maxSize);
    path.arcToPoint(Offset(0, adjustedHeight), radius: Radius.circular(cornerRadius), clockwise: false);
    path.lineTo(0, 0);
    path.arcToPoint(Offset(adjustedWidth / 2, 0), radius: Radius.circular(cornerRadius), clockwise: false);
  } else {
    path.addRect(Rect.fromLTWH(0, 0, adjustedWidth, adjustedHeight));
  }

  path.close();
  return path;
}

Path drawSquare(Size size) {
  final path = Path();
  final double maxSize = min(size.width, size.height);
  final double adjustedSide = maxSize; // Similar to external radius of star

  path.addRect(Rect.fromLTWH(
      adjustedSide / 2 - adjustedSide / 2, adjustedSide / 2 - adjustedSide / 2, adjustedSide, adjustedSide));
  path.close();
  return path;
}

Path drawCircle(Size size) {
  final path = Path();
  final double maxSize = min(size.width, size.height);
  final adjustedRadius = maxSize / 2; // Similar to external radius of star

  final center = Offset(size.width / 2, size.height / 2);
  path.addOval(Rect.fromCircle(center: center, radius: adjustedRadius));
  path.close();
  return path;
}

Path drawCircle2(Size size) {
  final path = Path();

  final random = Random();

  final radius = size.width * 0.025; // Adjust radius proportionally

  for (int i = 0; i < 10; i++) {
    final centerX = random.nextDouble() * size.width;
    final centerY = random.nextDouble() * size.height;

    path.addOval(Rect.fromCircle(center: Offset(centerX, centerY), radius: radius));
  }

  return path;
}

Path drawSquare2(Size size) {
  final path = Path();

  final random = Random();

  final sideLength = size.width * 0.1; // Adjust side length proportionally

  for (int i = 0; i < 10; i++) {
    final x = random.nextDouble() * (size.width - sideLength);
    final y = random.nextDouble() * (size.height - sideLength);

    path.addRect(Rect.fromLTWH(x, y, sideLength, sideLength));
  }

  return path;
}

Path drawRectangle2(Size size) {
  final path = Path();

  final random = Random();

  final rectWidth = size.width * 0.4; // Adjust width proportionally
  final rectHeight = size.width * 0.1; // Adjust height proportionally

  final centerX = size.width / 2;
  final centerY = size.height / 2;

  for (int i = 0; i < 10; i++) {
    final x = random.nextDouble() * (size.width - rectWidth);
    final y = random.nextDouble() * (size.height - rectHeight);

    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, rectWidth, rectHeight),
        Radius.circular(size.width * 0.05), // Adjust corner radius proportionally
      ),
    );
  }

  return path;
}
