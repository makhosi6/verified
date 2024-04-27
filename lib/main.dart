import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:verified/app_config.dart';
import 'package:verified/application/appbase/appbase_bloc.dart';
import 'package:verified/application/auth/auth_bloc.dart';
import 'package:verified/application/payments/payments_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/application/verify_sa/verify_sa_bloc.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/firebase_options.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/infrastructure/auth/local_user.dart';
import 'package:verified/infrastructure/auth/repository.dart';
import 'package:verified/infrastructure/payments/repository.dart';
import 'package:verified/infrastructure/store/repository.dart';
import 'package:verified/infrastructure/verifysa/repository.dart';
import 'package:verified/presentation/pages/custom_splash_screen.dart';
import 'package:verified/presentation/pages/error_page.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/pages/transactions_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/device_info.dart';
import 'package:verified/presentation/utils/lottie_loader.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/services/dio.dart';
import 'package:verified/services/notifications.dart';
import 'package:rxdart/subjects.dart';

// await flutterLocalNotificationsPlugin.cancelAll();

///
BehaviorSubject<Map<String, dynamic>?> selectNotificationSubject = BehaviorSubject<Map<String, dynamic>?>();

///
bool didNotificationLaunchApp = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS) ? null : 'firebasePrimaryInstance',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ///
  NotificationAppLaunchDetails? notificationAppLaunchDetails =
      !kIsWeb && Platform.isLinux ? null : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  ///
  didNotificationLaunchApp = notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  ///
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    /// Payload as a String
  }
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (
        int id,
        String? title,
        String? body,
        String? payload,
      ) async {
        didReceiveLocalNotificationSubject.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      });

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  /// init on boot
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse: onDidReceive,
    onDidReceiveNotificationResponse: onDidReceive,
  );

  ///
  if (kDebugMode) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      var device = await getCurrentDeviceInfo();
      final host = (device['isPhysicalDevice'] == true) ? '192.168.0.132' : 'localhost';
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await FirebaseAuth.instance.useAuthEmulator('0.0.0.0', 9099);
    }
  }

  runZonedGuarded(() async {
    ///
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Firebase messaging
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    ///
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    /// listen to push notification when app is on the foreground
    FirebaseMessaging.onMessage.listen(onMsg);

    /// listen to push notification event, like, 'notification_opened'
    // FirebaseMessaging.onMessageOpenedApp.listen(onMsgOpen);

    /// listen to push notification when app is on the background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    /// Fallback page onError
    ErrorWidget.builder = (details) => MaterialApp(
          home: VerifiedErrorPage(
            key: const Key('fallback-error-page'),
            message: details.summary.toDescription(),
          ),
        );

    ///

    runApp(
      const RootAppWithBloc(),
    );

    ///
  }, (error, stack) {
    verifiedErrorLogger(error);
    if (kDebugMode) print(stack);

    /// fb crush
  });
}

class RootAppWithBloc extends StatelessWidget {
  const RootAppWithBloc({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppbaseBloc>(
          create: (context) => AppbaseBloc({})
            ..add(
              const AppbaseEvent.getAppInfo(),
            ),
        ),
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
          create: (BuildContext context) => StoreBloc(
            StoreRepository(
              StoreDioClientService.instance,
            ),
          )..add(
              const StoreEvent.apiHealthCheck(),
            ),
        ),
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(
            AuthRepository(
              FirebaseAuth.instance,
            ),
            context.read<StoreBloc>(),
          ),
        ),
        BlocProvider(
          create: (context) => PaymentsBloc(
            PaymentsRepository(
              PaymentsDioClientService.instance,
            ),
          ),
        )
      ],
      child: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  //with SingleTickerProviderStateMixin
  String? token;

  @override
  void didChangeDependencies() {
//log changing deps
    super.didChangeDependencies();
    print('=========================+++++++didChangeDependencies+++++++======================');
  }

  @override
  void didUpdateWidget(covariant AppRoot oldWidget) {
    super.didUpdateWidget(oldWidget);

    print('=========================+++++++didUpdateWidget+++++++======================');
  }

  @override
  void initState() {
    super.initState();

    ///
    FirebaseMessaging.instance.getToken().then((fcmToken) {
      print('\n\nFMC TOKEN 2: $fcmToken\n\n');

      token = fcmToken;
    });

    ///
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print('\n\nFMC TOKEN: $fcmToken\n\n');

      token = fcmToken;
    }).onError((err) {
      print('Error while trying to get a TOKEN ${err.toString()}');
    });

    ///
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream.listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        barrierColor: darkBlurColor,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null ? Text(receivedNotification.title!) : null,
          content: receivedNotification.body != null ? Text(receivedNotification.body!) : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                navigate(context, page: const TransactionPage());
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((payload) async {
      navigate(context, page: const TransactionPage());
    });
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
            builder: FToastBuilder(),
            debugShowCheckedModeBanner: false,
            theme: theme,
            title: displayAppName,
            home: BlocListener<StoreBloc, StoreState>(
              bloc: context.read<StoreBloc>()
                ..add(StoreEvent.addUser(snapshot.data))
                ..add(StoreEvent.getAllHistory(userId))
                ..add(StoreEvent.getUserProfile(userId))
                ..add(StoreEvent.getWallet(userWalletId)),
              listener: (context, state) async {
                // if (state.userProfileData is! UserProfile && snapshot.data != null) {
                //   context.read<StoreBloc>().add(StoreEvent.addUser(snapshot.data));
                //   print('===========EXIT===============');
                //   if (kDebugMode) exit(0);
                // }

                if (state.userProfileDataLoading ||
                    state.getHelpDataLoading ||
                    state.walletDataLoading ||
                    state.historyDataLoading ||
                    state.promotionDataLoading ||
                    state.uploadsDataLoading ||
                    state.ticketsDataLoading) {
                  showAppLoader(context);
                } else {
                  hideAppLoader();
                }
                if (state.userProfileData != null &&
                    (state.userProfileData?.notificationToken != token) &&
                    (token != null)) {
                  Future.delayed(const Duration(seconds: 5), () {
                    try {
                      context.read<StoreBloc>().add(
                            StoreEvent.updateUserProfile(
                              state.userProfileData!.copyWith(
                                notificationToken: token,
                              ),
                            ),
                          );
                    } catch (e) {
                      print('Error while trying to add a token,  $e');
                    }
                  });
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
                  onRefresh: () => Future<void>.delayed(const Duration(seconds: 2)),
                  child: const HomePage(),
                ),
              ),
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
    overlayColor: darkBlurColor,
    progressIndicator: const LottieProgressLoader(
      key: Key('lottie_progress_loader'),
    ),
  );

  /// show loader option 2
  _refreshIndicatorKey.currentState?.show();
}

final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
