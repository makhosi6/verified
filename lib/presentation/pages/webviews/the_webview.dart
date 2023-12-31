// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:verified/helpers/app_info.dart';
import 'package:verified/presentation/pages/error_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';

class TheWebView extends StatefulWidget {
  String webURL;

  TheWebView({
    Key? key,
    required this.webURL,
  }) : super(key: key);

  @override
  State<TheWebView> createState() => _TheWebViewState();
}

class _TheWebViewState extends State<TheWebView> {
  bool hasError = false;

  int progressVal = 0;

  String errorMsg = '';

  late WebViewController controller;
  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(webAppUserAgent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                progressVal = progress;
              });
            }
            if (progress == 100) {
              Future.delayed(const Duration(milliseconds: 600), () {
                if (mounted) {
                  setState(() {
                    progressVal = 101;
                  });
                }
              });
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              setState(() {
                hasError = true;
                errorMsg = error.description;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.webURL));
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) return VerifiedErrorPage(message: errorMsg);

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: progressVal == 101
              ? Stack(
                  children: [
                    WebViewWidget(controller: controller),
                    Positioned(
                      top: 60,
                      left: 20,
                      child: VerifiedBackButton(
                        isLight: true,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                )
              : CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 5.0,
                  percent: progressVal / 100,
                  center: Text('$progressVal%'),
                  progressColor: primaryColor,
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
