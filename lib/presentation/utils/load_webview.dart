import 'package:url_launcher/url_launcher.dart';

Future<void> generalUrlLauncher(String url) async {
  Uri urlObj = Uri.parse(url);

  if (await canLaunchUrl(urlObj)) {
    // ignore: deprecated_member_use
    await launch(
      urlObj.toString(),
      forceSafariVC: true,
      enableJavaScript: true,
      enableDomStorage: true,
      webOnlyWindowName: '_blank',
    );
  } else {
    /// in-app as a webview
    launchUrl(
      urlObj,
      mode: LaunchMode.inAppWebView,
      webOnlyWindowName: '_blank',
    );
  }
}
