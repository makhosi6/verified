import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AppErrorWarningIndicator extends StatelessWidget {
  final IndicatorType type;
  final bool show;
  final String message;
  const AppErrorWarningIndicator(
      {super.key, this.show = false, this.type = IndicatorType.error, this.message = 'No Internet Connection'});

  @override
  Widget build(BuildContext context) {
    return SliverPinnedHeader(
      child: (!show)
          ? const SizedBox.shrink()
          : Container(
              color: type == IndicatorType.error ? Colors.redAccent[700]! : Colors.amber[400],
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
