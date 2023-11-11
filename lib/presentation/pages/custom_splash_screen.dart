import 'package:flutter/material.dart';
import 'package:verified/presentation/theme.dart';

class CustomSplashScreen extends StatelessWidget {
  const CustomSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const Scaffold(
        body: Center(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}
