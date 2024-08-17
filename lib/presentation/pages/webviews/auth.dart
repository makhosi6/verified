import 'package:flutter/material.dart';
import 'package:verified/domain/models/verified_web_auth_user.dart';
import 'package:verified/presentation/pages/webviews/the_webview.dart';

class VerifiedAuthWebView extends StatefulWidget {
  final void Function(AuthUserDetails data)? onPageSuccess;
  final Function? onPageFailed;
  // final OnFinishCallback? onPageFailed;
  final Function? onPageCancelled;
  final String url;

  const VerifiedAuthWebView({super.key,required this.url, this.onPageSuccess, this.onPageFailed, this.onPageCancelled});

  @override
  State<VerifiedAuthWebView> createState() => _VerifiedAuthWebViewState();
}

class _VerifiedAuthWebViewState extends State<VerifiedAuthWebView> {
  @override
  Widget build(BuildContext context) {
    return TheWebView(
      webURL: widget.url,
      hasBackBtn: true,
      onPageCancelled: widget.onPageCancelled,
      onPageFailed:(data) => widget.onPageFailed?.call(data),
      onPageSuccess: (data) => widget.onPageSuccess?.call(data),
    );
  }
}
