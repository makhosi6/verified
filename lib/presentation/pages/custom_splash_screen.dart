import 'package:flutter/material.dart';
import 'package:verified/presentation/utils/lottie_loader.dart';

class CustomSplashScreen extends StatelessWidget {
  const CustomSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
        body: Center(
          child: LottieProgressLoader(key: Key('app-splash-screen-loader'),),
        ),
      );
  }
}
