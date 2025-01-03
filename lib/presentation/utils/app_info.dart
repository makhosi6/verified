import 'package:package_info_plus/package_info_plus.dart';
import 'package:verified/helpers/logger.dart';

Future<Map<String, dynamic>> getVerifiedPackageInfo() async {
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return {
      'installerStore': packageInfo.installerStore,
      'appName': packageInfo.appName,
      'packageName': packageInfo.packageName,
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
    };
  } catch (error, stackTrace) {
    verifiedErrorLogger(error, stackTrace);

    return {
      'appName': 'Unknown',
      'packageName': 'com.byteestudio.verified',
      'version': '0.0.0',
      'buildNumber': '0',
      'buildSignature': '#',
    };
  }
}
