import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class IDDocumentScanner extends StatefulWidget {
  final DocumentType documentType;
  final VoidCallback onNext;
  final void Function(File file, DetectSide side) onCapture;
  final void Function(List<String> msgs) onMessage;
  final void Function(CameraEventsState state) onStateChanged;

  const IDDocumentScanner(
      {super.key,
      required this.onNext,
      required this.onCapture,
      required this.onMessage,
      required this.documentType,
      required this.onStateChanged});

  @override
  _IDDocumentScannerState createState() => _IDDocumentScannerState();
}

class _IDDocumentScannerState extends State<IDDocumentScanner> {
  CameraController? _cameraController;
  bool _isProcessing = false;
  final textDetector = TextRecognizer();
  String? barcodeText;
  List<String> messages = [];
  String? pdf417BarcodesText;
  String machineReadableCode = '';
  String machineReadableCode2 = '';
  List? facesFound;
  List<Map?> imageFiles = [];
  Rect? detectedCardRect;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(camera, ResolutionPreset.high);
    await _cameraController!.initialize();
    _cameraController!.setFlashMode(FlashMode.off);
    _cameraController!.startImageStream((CameraImage image) {
      if (!_isProcessing) {
        _isProcessing = true;
        processImage(image);
      }
    });
    setState(() {});
  }

  Future<void> processImage(CameraImage image) async {
    try {
      final inputImage = getInputImage(image);
      final hasCode39Barcode = await processBarcodeImage(inputImage);
      final hasCodePdf417Barcode = await processPdf417Image(inputImage);
      final hasFace = await processFaceImage(inputImage);
      final recognizedText = await textDetector.processImage(inputImage);
      DetectSide? detectedSide = detectSide(recognizedText);
      final hasMrzCode = await processMachineReadableImage(recognizedText);

      var allFalse =
          !(hasCode39Barcode || hasCodePdf417Barcode || hasFace || hasMrzCode);

      if (!allFalse) {
        if (widget.documentType == DocumentType.passport) {
          var missingPart = !hasFace
              ? 'Portrait'
              : (!hasMrzCode)
                  ? 'Machine Readable Zone'
                  : (detectedSide != DetectSide.front)
                      ? 'Personal Details Section'
                      : 'Some Landmarks';
          messages.add(
              '$missingPart is missing from the ${widget.documentType.name}');
        } else {
          var missingPart = !hasFace
              ? 'Portrait'
              : (!hasCode39Barcode)
                  ? 'The 39 Barcode'
                  : (!hasCodePdf417Barcode)
                      ? 'The Pdf417 Barcode'
                      : (detectedSide == null)
                          ? 'Personal Details Section'
                          : 'Some Landmarks';

          messages.add(missingPart);
        }
      }
      widget.onMessage(messages);

      debugPrint('$hasCodePdf417Barcode|$hasMrzCode|$hasFace|$hasCode39Barcode|');

      if (detectedSide != null) {
        if (hasCode39Barcode &&
            detectedSide == DetectSide.back &&
            hasCodePdf417Barcode &&
            widget.documentType != DocumentType.passport) {
          await captureImage(detectedSide.name);
          if (imageFiles.length == 2) {
            await _cameraController!.stopImageStream();
          }
        }
        if (hasCode39Barcode &&
            detectedSide == DetectSide.front &&
            hasMrzCode &&
            widget.documentType == DocumentType.passport) {
          await captureImage(detectedSide.name);
          if (imageFiles.length == 2) {
            await _cameraController!.stopImageStream();
          }
        }

        if (hasFace && detectedSide == DetectSide.front) {
          await captureImage(detectedSide.name);
          if (imageFiles.length == 2) {
            await _cameraController!.stopImageStream();
          }
        }
      }
    } catch (e) {
      debugPrint('Error processing image: $e');
    } finally {
      _isProcessing = false;

      setState(() {});
    }
  }

  bool processMachineReadableImage(RecognizedText recognizedText) =>
      recognizedText.blocks.any((block) {
        try {
          debugPrint('MachineReadableZone : ${block.text}');
          var hasMRZIdentifiers = block.text.contains(RegExp(r'>>|<<|>|<'));
          var startSegment = block.text.startsWith(RegExp(r'P'));

          if (hasMRZIdentifiers &&
              machineReadableCode.contains(block.text) == false) {
            setState(() {
              if (startSegment) {
                machineReadableCode = '${block.text}$machineReadableCode';
              } else {
                machineReadableCode += block.text;
              }
              machineReadableCode2 += block.text;
            });
          }

          /// and has a decent length;

          if (hasMRZIdentifiers) {
            messages = [];
            messages.add('Scanning the front page of a passport');
          }

          return hasMRZIdentifiers;
        } catch (e) {
          debugPrint('Error processing image: $e');
          return false;
        }
      });

  Future<bool> processPdf417Image(InputImage inputImage) async {
    try {
      final pdf417BarcodeScanner = BarcodeScanner(formats: [BarcodeFormat.pdf417]);
      final pdf417Barcodes =
          await pdf417BarcodeScanner.processImage(inputImage);
      if (pdf417Barcodes.isNotEmpty) {
        setState(() {
          pdf417BarcodesText = pdf417Barcodes.first.rawValue;
        });
        debugPrint('Detected Process Pdf417 Image with text: $pdf417BarcodesText');

        return true;
      } else {
        pdf417BarcodesText = null;
      }

      return false;
    } catch (e) {
      debugPrint('Error processing image: $e');

      return false;
    }
  }

  Future<bool> processGenericBarcodeImage(InputImage inputImage) async {
    try {
      final barcodeScanner =
          BarcodeScanner(formats: [BarcodeFormat.all]);
      final barcodes = await barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        // setState(() {
        //   barcodeText = barcodes.first.rawValue;
        // });
        debugPrint('Detected barcode with text: $barcodeText');

        return true;
      } else {
        // barcodeText = null;
      }

      return false;
    } catch (e) {
      debugPrint('Error processing image: $e');

      return false;
    }
  }

  Future<bool> processBarcodeImage(InputImage inputImage) async {
    try {
      final barcodeScanner =
          BarcodeScanner(formats: [BarcodeFormat.code39]);
      final barcodes = await barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        setState(() {
          barcodeText = barcodes.first.rawValue;
        });
        debugPrint('Detected barcode with text: $barcodeText');

        return true;
      } else {
        barcodeText = null;
      }

      return false;
    } catch (e) {
      debugPrint('Error processing image: $e');

      return false;
    }
  }

  Future<bool> processFaceImage(InputImage inputImage) async {
    final faceScanner = FaceDetector(options: FaceDetectorOptions());

    try {
      final faces = await faceScanner.processImage(inputImage);
      if (faces.isNotEmpty) {
        setState(() {
          facesFound = faces;
        });
        debugPrint('Detected face on the image');

        return true;
      } else {
        facesFound = [];

        return false;
      }
    } catch (e) {
      debugPrint('Error processing image: $e');

      return false;
    }
  }

  InputImage getInputImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: imageSize,
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.bgra8888,
        bytesPerRow: bytes.offsetInBytes,
        // planeData: planeData,
      ),
    );
  }

  DetectSide? detectSide(RecognizedText recognizedText) {
    bool isFront = recognizedText.blocks.any((block) {
      debugPrint('BLOCKS: ${block.text}');
      var value = block.text
          .contains(RegExp(r'Surname|Names|Sex|Nationality|Identity Number'));

      if (value) {
        setState(() {
          detectedCardRect = block.boundingBox;
        });
      }
      return value;
    });
    bool isBack = widget.documentType == DocumentType.passport
        ? false
        : recognizedText.blocks.any((block) {
            debugPrint('BLOCKS FROM BACK: ${block.text}');
            bool value =
                block.text.contains(RegExp(r'Conditions|Date Of Issue'));

            if (value) {
              setState(() {
                detectedCardRect = block.boundingBox;
              });
            }
            return value;
          });
    if (isFront) return DetectSide.front;
    if (isBack) return DetectSide.back;
    return null;
  }

  Future<void> captureImage(String side) async {
    final image = await _cameraController!.takePicture();
    debugPrint('Captured $side image: ${image.path}');
    if (mounted && imageFiles.where((i) => i?['side'] == side).isEmpty) {
      setState(() {
        messages = [];
        imageFiles.add({'side': side, 'file': File(image.path)});
      });
    }
    widget.onCapture(
        File(image.path), DetectSide.values.where((e) => e.name == side).first);

    debugPrint('BARCODE TEXT: $barcodeText \n\n');
    debugPrint('Pdf417 Barcodes Text: $pdf417BarcodesText \n\n');
    debugPrint('MachineReadableCode: $machineReadableCode \n\n');
    debugPrint('MachineReadableCode2: $machineReadableCode2 \n\n');
    debugPrint(
        'MachineReadableCode3: ${machineReadableCode.split(' ').toSet().join('|')} \n\n');
    debugPrint(
        'MachineReadableCode4: ${split3(machineReadableCode2).toSet().join('|')} \n\n');
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    textDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          child:
              _cameraController != null && _cameraController!.value.isInitialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        CameraPreview(_cameraController!),
                        if (widget.documentType == DocumentType.passport)
                          CustomOverlay(
                            aspectRatio: 2 / 3,
                            borderColor: Colors.red,
                            type: widget.documentType,
                          )
                        else
                          CustomOverlay(
                            aspectRatio: 2 / 3,
                            borderColor: Colors.blue,
                            type: widget.documentType,
                          ),
      
                        if (DocumentType.passport != widget.documentType
                            ? imageFiles.length < 2
                            : imageFiles.isEmpty)
                          Positioned(
                            top: 10,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              color: Colors.yellowAccent.shade700,
                              child: const Column(
                                children: [
                                  Text(
                                    'Position your ID document within the on-screen guidelines.',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  // ...messages
                                  //     .toSet()
                                  //     .map((text) => Text(text))
                                  //     .toList()
                                ],
                              ),
                            ),
                          ),
                        if (imageFiles.isNotEmpty)
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Column(
                              children: imageFiles
                                  .map((imageFile) => Card(
                                        clipBehavior: Clip.hardEdge,
                                        child: Column(
                                          children: [
                                            Text(imageFile?['side']),
                                            Image.file(
                                              imageFile?['file'],
                                              height: 180,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
      
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Container(
                              color: Colors.black,
                              child: Text(
                                  widget.documentType.name.split('_').join(' '))),
                        ),
      
                        ///
      
                        if (DocumentType.passport != widget.documentType
                            ? (imageFiles.isNotEmpty && imageFiles.length == 2)
                            : (imageFiles.isNotEmpty && imageFiles.length == 1))
                          AnimatedPositioned(
                            bottom: 20,
                            right: 20,
                            curve: Curves.elasticInOut,
                            duration: const Duration(milliseconds: 250),
                            child: FloatingActionButton.extended(
                              onPressed: widget.onNext,
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
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

enum DetectSide { front, back }

class CustomOverlay extends StatelessWidget {
  final double aspectRatio;
  final Color borderColor;
  final DocumentType type;

  const CustomOverlay(
      {super.key, required this.aspectRatio,
      required this.borderColor,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: borderColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned(
              left: 10,
              child: RotatedText('Bottom'),
            ),
            Positioned(
              bottom: 10,
              child: RotatedText('Right'),
            ),
            Positioned(
              right: 10,
              child: RotatedText('Top'),
            ),
            Positioned(
              top: 10,
              child: RotatedText('Left'),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget RotatedText(String text) => RotatedBox(
      quarterTurns: 1,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
        color: Colors.white,
        child: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );

class CardPainter extends CustomPainter {
  CardPainter({required this.imageSize, this.cardRect});
  final Size imageSize;
  final Rect? cardRect;
  double? scaleX, scaleY;

  @override
  void paint(Canvas canvas, Size size) {
    if (cardRect == null) return;

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.green;

    scaleX = size.width / imageSize.width;
    scaleY = size.height / imageSize.height;

    canvas.drawRRect(
        _scaleRect(
            rect: cardRect!, widgetSize: size, scaleX: scaleX, scaleY: scaleY),
        paint);
  }

  @override
  bool shouldRepaint(CardPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize ||
        oldDelegate.cardRect != cardRect;
  }
}

RRect _scaleRect(
    {required Rect rect,
    required Size widgetSize,
    double? scaleX,
    double? scaleY}) {
  return RRect.fromLTRBR(
      (widgetSize.width - rect.left.toDouble() * scaleX!),
      rect.top.toDouble() * scaleY!,
      widgetSize.width - rect.right.toDouble() * scaleX,
      rect.bottom.toDouble() * scaleY,
      const Radius.circular(10));
}

List<String> split3(String str) {
  str = str.split(' ').join('|');
  str = str.split('>').join('|');
  str = str.split('<').join('|');
  return str.split('|');
}

class CameraEventsState {
  final String? idCode39Text;
  final String? idPdf417Text;
  final String? passportMRZtext;
  const CameraEventsState(
      this.idCode39Text, this.idPdf417Text, this.passportMRZtext);
}

enum DocumentType { id_card, driver_license, passport }