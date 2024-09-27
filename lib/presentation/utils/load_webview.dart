import 'package:url_launcher/url_launcher.dart';
import 'package:verified/infrastructure/analytics/repository.dart';

Future<void> generalUrlLauncher(String url) async {
  final Uri urlObj = Uri.parse(url);
  final _canLaunchUrl = await canLaunchUrl(urlObj);
  VerifiedAppAnalytics.logFeatureUsed(
      VerifiedAppAnalytics.FEATURE_DID_TRIGGER_A_WEBVIEW, {'url': url, 'canLaunchUrl': _canLaunchUrl});

  if (_canLaunchUrl) {
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
