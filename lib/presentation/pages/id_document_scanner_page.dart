// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:verified/helpers/image.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/blinking_animation.dart';
import 'package:verified/presentation/utils/document_type.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/scanner_guidelines.dart';

class IDDocumentScanner extends StatefulWidget {
  final DocumentType documentType;
  final void Function(BuildContext ctx, CameraEventsState? state) onNext;
  final void Function(File file, DetectSide side) onCapture;
  final void Function(List<String> msgs) onMessage;
  final void Function(CameraEventsState? state) onStateChanged;

  const IDDocumentScanner(
      {super.key,
      required this.onNext,
      required this.onCapture,
      required this.onMessage,
      required this.documentType,
      required this.onStateChanged});

  @override
  createState() => _IDDocumentScannerState();
}

class _IDDocumentScannerState extends State<IDDocumentScanner> {
  CameraController? _cameraController;
  bool _isProcessing = false;
  final textDetector = TextRecognizer();
  String? barcodeText;
  String? barcodeText2;
  List<String> messages = [];
  String? pdf417BarcodesText;
  String machineReadableCode = '';
  String machineReadableCode2 = '';
  List? facesFound;
  List<ImageFile> imageFiles = [];
  Rect? detectedCardRect;
  CameraEventsState? documentScannerState;
  num? brightness;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(camera, ResolutionPreset.high, enableAudio: false);
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
      final hasCode39Barcode2 = await processGenericBarcodeImage(inputImage);
      final hasCodePdf417Barcode = await processPdf417Image(inputImage);
      final hasFace = await processFaceImage(inputImage);
      final recognizedText = await textDetector.processImage(inputImage);
      final detectedSide = detectSide(recognizedText);
      final hasMrzCode = await processMachineReadableImage(recognizedText);
      final hasIdBookText = await idBookTextDetected(recognizedText);
      final allFalse = !(hasCode39Barcode || hasCodePdf417Barcode || hasFace || hasMrzCode || hasIdBookText);
      final _brightness = calculateImageBrightness(image);
      brightness = _brightness;

      /// reset messages
      messages = [];
      if (!allFalse) {
        if (widget.documentType == DocumentType.passport) {
          var missingPart = !hasFace
              ? 'Portrait'
              : (!hasMrzCode)
                  ? 'Machine Readable Zone'
                  : (detectedSide != DetectSide.front)
                      ? 'Personal Details Section'
                      : 'Some Landmarks';
          messages.add('$missingPart is missing from the ${widget.documentType.name}');
        } else if (widget.documentType == DocumentType.id_card) {
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
        } else if (DocumentType.id_book == widget.documentType) {
          var missingPart = !hasFace
              ? 'Portrait'
              : (!hasCode39Barcode)
                  ? 'The 39 Barcode'
                  : 'Some Landmarks';

          messages.add(missingPart);
        }
      }
      if (_brightness < 120) messages.add('poor brightness ($_brightness / 120)');

      messages = messages.toSet().toList();
      widget.onMessage(messages);

      debugPrint('($brightness)---->$hasCodePdf417Barcode|$hasMrzCode|$hasFace|$hasCode39Barcode|');

      if (detectedSide != null && _brightness > 120) {
        /// capture id_card back
        if (hasCode39Barcode &&
            detectedSide == DetectSide.back &&
            hasCodePdf417Barcode &&
            widget.documentType != DocumentType.passport) {
          await captureImage(detectedSide.name);
        }

        /// capture passport front
        if (hasCode39Barcode &&
            detectedSide == DetectSide.front &&
            hasMrzCode &&
            widget.documentType == DocumentType.passport) {
          await captureImage(detectedSide.name);
        }

        /// capture id_card front
        if (hasFace && detectedSide == DetectSide.front) {
          await captureImage(detectedSide.name);
        }
      }

      /// capture id_book front
      verifiedLogger('MAYBE IT\'S AN ID_BOOK $hasFace|$hasCode39Barcode|$hasCode39Barcode2|$hasIdBookText|$barcodeText');
      if (hasFace && (hasCode39Barcode2 || hasCode39Barcode) && hasIdBookText) {
        await captureImage(DetectSide.front.name);
      }

