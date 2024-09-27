import 'package:flutter/material.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/presentation/utils/lottie_loader.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  final start = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LottieProgressLoader(
          key: Key('app-splash-screen-loader-${start.millisecondsSinceEpoch}'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    final end = DateTime.now();
    VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_SPLASH_SCREEN, {
      'load_time_in_ms': end.millisecondsSinceEpoch - start.millisecondsSinceEpoch,
      'timestamp': end.millisecondsSinceEpoch
    });
    super.dispose();
  }
}
