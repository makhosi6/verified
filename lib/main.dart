// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:appscheme/appscheme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/validation.dart';
import 'package:verified/app_config.dart';
import 'package:verified/application/appbase/appbase_bloc.dart';
import 'package:verified/application/auth/auth_bloc.dart';
import 'package:verified/application/payments/payments_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/application/verify_sa/verify_sa_bloc.dart';
import 'package:verified/domain/models/device.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/firebase_options.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/infrastructure/auth/local_user.dart';
import 'package:verified/infrastructure/auth/repository.dart';
import 'package:verified/infrastructure/payments/repository.dart';
import 'package:verified/infrastructure/store/repository.dart';
import 'package:verified/infrastructure/verifysa/repository.dart';
import 'package:verified/presentation/pages/capture_candidate_details_page.dart';
import 'package:verified/presentation/pages/custom_splash_screen.dart';
import 'package:verified/presentation/pages/error_page.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/pages/transactions_page.dart';
import 'package:verified/presentation/pages/verification_info_page.dart';
import 'package:verified/presentation/pages/verification_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/app_info.dart';
import 'package:verified/presentation/utils/device_info.dart';
import 'package:verified/presentation/utils/lottie_loader.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/services/dio.dart';
import 'package:verified/services/navigator_observer.dart';
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
  final device = await getCurrentDeviceInfo();
  final package = await getVerifiedPackageInfo();

  /// Force disable Crashlytics in dev environment
  if (kDebugMode) await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  FirebaseCrashlytics.instance.setUserIdentifier(device['id']);

  ///
  if (kReleaseMode) {
    FirebaseAnalytics.instance
      ..setUserProperty(
        name: 'VERIFIED_SUI',
        value: 'sui_${device['id']}',
      )
      ..setUserProperty(
        name: 'VERIFIED_VERSION',
        value: 'v${package['version']}',
      );
    FirebaseAnalytics.instance.setUserId(id: device['id']);
    if (!kIsWeb) FirebaseAnalytics.instance.setDefaultEventParameters({'version': package['version']});
  }

  /// Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

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
      final host = (device['isPhysicalDevice'] == true) ? '192.168.0.132' : 'localhost';
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      await FirebaseAuth.instance.useAuthEmulator('192.168.0.132', 9099);
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
    ErrorWidget.builder = (details) {
      ///
      verifiedErrorLogger(details);
      FirebaseCrashlytics.instance.recordError(
        details.exception,
        details.stack,
        reason: details.summary.toDescription(),
        fatal: true,
      );

      ///
      return MaterialApp(
        theme: theme,
        debugShowCheckedModeBanner: false,
        title: 'Error: $displayAppName',
        navigatorObservers: [VerifiedNavigatorObserver()],
        home: VerifiedErrorPage(
          key: Key('fallback-error-page-${details.hashCode}'),
          message: details.summary.toDescription(),
        ),
      );
    };

    ///

    runApp(
      const RootAppWithBloc(),
    );

    ///
  }, (error, stackTrace) async {
    verifiedErrorLogger(error, stackTrace);
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: error.toString(),
      fatal: true,
    );

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

  ///
  SnackbarValue? snackBarValue;
  String? uriUuidFragment;

  ///
  late AppLinks _appLinks;
  late AppScheme? _appScheme;
  StreamSubscription<Uri>? _linkSubscription;

  ///

  @override
  void initState() {
    super.initState();

    ///
    _initDeepLinks();

    ///
    FirebaseMessaging.instance.getToken().then(_setFMCToken);

    ///
    FirebaseMessaging.instance.onTokenRefresh.listen(_setFMCToken);

    ///
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  @override
  void didChangeDependencies() {
    //log changing deps
    verifiedLogger('=========================+++++++didChangeDependencies+++++++======================');

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant AppRoot oldWidget) {
    verifiedLogger('=========================+++++++didUpdateWidget+++++++======================');

    super.didUpdateWidget(oldWidget);
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();
    _appScheme = AppSchemeImpl.getInstance();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen(_openAppLink);
    _appScheme?.getInitScheme().then((value) {
      verifiedLogger('APP SCHEME VALUE:  $value ||  Init  ${value?.dataString}');
      if (value != null) {
        var uri = Uri.parse(value.dataString ?? '${value.host}/{$value.path}');
        _openAppLink(uri);
      }
    });
    _appScheme?.registerSchemeListener().listen((value) {
      verifiedLogger('APP SCHEME VALUE2:  $value ||  Init  ${value?.dataString}');
      var uri = Uri.parse(value?.dataString ?? '${value?.host}/{$value.path}');
      _openAppLink(uri);
    });
  }

  void _openAppLink(Uri uri) {
    var urlSegments = uri.toString().split('/').where((segment) => UuidValidation.isValidUUID(fromString: segment));
    verifiedLogger('A VALID UUID SEGMENT: $urlSegments');

    if (mounted) {
      setState(() {
        uriUuidFragment = urlSegments.isNotEmpty ? urlSegments.first : null;
        snackBarValue = (urlSegments.isEmpty)
            ? SnackbarValue.error
            : (urlSegments.length > 1)
                ? SnackbarValue.warning
                : (urlSegments.length == 1)
                    ? SnackbarValue.success
                    : SnackbarValue.unknown;
      });

      ///
      if (snackBarValue == SnackbarValue.success || snackBarValue == SnackbarValue.warning) {
        VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_TRIGGER_VERIFICATION_WITH_DEEP_LINK);
      }

      ///
      verifiedLogger('Set Snackbar State: $uriUuidFragment  |  $snackBarValue');

      ///

      Future.delayed(
        const Duration(seconds: 2),
        () => _displaySnackBarAndNavigate(context, value: snackBarValue ?? SnackbarValue.unknown),
      );
    }

    //
  }

  _setFMCToken(fcmToken) {
    if (mounted && (token != fcmToken)) {
      verifiedLogger('\n\nFMC TOKEN 2: $fcmToken\n\n');
      setState(() {
        token = fcmToken;
      });
    }
  }

  void _displaySnackBarAndNavigate(BuildContext context, {required SnackbarValue value}) async {
    try {
      debugPrint('Try to display the snackbar $value');
      final __uriUuidFragment = uriUuidFragment;
      final __snackBarValue = snackBarValue;
      final user = await LocalUser.getUser();
      debugPrint('???? ==> $mounted  && $uriUuidFragment && $snackBarValue');
      if (mounted && (uriUuidFragment != null || snackBarValue != null)) {
        verifiedLogger('RESET THE SNACKBAR STATE');
        setState(() {
          uriUuidFragment = null;
          snackBarValue = null;
        });
      }

      switch (__snackBarValue) {
        case SnackbarValue.error:
          {
            ScaffoldMessenger.of(_navigatorKey.currentState?.context ?? context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: const Text(
                    'Invalid Launch URL',
                  ),
                  backgroundColor: errorColor,
                ),
              );

            break;
          }
        case SnackbarValue.warning:
          {
            ScaffoldMessenger.of(_navigatorKey.currentState?.context ?? context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: const Text(
                    'Warning: Minor error detected on the URL',
                  ),
                  backgroundColor: warningColor,
                ),
              );

            navigateToNamedRoute(
              _navigatorKey.currentState?.context ?? context,
              arguments: VerificationPageArgs(
                __uriUuidFragment ?? '0000000-0000-0000-0000-00000000000',
              ),
              replaceCurrentPage: user == null,
            );
            break;
          }
        case SnackbarValue.success:
          {
            ScaffoldMessenger.of(_navigatorKey.currentState?.context ?? context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: const Text(
                    'Launching a Verification Page',
                  ),
                  backgroundColor: primaryColor,
                ),
              );

            navigateToNamedRoute(_navigatorKey.currentState?.context ?? context,
                arguments: VerificationPageArgs(
                  __uriUuidFragment ?? '0000000-0000-0000-0000-00000000000',
                ),
                replaceCurrentPage: user == null);
            break;
          }
        default:
          {
            verifiedLogger('Unknown Value($value) at displaySnackbar');
          }
      }
    } catch (error, stackTrace) {
      verifiedErrorLogger(error, stackTrace);
    }
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
    selectNotificationSubject.stream.listen(
      (_) async {
        navigate(
          context,
          page: const TransactionPage(),
        );
      },
    );
  }

  void _hideAppLoader() {
    verifiedLogger('HIDE LOADER...');

    /// hide loader option 1
    Loader.hide();
  }

  void _showAppLoader(BuildContext context) {
    verifiedLogger('SHOW LOADER...');

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

    ///
    Future.delayed(
      const Duration(seconds: 2),
      () => _displaySnackBarAndNavigate(context, value: snackBarValue ?? SnackbarValue.unknown),
    );
  }

  @override
  Widget build(BuildContext context) {
    ///
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    ///
    return MaterialApp(
      navigatorKey: _navigatorKey,
      navigatorObservers: [VerifiedNavigatorObserver()],
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: displayAppName,
      routes: {
        '/secure': (context) => VerificationPage(
              key: UniqueKey(),
            ),
        '/captured-details': (context) => CaptureCandidateDetailsPage(
              key: UniqueKey(),
            ),
        '/captured-details-info': (context) => VerificationInfoPage(
              key: UniqueKey(),
            )
      },
      home: FutureBuilder<UserProfile?>(
        future: LocalUser.getUser(),
        builder: (context, snapshot) {
          final userId = snapshot.data?.id ?? '';
          final userWalletId = snapshot.data?.walletId ?? '';

          /// splash screen
          if (snapshot.connectionState != ConnectionState.done) {
            return const CustomSplashScreen();
          }

          return BlocListener<StoreBloc, StoreState>(
            bloc: context.read<StoreBloc>()
              ..add(const StoreEvent.apiHealthCheck())
              ..add(StoreEvent.addUser(snapshot.data))
              ..add(StoreEvent.getAllHistory(userId))
              ..add(StoreEvent.getUserProfile(userId))
              ..add(StoreEvent.getWallet(userWalletId)),
            listener: (context, state) {
              /// has a pending store API request
              bool storeRequestInProgress = state.userProfileDataLoading ||
                  state.getHelpDataLoading ||
                  state.walletDataLoading ||
                  state.decodePassportDataLoading ||
                  state.historyDataLoading ||
                  state.promotionDataLoading ||
                  state.uploadsDataLoading ||
                  state.isUploadingDocs ||
                  state.searchPersonIsLoading ||
                  state.ticketsDataLoading ||
                  false;

              if (storeRequestInProgress) {
                _showAppLoader(context);
              } else {
                _hideAppLoader();
              }

              final hasUser = state.userProfileData != null;
              final hasToken = token != null;
              final isNewToken = state.userProfileData?.notificationToken != token;

              if (hasUser && isNewToken && hasToken) {
                Future.delayed(const Duration(seconds: 10), () async {
                  try {
                    verifiedLogger('UPDATE Its A NEW TOKEN, $isNewToken | $hasToken | $hasUser | $token');
                    verifiedLogger('was_token ${state.userProfileData?.notificationToken}');
                    var _currentDevice = await getCurrentDevice();
                    // ignore: use_build_context_synchronously
                    context.read<StoreBloc>().add(
                          StoreEvent.updateUserProfile(
                            state.userProfileData!.copyWith(
                              devices: [_currentDevice ?? Device()],
                              currentSui: _currentDevice?.uuid,
                              notificationToken: token,
                            ),
                          ),
                        );
                  } catch (error, stackTrace) {
                    verifiedErrorLogger(error, stackTrace);
                  }
                });
              }
            },
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.processing) {
                  _showAppLoader(context);
                } else {
                  _hideAppLoader();
                }
              },
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () => Future.delayed(const Duration(seconds: 3)),
                child: const HomePage(),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }
}

//
final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

//
enum SnackbarValue { error, warning, success, unknown }

//
final _navigatorKey = GlobalKey<NavigatorState>();
