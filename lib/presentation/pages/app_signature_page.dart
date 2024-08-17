import 'package:flutter/material.dart';
import 'package:verified/presentation/utils/syntax_highlighter.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';

class AppSignaturePage extends StatelessWidget {
  const AppSignaturePage({super.key});

  final _markDownData = '''[
    {
      "relation": [
        "delegate_permission/common.handle_all_urls"
      ],
      "target": {
        "namespace": "android_app",
        "package_name": "com.byteestudio.verified",
        "sha256_cert_fingerprints": [
          "CD:A1:23:E0:1A:5C:7A:19:21:B6:24:BC:25:75:7E:4C:E9:DB:4A:90:35:15:DF:17:ED:93:78:58:16:E7:69:59"
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
