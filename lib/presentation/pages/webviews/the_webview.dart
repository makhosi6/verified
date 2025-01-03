// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:verified/helpers/app_info.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/presentation/pages/error_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';

class TheWebView extends StatefulWidget {
  bool hasBackBtn;

  String webURL;

  Function onPageSuccess;
  Function onPageFailed;
  Function onPageCancelled;

  TheWebView({
    Key? key,
    this.hasBackBtn = true,
    required this.webURL,
    required this.onPageSuccess,
    required this.onPageFailed,
    required this.onPageCancelled,
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
          onUrlChange: (change) {
            print("ON_URL_CHANGE == ${change.url}");
          },
          onNavigationRequest: (NavigationRequest request) {
            String url = request.url;
            print(url);
            if (url.contains('verified.byteestudio.com')) {
              ///
              print('IF  ' + url);
              if (url.contains('/success')) {
                print('success');
                widget.onPageSuccess();
              }

              if (url.contains('/cancelled')) {
                print('cancelled');
                widget.onPageCancelled();
              }
              if (url.contains('/failed')) {
                print('failed');
                widget.onPageFailed();
              }
              //
              return NavigationDecision.prevent;
            } else {
              verifiedErrorLogger('ELSE + ' + url);
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.webURL));

    VerifiedAppAnalytics.logFeatureUsed(VerifiedAppAnalytics.FEATURE_DID_TRIGGER_A_WEBVIEW, {'url': widget.webURL});
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) return VerifiedErrorPage(message: errorMsg);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: progressVal == 101
                  ? Stack(
                      children: [
                        WebViewWidget(controller: controller),
                        if (widget.hasBackBtn)
                          Positioned(
                            top: 60,
                            left: 20,
                            child: VerifiedBackButton(
                              key: UniqueKey(),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
