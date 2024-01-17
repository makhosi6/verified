import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:verified/app_config.dart';
import 'package:verified/application/auth/auth_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/application/verify_sa/verify_sa_bloc.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/firebase_options.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/infrastructure/auth/local_user.dart';
import 'package:verified/infrastructure/auth/repository.dart';
import 'package:verified/infrastructure/store/repository.dart';
import 'package:verified/infrastructure/verifysa/repository.dart';
import 'package:verified/presentation/pages/custom_splash_screen.dart';
import 'package:verified/presentation/pages/error_page.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/services/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ///
  if (kDebugMode) await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runZonedGuarded(() async {
    /// Fallback page onError
    ErrorWidget.builder = (details) => MaterialApp(
          home: VerifiedErrorPage(
            key: const Key('fallback-error-page'),
            message: details.summary.toDescription(),
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
            )..add(
                const VerifySaEvent.apiHealthCheck(),
              ),
          ),
          BlocProvider<StoreBloc>(
            create: (BuildContext context) => StoreBloc(StoreRepository(
              StoreDioClientService.instance,
            ))
              ..add(
                const StoreEvent.apiHealthCheck(),
              ),
          ),
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(
                AuthRepository(
                  FirebaseAuth.instance,
                ),
                context.read<StoreBloc>()),
          ),
        ],
        child: const AppRoot(),
      ),
    );

    ///
  }, (error, stack) {
    verifiedErrorLogger(error);

    /// fb crush
  });
}

// https://api.flutter.dev/flutter/material/SliverAppBar-class.html

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  //with SingleTickerProviderStateMixin
  @override

//log changing deps
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('=========================+++++++didChangeDependencies+++++++======================');
  }

  @override
  void didUpdateWidget(covariant AppRoot oldWidget) {
    super.didUpdateWidget(oldWidget);

    print('=========================+++++++didUpdateWidget+++++++======================');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
        future: LocalUser.getUser(),
        builder: (context, snapshot) {
          final userId = snapshot.data?.id ?? '';
          final userWalletId = snapshot.data?.walletId ?? '';

          if (snapshot.connectionState != ConnectionState.done && !snapshot.hasData) {
            return const CustomSplashScreen();
          }

          /// remove the splash screen
          return MaterialApp(
            debugShowCheckedModeBanner: kDebugMode || kProfileMode,
            theme: theme,
            title: displayAppName,
            home: BlocBuilder<StoreBloc, StoreState>(
              bloc: context.read<StoreBloc>()
                ..add(StoreEvent.getUserProfile(userId))
                ..add(StoreEvent.getAllHistory(userId))
                // ..add(const StoreEvent.getAllHistory('logged-in-user'))
                ..add(StoreEvent.addUser(snapshot.data))
                // ..add(
                //   StoreEvent.addUser(
                //     UserProfile.fromJson({
                //       'actualName': 'The User\'s User Name',
                //       'active': false,
                //       'avatar': 'https://robohash.org/robo@robohash.org?gravatar=yes',
                //       'softDeleted': false,
                //       'displayName': 'The User\'s User Name',
                //       'email': 'user_082@mailbox.com',
                //       'id': 'logged-in-user',
                //       'name': 'User Name',
                //       'phone': 'User Phone Number',
                //       'profileId': 'user_profile_id_82911wdd312',
                //       'walletId': 'logged-in-user-wallet',
                //       'historyId': '21w13111',
                //       'last_login_at': DateTime.now().subtract(const Duration(days: 2)).millisecondsSinceEpoch ~/ 1000,
                //       'account_created_at':
                //           DateTime.now().subtract(const Duration(days: 200)).millisecondsSinceEpoch ~/ 1000,
                //     }),
                //   ),
                // )
                // ..add(const StoreEvent.getWallet('logged-in-user-wallet')),
                ..add(StoreEvent.getWallet(userWalletId)),
              builder: (context, state) {
                return BlocListener<StoreBloc, StoreState>(
                  listener: (context, state) {
                    if (state.userProfileDataLoading ||
                        state.getHelpDataLoading ||
                        state.walletDataLoading ||
                        state.historyDataLoading ||
                        state.promotionDataLoading ||
                        state.ticketsDataLoading) {
                      showAppLoader(context);
                    } else {
                      hideAppLoader();
                    }
                  },
                  child: BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state.processing) {
                        showAppLoader(context);
                      } else {
                        hideAppLoader();
                      }
                    },
                    child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: () => Future<void>.delayed(const Duration(seconds: 4)),
                      child: const HomePage(),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}

void hideAppLoader() {
  /// hide loader option 1
  Loader.hide();

  /// hide loader option 2
}

void showAppLoader(BuildContext context) {
  /// show loader option 1
  Loader.show(
    context,
    overlayFromBottom: 80,
    overlayColor: const Color.fromARGB(44, 0, 0, 0),
    progressIndicator: const SizedBox(height: 50, width: 50, child: CircularProgressIndicator()),
  );

  /// show loader option 2
  _refreshIndicatorKey.currentState?.show();
}

final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
