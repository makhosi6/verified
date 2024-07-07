import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///https://lottiefiles.com/mahendra

/// primary color
Color primaryColor = const Color(0xFF4CD080);

/// light version of the primary color
Color litePrimaryColor = const Color(0xFFB7CEC3);

/// common light grey color
Color neutralGrey = const Color(0xFFF2F2F2);

/// common light dark color
Color neutralDarkGrey = const Color(0xFF8F92A1);

/// common ember color (accent color)
Color neutralYellow = const Color(0xFFFFAE58);

/// common dark green color
Color darkerPrimaryColor = const Color(0xFF105D38);

/// dark blur color
Color darkBlurColor = const Color(0x6A1A3627);

/// common error color
Color errorColor = Colors.redAccent;

/// common success color
Color successColor = Colors.greenAccent;

/// common error color
Color warningColor = Colors.amberAccent[700] ?? Colors.amberAccent;

///
EdgeInsets primaryPadding = const EdgeInsets.all(16.0);

///
const scaffoldBackgroundColor = Color(0xFFF5FCF8);

///
final baseTheme = ThemeData(brightness: Brightness.light);

MaterialColor generateMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (final double strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}

/// [primaryColor] as a Material Color
MaterialColor primaryMaterialColor = generateMaterialColor(primaryColor);

/// App theme
ThemeData theme = ThemeData.light(
  useMaterial3: true,
).copyWith(
  appBarTheme: const AppBarTheme(
    centerTitle: true,

    /// if using MaterialUI 2
    // elevation: 0,
    // backgroundColor: Colors.white,
  ),

  // scaffoldBackgroundColor: scaffoldBackgroundColor,
  scaffoldBackgroundColor: Colors.white,
  textTheme: GoogleFonts.dmSansTextTheme(baseTheme.textTheme),
  primaryColor: darkerPrimaryColor,
  primaryColorLight: primaryColor,
  splashColor: darkerPrimaryColor.withOpacity(0.4),
  highlightColor: primaryColor.withOpacity(0.2),
  dividerColor: Colors.grey[400],
  colorScheme: ColorScheme(
    brightness: baseTheme.brightness,
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: neutralYellow,
    onSecondary: Colors.white,
    error: Colors.redAccent,
    onError: Colors.white,
    background: Colors.white,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: darkerPrimaryColor,
        ),
      )),
    ),
  ),

  ///
  buttonTheme: ButtonThemeData(
    buttonColor: darkerPrimaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: BorderSide(color: darkerPrimaryColor),
    ),
  ),

  ///
  scrollbarTheme: ScrollbarThemeData(
    thumbVisibility: MaterialStateProperty.all(false),
    thickness: MaterialStateProperty.all(10),
    thumbColor: MaterialStateProperty.all(darkerPrimaryColor),
    radius: const Radius.circular(10),
    minThumbLength: 100,
    interactive: true,
  ),
);
