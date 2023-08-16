import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verify_sa/theme.dart';
import 'package:verify_sa/widgets/buttons/base_buttons.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ///
    var baseTheme = ThemeData(brightness: Brightness.light);

    ///
    return MaterialApp(
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(
        // scaffoldBackgroundColor: neutralGrey,
        textTheme: GoogleFonts.dmSansTextTheme(baseTheme.textTheme),
      ),
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              BaseButton(
                key: UniqueKey(),
                label: "Copy",
                color: neutralGrey,
                bgColor: primaryColor,
                buttonIcon: Icon(
                  Icons.copy,
                  color: primaryColor,
                ),
                buttonSize: ButtonSize.small,
                hasBorderLining: false,
              ),
              BaseButton(
                key: UniqueKey(),
                label: "Login with Google",
                buttonIcon: const Image(
                  image: AssetImage("assets/icons/google.png"),
                ),
                buttonSize: ButtonSize.large,
                hasBorderLining: true,
              ),
              BaseButton(
                key: UniqueKey(),
                label: "Facebook",
                buttonIcon: const Image(
                  image: AssetImage("assets/icons/facebook.png"),
                ),
                buttonSize: ButtonSize.small,
                hasBorderLining: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
