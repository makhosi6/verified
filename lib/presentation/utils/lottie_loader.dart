import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/presentation/theme.dart';

class LottieProgressLoader extends StatefulWidget {
  const LottieProgressLoader({super.key});

  @override
  State<LottieProgressLoader> createState() => _LottieProgressLoaderState();
}

class _LottieProgressLoaderState extends State<LottieProgressLoader> {
  late final Future<LottieComposition> _composition;
  final start = DateTime.now();

  @override
  void initState() {
    super.initState();
    _composition = AssetLottie('assets/lottie/verified_animating_logo.json').load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      width: 95,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: FutureBuilder<LottieComposition>(
        future: _composition,
        builder: (context, snapshot) {
          var composition = snapshot.data;
          if (composition != null) {
            return Lottie(key: Key('${start.millisecondsSinceEpoch}'), composition: composition);
          } else {
            return Center(
                child: CircularProgressIndicator(
              key: Key('${start.millisecondsSinceEpoch}'),
              color: darkerPrimaryColor,
            ));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    final end = DateTime.now();
    VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_PROGRESS_INDICATOR, {
      'load_time_in_ms': end.millisecondsSinceEpoch - start.millisecondsSinceEpoch,
      'timestamp': end.millisecondsSinceEpoch
    });
    super.dispose();
  }
}
