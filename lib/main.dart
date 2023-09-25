import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verify_sa/helpers/security/nonce.private.dart';
import 'package:verify_sa/infrastructure/verifysa/repository.dart';
import 'package:verify_sa/presentation/pages/home_page.dart';
import 'package:verify_sa/presentation/theme.dart';
import 'package:verify_sa/presentation/widgets/history/history_list_item.dart';
import 'package:verify_sa/presentation/widgets/text/list_title.dart';
import 'package:flutter/foundation.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String title = "_";

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      title = await generateNonce();
    });
  }

  @override
  Widget build(BuildContext context) {
    ///
    print("NONCE: $title");

    ///
    return MaterialApp(
      debugShowCheckedModeBanner: kDebugMode || kProfileMode,
      theme: theme,
      title: title,
      home: const HomePage(),
    );
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
}
