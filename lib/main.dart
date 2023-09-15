import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verify_sa/app_config.dart';
import 'package:verify_sa/infrastructure/verifysa/repository.dart';
import 'package:verify_sa/presentation/pages/home_page.dart';
import 'package:verify_sa/presentation/theme.dart';
import 'package:verify_sa/presentation/widgets/history/history_list_item.dart';
import 'package:verify_sa/presentation/widgets/text/list_title.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verify_sa/services/dio.dart';

import 'application/verify_sa/verify_sa_bloc.dart';

void main() {
  runZonedGuarded(() {
    /// Fallback page onError
    ErrorWidget.builder = (details) => MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(
              child: Text(details.toString()),
            ),
          ),
        );

    ///
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<VerifySaBloc>(
            create: (BuildContext context) => VerifySaBloc(
              VerifySaRepository(
                VerifySaDioClientService.instance,
              ),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    );

    ///
  }, (error, stack) {
    print(error);

    /// fb crush
  });
}

// https://api.flutter.dev/flutter/material/SliverAppBar-class.html

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ///
    var baseTheme = ThemeData(brightness: Brightness.light);

    ///
    return MaterialApp(
      debugShowCheckedModeBanner: kDebugMode || kProfileMode,
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.dmSansTextTheme(baseTheme.textTheme),
        primaryColor: primaryColor,
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
          thumbVisibility: MaterialStateProperty.all(true),
          thickness: MaterialStateProperty.all(10),
          thumbColor: MaterialStateProperty.all(darkerPrimaryColor),
          radius: const Radius.circular(10),
          minThumbLength: 100,
          interactive: true,
        ),
      ),
      title: displayAppName,
      home: const HomePage(),
    );
  }
}

final _widgets = [
  Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
    child: const ListTitle(
      text: 'YESTERDAy',
    ),
  ),
  const ListItemBanner(),
  const TransactionListItem(
    key: Key("history-list-item-3"),
    n: 3,
  ),
  const TransactionListItem(
    key: Key("history-list-item-1"),
    n: 1,
  ),
  const TransactionListItem(
    key: Key("history-list-item-2"),
    n: 2,
  ),
  const TransactionListItem(
    key: Key("history-list-item-4"),
    n: 4,
  ),
  Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
    child: const ListTitle(
      text: 'LAST month',
    ),
  ),
  const TransactionListItem(
    key: Key("history-list-item-5"),
    n: 3,
  ),
  const TransactionListItem(
    key: Key("history-list-item-6"),
    n: 1,
  ),
  const TransactionListItem(
    key: Key("history-list-item-7"),
    n: 2,
  ),
];