      ///
      if (mounted) setState(() {});
    } catch (error, stackTrace) {
      verifiedErrorLogger(error, stackTrace);
    } finally {
      _isProcessing = false;

      if (mounted) setState(() {});
    }
  }

  bool processMachineReadableImage(RecognizedText recognizedText) => recognizedText.blocks.any((block) {
        try {
          debugPrint('MachineReadableZone : ${block.text}');
          var hasMRZIdentifiers = block.text.contains(RegExp(r'>>|<<|>|<'));
          var startSegment = block.text.startsWith(RegExp(r'P'));

          if (hasMRZIdentifiers && machineReadableCode.contains(block.text) == false) {
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
        } catch (error, stackTrace) {
            verifiedErrorLogger(error, stackTrace);
          return false;
        }
      });

  Future<bool> processPdf417Image(InputImage inputImage) async {
    try {
      final pdf417BarcodeScanner = BarcodeScanner(formats: [BarcodeFormat.pdf417]);
      final pdf417Barcodes = await pdf417BarcodeScanner.processImage(inputImage);
      final raw = pdf417Barcodes.map((bc) => bc).whereType<Barcode>();
      final newData = raw.isNotEmpty ? raw.first.rawValue : null;
      if (raw.isNotEmpty && newData != null && mounted) {
        setState(() {
          pdf417BarcodesText = newData;
        });
        debugPrint('Detected Process Pdf417 Image with text: $pdf417BarcodesText');

        return true;
      }

      return false;
    } catch (error, stackTrace) {
        verifiedErrorLogger(error, stackTrace);

      return false;
    }
  }

  Future<bool> processGenericBarcodeImage(InputImage inputImage) async {
    try {
      final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.all]);
      final barcodes = await barcodeScanner.processImage(inputImage);
      final raw = barcodes.map((bc) => bc).whereType<Barcode>();
      final newData = raw.isNotEmpty ? raw.first.rawValue : null;
      if (raw.isNotEmpty && newData != null && mounted) {
        setState(() {
          barcodeText2 = newData;
        });
        debugPrint('(all) Detected barcode with text: $newData');

        return true;
      }

      return false;
    } catch (error, stackTrace) {
        verifiedErrorLogger(error, stackTrace);

      return false;
    }
  }

  Future<bool> processBarcodeImage(InputImage inputImage) async {
    try {
      final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.code39]);
      final barcodes = await barcodeScanner.processImage(inputImage);
      final raw = barcodes.map((bc) => bc).whereType<Barcode>();
      final newData = raw.isNotEmpty ? raw.first.rawValue : null;
      if (raw.isNotEmpty && newData != null && mounted) {
        setState(() {
          barcodeText = newData;
        });
        debugPrint('(code39) Detected barcode with text: $barcodeText');

        return true;
      }

      return false;
    } catch (error, stackTrace) {
        verifiedErrorLogger(error, stackTrace);

      return false;
    }
  }

  Future<bool> processFaceImage(InputImage inputImage) async {
    try {
      final faceScanner = FaceDetector(options: FaceDetectorOptions());
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
    } catch (error, stackTrace) {
        verifiedErrorLogger(error, stackTrace);

      return false;
    }
  }

  InputImage getInputImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

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

  bool idBookTextDetected(RecognizedText recognizedText) => recognizedText.blocks.any((block) {
        var value = block.text.contains(RegExp(
            r'S.A.BURGER/S.A.CITIZEN|S.A.BURGER|I.D.No.|I.D.No|SUID-AFR|FORENAMES|ISSUED BY AUTHORITY OF|THE DIRECTOR-GENERAL'));

        if (value) {
          setState(() {
            detectedCardRect = block.boundingBox;
          });
        }
        return value;
      });
  DetectSide? detectSide(RecognizedText recognizedText) {
    bool isFront = recognizedText.blocks.any((block) {
      debugPrint('BLOCKS: ${block.text}');
      var value = block.text.contains(RegExp(r'Surname|Names|Sex|Nationality|Identity Number'));

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
            bool value = block.text.contains(RegExp(r'Conditions|Date Of Issue'));

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
    try {
      final image = await _cameraController!.takePicture();
      debugPrint('Captured $side image: ${image.path}');
      if (mounted && imageFiles.where((i) => i.side == side).isEmpty) {
        messages = [];
        imageFiles.add(ImageFile(side: side, file: File(image.path)));
        FlutterBeep.beep();
      }
      documentScannerState = CameraEventsState(
        idCode39Text: barcodeText,
        idCode39Text2: barcodeText2,
        idPdf417Text: pdf417BarcodesText,
        passportMRZtext: '',
        imageFiles: imageFiles,
        cameraLightingLevel: brightness,
      );

      widget.onStateChanged(documentScannerState);
      // widget.onCapture(File(image.path), DetectSide.values.where((e) => e.name == side).first);
      debugPrint('BARCODE TEXT: $barcodeText \n\n');
      debugPrint('BARCODE TEXT_2: $barcodeText2 \n\n');
      debugPrint('Pdf417 Barcodes Text: $pdf417BarcodesText \n\n');
      debugPrint('MachineReadableCode: $machineReadableCode \n\n');
      debugPrint('MachineReadableCode2: $machineReadableCode2 \n\n');
      debugPrint('MachineReadableCode3: ${machineReadableCode.split(' ').toSet().join('|')} \n\n');
      debugPrint('MachineReadableCode4: ${split3(machineReadableCode2).toSet().join('|')} \n\n');
      debugPrint('documentScannerState: ${documentScannerState?.imageFiles.length} \n\n');
    } catch (error, stackTrace) {
      verifiedErrorLogger(error, stackTrace);
    } finally {
      setState(() {});
    }
  }

  double calculateImageBrightness(CameraImage image) {
    final bytes = image.planes[0].bytes;
    int totalBrightness = 0;
    for (int i = 0; i < bytes.length; i += image.planes[0].bytesPerPixel!) {
      totalBrightness += bytes[i];
    }
    return totalBrightness / bytes.length;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    textDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigate(context, page: const HomePage(), replaceCurrentPage: true);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
            child: _cameraController != null && _cameraController!.value.isInitialized
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
                      else if (widget.documentType == DocumentType.id_book)
                        CustomOverlay(
                          aspectRatio: 2 / 3,
                          borderColor: Colors.deepPurpleAccent,
                          type: widget.documentType,
                        )
                      else
                        CustomOverlay(
                          aspectRatio: 2 / 3,
                          borderColor: Colors.blue,
                          type: widget.documentType,
                        ),
                      if (messages.contains('poor brightness'))
                        BlinkingAnimation(
                          child: RotatedBox(
                              quarterTurns: 1,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  constraints: const BoxConstraints(maxHeight: 50, minHeight: 0),
                                  margin: const EdgeInsets.all(20),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(255, 255, 255, 0.874),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.light_mode_outlined,
                                            color: Colors.amberAccent.shade400,
                                          ),
                                          const Text('Poor Lighting Detected!'),
                                        ],
                                      ),
                                      Text('Brightness Level:  ${brightness?.ceil() ?? 0} / 120')
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ScanDocsGuidelines(
                        documentType: widget.documentType,
                      ),
                      if (imageFiles.isNotEmpty)
                        Positioned(
                          top: 20,
                          right: 10,
                          child: Column(
                            children: imageFiles
                                .map(
                                  (imageFile) => ImagePreviewCard(
                                    onClearImage: () {
                                      setState(() {
                                        imageFiles.removeWhere((img) => img.file == imageFile.file);
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Text(imageFile.side),
                                        Image.file(
                                          imageFile.file,
                                          height: 180,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                      Positioned(
                        bottom: 10,
                        left: 10,
                        child:
                            Container(color: Colors.black, child: Text(widget.documentType.name.split('_').join(' '))),
                      ),

                      ///

                      if ((DocumentType.passport != widget.documentType && DocumentType.id_book != widget.documentType)
                          ? (imageFiles.isNotEmpty && imageFiles.length == 2)
                          : (imageFiles.isNotEmpty && imageFiles.length == 1))
                        AnimatedPositioned(
                          bottom: 20,
                          right: 20,
                          curve: Curves.elasticInOut,
                          duration: const Duration(milliseconds: 250),
                          child: FloatingActionButton.extended(
                            onPressed: () => widget.onNext(context, documentScannerState),
                            label: const Row(
                              children: [
                                Text(' Proceed '),
                                Icon(Icons.arrow_forward_ios_rounded),
                              ],
                            ),
                          ),
                        ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
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

  const CustomOverlay({super.key, required this.aspectRatio, required this.borderColor, required this.type});

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

    canvas.drawRRect(_scaleRect(rect: cardRect!, widgetSize: size, scaleX: scaleX, scaleY: scaleY), paint);
  }

  @override
  bool shouldRepaint(CardPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.cardRect != cardRect;
  }
}

RRect _scaleRect({required Rect rect, required Size widgetSize, double? scaleX, double? scaleY}) {
  return RRect.fromLTRBR((widgetSize.width - rect.left.toDouble() * scaleX!), rect.top.toDouble() * scaleY!,
      widgetSize.width - rect.right.toDouble() * scaleX, rect.bottom.toDouble() * scaleY, const Radius.circular(10));
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
  final List<ImageFile> imageFiles;
  final String? idCode39Text2;
  final num? cameraLightingLevel;

  const CameraEventsState(
      {required this.idCode39Text,
      required this.idPdf417Text,
      required this.passportMRZtext,
      required this.imageFiles,
      required this.cameraLightingLevel,
      required this.idCode39Text2});

  CameraEventsState copyWith({
    String? idCode39Text,
    String? idCode39Text2,
    String? idPdf417Text,
    String? passportMRZtext,
    List<ImageFile>? imageFiles,
    num? cameraLightingLevel,
  }) =>
      CameraEventsState(
        cameraLightingLevel: cameraLightingLevel ?? this.cameraLightingLevel,
        idCode39Text: idCode39Text ?? this.idCode39Text,
        idCode39Text2: idCode39Text2 ?? this.idCode39Text2,
        idPdf417Text: idPdf417Text ?? this.idPdf417Text,
        passportMRZtext: passportMRZtext ?? this.passportMRZtext,
        imageFiles: imageFiles ?? this.imageFiles,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['cameraLightingLevel'] = '$cameraLightingLevel';
    data['idCode39Text'] = '$idCode39Text';
    data['idCode39Text2'] = '$idCode39Text2';
    data['idPdf417Text'] = '$idPdf417Text';
    data['passportMRZtext'] = '$passportMRZtext';
    data['imageFiles'] = imageFiles.map((img) {
      return {'file': bytesToDataUrl(img.file.readAsBytesSync(), getExtension(img.file.path)), 'side': img.side};
    }).toList();
    return data;
  }
}

class ImagePreviewCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onClearImage;

  const ImagePreviewCard({super.key, required this.child, required this.onClearImage});

  @override
  State<ImagePreviewCard> createState() => _ImagePreviewCardState();
}

class _ImagePreviewCardState extends State<ImagePreviewCard> {
  bool? _isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _isActive = false;
        });
      },
      child: Card(
        elevation: _isActive == true ? 5 : null,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isActive = true;
                });
              },
              onHover: (_) {
                setState(() {
                  _isActive = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isActive = false;
                });
              },
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isActive = true;
                    });
                  },
                  child: widget.child),
            ),
            if (_isActive == true)
              FittedBox(
                fit: BoxFit.fitHeight,
                child: Container(
                  height: _isActive! ? 180 + 18 : null,
                  width: _isActive! ? (180 * (2 / 3) - 18) : null,
                  color: const Color.fromARGB(179, 0, 0, 0),
                  child: Center(
                      child: IconButton(
                    alignment: Alignment.topLeft,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(primaryPadding),
                    ),
                    icon: const Icon(Icons.close),
                    onPressed: widget.onClearImage,
                  )),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class ImageFile {
  /// string version of [DetectSide], i.e, front or back
  final String side;
  final File file;

  ImageFile({required this.side, required this.file});

  @override
  String toString() {
    return '{side:$side, file: $file}';
  }

  Map<String, dynamic> toJson() {
    return {'side': side, 'file': file};
  }
}

// Future<bool> isLightingBad(CameraImage image) async {
//   return false;
// }
