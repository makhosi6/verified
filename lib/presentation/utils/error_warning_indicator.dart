import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:verified/presentation/theme.dart';

class AppErrorWarningIndicator extends StatefulWidget {
  const AppErrorWarningIndicator({super.key});





  @override
  State<AppErrorWarningIndicator> createState() => _AppErrorWarningIndicatorState();
}

class _AppErrorWarningIndicatorState extends State<AppErrorWarningIndicator> {

  final IndicatorType type = IndicatorType.error;
  final bool show = false;
  final String message = 'No Internet Connection';

  @override
  Widget build(BuildContext context) {
    return SliverPinnedHeader(
      child: (!show)
          ? const SizedBox.shrink()
          : Container(
              color: type == IndicatorType.error ? errorColor : Colors.amber[400],
              // margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Container(
                    height: 30,
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
    );
  }
}

enum IndicatorType { error, warning }
