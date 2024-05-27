import 'package:flutter/material.dart';
import 'package:verified/presentation/pages/face_detector_page.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as VerificationPageArgs?;
    final uuid = args?.uuid;
    return Scaffold(
      backgroundColor:Colors.black,
      body: FaceDetectorPage(),
    );
  }
}

class VerificationPageArgs {
  final String uuid;
  VerificationPageArgs(this.uuid);
}
