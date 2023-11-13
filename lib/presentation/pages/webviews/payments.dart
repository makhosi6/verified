import 'package:flutter/material.dart';
import 'package:verified/presentation/pages/webviews/the_webview.dart';

class PaymentPage extends StatelessWidget {
  final String paymentUrl;
  const PaymentPage({super.key, required this.paymentUrl});

  @override
  Widget build(BuildContext context) {
    return TheWebView(webURL: paymentUrl);
  }
}
