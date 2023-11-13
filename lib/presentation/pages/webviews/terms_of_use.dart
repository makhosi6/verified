import 'package:flutter/material.dart';
import 'package:verified/presentation/pages/webviews/the_webview.dart';

class TermOfUseWebView extends StatelessWidget {
  const TermOfUseWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return TheWebView(webURL: 'https://byteestudio.com/terms-of-service');
  }
}
