import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/application/verify_sa/verify_sa_bloc.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/helpers/security/nonce.dart';
import 'package:verified/infrastructure/auth/local_user.dart';
import 'package:verified/infrastructure/store/repository.dart';
import 'package:verified/infrastructure/verifysa/repository.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/services/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // runZonedGuarded(() async {
  //   /// Fallback page onError
  //   ErrorWidget.builder = (details) => MaterialApp(
  //         home: Scaffold(
  //           appBar: AppBar(
  //             title: const Text('Error'),
  //           ),
  //           body: Center(
  //             child: Text(details.toString()),
  //           ),
  //         ),
  //       );

  ///
  runApp(
    LocalUser(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<VerifySaBloc>(
            create: (BuildContext context) => VerifySaBloc(
              VerifySaRepository(
                VerifySaDioClientService.instance,
              ),
            ),
          ),
          BlocProvider<StoreBloc>(
            create: (BuildContext context) => StoreBloc(
              StoreRepository(
                StoreDioClientService.instance,
              ),
            ),
          ),
        ],
        child: const AppRoot(),
      ),
    ),
  );

  ///
//   }, (error, stack) {
//     verifiedErrorLogger(error);

//     /// fb crush
//   });
}

// https://api.flutter.dev/flutter/material/SliverAppBar-class.html

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  String titleLarge = "_";

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      titleLarge = await generateNonce();
    });
  }

  @override
  Widget build(BuildContext context) {
    ///
    print("NONCE: $titleLarge");

    ///
    return FutureBuilder<UserProfile?>(
        future: LocalUser.of(context)?.getUser(),
        builder: (context, snapshot) {
          var user = snapshot.data?.id ?? 'user';

          if (snapshot.connectionState != ConnectionState.done && !snapshot.hasData) {
            return plApp;
          }

          /// remove the splash screen
          return MaterialApp(
            debugShowCheckedModeBanner: kDebugMode || kProfileMode,
            theme: theme,
            title: titleLarge,
            home: BlocBuilder<StoreBloc, StoreState>(
              bloc: context.read<StoreBloc>()
                ..add(StoreEvent.getUserProfile(user))
                ..add(StoreEvent.getAllHistory(user))
                ..add(StoreEvent.getWallet(user)),
              builder: (context, state) {
                return const HomePage();
              },
            ),
          );
        });
  }

  final _widgets = [
    // Container(
    //   alignment: Alignment.centerLeft,
    //   padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
    //   child: const ListTitle(
    //     text: 'YESTERDAy',
    //   ),
    // ),
    // const ListItemBanner(),
    // const TransactionListItem(
    //   key: Key("history-list-item-3"),
    //   n: 3,
    // ),
    // const TransactionListItem(
    //   key: Key("history-list-item-1"),
    //   n: 1,
    // ),
    // const TransactionListItem(
    //   key: Key("history-list-item-2"),
    //   n: 2,
    // ),
    // const TransactionListItem(
    //   key: Key("history-list-item-4"),
    //   n: 4,
    // ),
    // Container(
    //   alignment: Alignment.centerLeft,
    //   padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
    //   child: const ListTitle(
    //     text: 'LAST month',
    //   ),
    // ),
    // const TransactionListItem(
    //   key: Key("history-list-item-5"),
    //   n: 3,
    // ),
    // const TransactionListItem(
    //   key: Key("history-list-item-6"),
    //   n: 1,
    // ),
    // const TransactionListItem(
    //   key: Key("history-list-item-7"),
    //   n: 2,
    // ),
  ];
}

final plApp = MaterialApp(
  theme: theme,
  home: const Scaffold(
    body: Center(
      child: Text("Loading..."),
    ),
  ),
);
