import 'package:flutter/material.dart';
import 'package:verified/presentation/widgets/ml_face_painter/camera_view.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as VerificationPageArgs?;
    final uuid = args?.uuid;
    return const SafeArea(
      child:  Scaffold(
        backgroundColor:Colors.black,
        body: CameraView()
      ),
    );
  }
}

class VerificationPageArgs {
  final String uuid;
  VerificationPageArgs(this.uuid);
}
