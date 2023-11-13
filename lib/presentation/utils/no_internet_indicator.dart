import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class NoInternetIndicator extends StatelessWidget {
  const NoInternetIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPinnedHeader(
      child: Container(
        color: Colors.redAccent[700]!,
        // margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Container(
              height: 20,
            ),
            const Text(
              'No Internet Connection',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
