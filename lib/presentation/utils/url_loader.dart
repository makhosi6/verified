import 'package:url_launcher/url_launcher.dart';
import 'package:verified/infrastructure/analytics/repository.dart';

Future<void> launchInAppWebPage(String url) async {

  VerifiedAppAnalytics.logFeatureUsed(
      VerifiedAppAnalytics.FEATURE_DID_TRIGGER_A_WEBVIEW, {'url': url});
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}