import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/app_config.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/application/verify_sa/verify_sa_bloc.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/firebase_options.dart';
import 'package:verified/helpers/security/nonce.dart';
import 'package:verified/infrastructure/auth/local_user.dart';
import 'package:verified/infrastructure/store/repository.dart';
import 'package:verified/infrastructure/verifysa/repository.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/services/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Ideal time to initialize
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
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
    MultiBlocProvider(
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
        // BlocProvider<AuthBloc>(
        //   create: (BuildContext context) => AuthBloc(
        //     AuthRepository(auth),
        //   ),
        // ),
      ],
      child: const AppRoot(),
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
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      debugPrint("NONCE: ${await generateNonce()}");
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          print('UWser is currently signed out!');
        } else {
          print('UWser is signed in!');
        }
      });

      // UserCredential userCredential = await FirebaseAuth.instance.signInWithProvider(VerifiedAuthProvider.google);

      // print(userCredential.user.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
        future: LocalUser.getUser(),
        builder: (context, snapshot) {
          var user = snapshot.data?.id ?? '';

          if (snapshot.connectionState != ConnectionState.done && !snapshot.hasData) {
            return plApp;
          }

          /// remove the splash screen
          return MaterialApp(
            debugShowCheckedModeBanner: kDebugMode || kProfileMode,
            theme: theme,
            title: displayAppName,
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
