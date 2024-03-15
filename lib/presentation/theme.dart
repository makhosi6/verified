import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// primary color
Color primaryColor = const Color(0xFF4CD080);

/// common light grey color
Color neutralGrey = const Color(0xFFF2F2F2);

/// common light dark color
Color neutralDarkGrey = const Color(0xFF8F92A1);

/// common ember color (accent color)
Color neutralYellow = const Color(0xFFFFAE58);

/// common dark green color
Color darkerPrimaryColor = const Color(0xFF105D38);

/// common error color
Color errorColor = Colors.redAccent;

/// common error color
Color warningColor = Colors.amberAccent[700] ?? Colors.amberAccent;

///
EdgeInsets primaryPadding = const EdgeInsets.all(16.0);

///
var baseTheme = ThemeData(brightness: Brightness.light);

// App theme
ThemeData theme = ThemeData.light(
  useMaterial3: true,
).copyWith(
  appBarTheme: const AppBarTheme(centerTitle: true),

  scaffoldBackgroundColor: Colors.white,
  textTheme: GoogleFonts.dmSansTextTheme(baseTheme.textTheme),
  // primaryColor: Colors.redAccent,
  primaryColorLight: primaryColor,
  splashColor: darkerPrimaryColor.withOpacity(0.4),
  highlightColor: primaryColor.withOpacity(0.2),
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
