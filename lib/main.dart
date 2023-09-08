import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(() {
    /// Fallback page onError
    ErrorWidget.builder = (print as dynamic);

    runApp(const App());
  }, (error, stack) {
    /// fb crush
  });
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Text("90_90"),
    );
  }
}
