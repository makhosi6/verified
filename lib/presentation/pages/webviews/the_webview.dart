// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:verified/domain/models/verified_web_auth_user.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:verified/helpers/app_info.dart';
import 'package:verified/presentation/pages/error_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';

typedef OnFinishCallback = void Function(dynamic data);

class TheWebView extends StatefulWidget {
  final bool hasBackBtn;
  final String webURL;
  final OnFinishCallback? onPageSuccess;
  final OnFinishCallback? onPageFailed;
  final Function? onPageCancelled;

  const TheWebView({
    Key? key,
    this.hasBackBtn = true,
    required this.webURL,
    this.onPageSuccess,
    this.onPageFailed,
    this.onPageCancelled,
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
          onPageFinished: (str) {},
          onWebResourceError: (error) {
            if (mounted) {
              setState(() {
                hasError = true;
                errorMsg = error.description;
              });

              widget.onPageFailed?.call(error.description);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            String url = request.url;
      
        
            if (url.contains('verified.byteestudio.com')) {
              ///
              if (url == 'https://verified.byteestudio.com/success') widget.onPageSuccess?.call(null);
              if (url == 'https://verified.byteestudio.com/cancelled') widget.onPageCancelled?.call();
              if (url == 'https://verified.byteestudio.com/failed') widget.onPageFailed?.call(null);

              //
              return NavigationDecision.prevent;
            }
print('\n\n\n\n\n=========================================');
print(Uri.parse(url).queryParameters);
print(url);
print('=========================================\n\n\n\n\n');
            if (url.contains('146.190.115.138:9000')) {
              var uri = Uri.parse(url);
              ///
              
              var userId = uri.queryParameters['user_id'] ?? uri.queryParameters['userId'];
              var token = uri.queryParameters['key'] ?? uri.queryParameters['token'];
              // !(url.contains('login') || url.contains('register')) || 
              if (url.contains('user/profile')) {
                widget.onPageSuccess?.call(AuthUserDetails(token: token, userId: userId));

              print('SUCCESS: ${url.toString()}');
                //
                return NavigationDecision.prevent;
              }
            }
            print('FAILER: ${url.toString()}');
            return NavigationDecision.navigate;
          },
        ),
      )
      // ..clearCache()
      // ..clearLocalStorage()
      ..loadRequest(Uri.parse(widget.webURL));
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) return VerifiedErrorPage(message: errorMsg);

    return Container(
      color: Colors.grey.shade100,
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
