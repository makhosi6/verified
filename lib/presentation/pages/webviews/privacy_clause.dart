import 'package:flutter/material.dart';
import 'package:verified/presentation/pages/webviews/the_webview.dart';

class PrivacyClauseWebView extends StatelessWidget {
  const PrivacyClauseWebView({super.key});

  @override
  Widget build(BuildContext context) {
  return TheWebView(webURL: 'https://byteestudio.com/verified/privacy-policy');
  }
}