import 'package:flutter/material.dart';
import 'package:verified/presentation/utils/syntax_highlighter.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';

class AppSignaturePage extends StatelessWidget {
  const AppSignaturePage({super.key});

  final _markDownData = '''[
  {
    "relation": [
      "delegate_permission/common.get_login_creds",
      "delegate_permission/common.handle_all_urls",
      "delegate_permission/common.use_as_origin"
    ],
    "target": {
      "namespace": "web",
      "site": "https://twitter.com"
    }
  },
  {
    "relation": [
      "delegate_permission/common.get_login_creds",
      "delegate_permission/common.handle_all_urls",
      "delegate_permission/common.use_as_origin"
    ],
    "target": {
      "namespace": "web",
      "site": "https://x.com"
    }
  },
  {
    "relation": [
      "delegate_permission/common.get_login_creds",
      "delegate_permission/common.use_as_origin"
    ],
    "target": {
      "namespace": "web",
      "site": "https://twitter.com"
    }
  },
  {
    "relation": [
      "delegate_permission/common.get_login_creds",
      "delegate_permission/common.use_as_origin"
    ],
    "target": {
      "namespace": "web",
      "site": "https://x.com"
    }
  },
  {
    "relation": [
      "delegate_permission/common.get_login_creds",
      "delegate_permission/common.handle_all_urls",
      "delegate_permission/common.use_as_origin"
    ],
    "target": {
      "namespace": "android_app",
      "package_name": "com.twitter.android",
      "sha256_cert_fingerprints": [
        "0F:D9:A0:CF:B0:7B:65:95:09:97:B4:EA:EB:DC:53:93:13:92:39:1A:A4:06:53:8A:3B:04:07:3B:C2:CE:2F:E9",
        "F9:07:E3:BB:21:D6:31:9C:CA:34:07:80:CC:63:B5:15:3A:92:97:1F:85:D3:8A:48:82:E6:A5:7A:41:AC:33:84",
        "99:22:6e:ed:9b:9e:ee:14:6c:b1:61:49:2b:cf:91:a5:4d:97:ff:04:54:32:8d:93:b8:64:f3:1f:6c:8d:d7:0a"
      ]
    }
  },
  {
    "relation": [
      "delegate_permission/common.get_login_creds",
      "delegate_permission/common.handle_all_urls",
      "delegate_permission/common.use_as_origin"
    ],
    "target": {
      "namespace": "android_app",
      "package_name": "com.twitter.android.lite",
      "sha256_cert_fingerprints": [
        "AF:E0:2B:08:E2:3F:6B:D4:09:02:5B:52:3E:BB:3F:46:3A:D4:BC:16:99:9B:9E:8D:C2:D8:C3:9C:4E:C2:2F:25",
        "C2:79:5F:83:9A:07:3E:8E:10:47:F8:CB:22:BE:E0:D8:A0:7C:39:C6:1F:1F:48:10:40:A8:8A:44:9E:6B:EB:A5"
      ]
    }
  }
]''';

  @override
  Widget build(BuildContext context) {
    final SyntaxHighlighterStyle style = SyntaxHighlighterStyle.darkThemeStyle();
    return Material(
      child: Scaffold(
        backgroundColor: const Color(0xFF212121),
        body: Stack(
          children: [
            SafeArea(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontFamily: 'monospace', color: Colors.white, fontSize: 12.0),
                  children: <TextSpan>[
                    DartSyntaxHighlighter(style).format(_markDownData),
                  ],
                ),
              ),
            ),
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
        ),
      ),
    );
  }
}
