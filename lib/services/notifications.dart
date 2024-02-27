
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:verified/firebase_options.dart';
import 'package:verified/presentation/theme.dart';

/// https://firebase.flutter.dev/docs/messaging/usage/
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

const channel = AndroidNotificationChannel(
  'com.byteestudio.verified.urgent', // id
  'Importance Verified Notifications', // title
  description:
      'This channel is used for important notifications and alerts.', // description
  importance: Importance.high,
  playSound: true,
);

// flutter local notification
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// firebase background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /// APP FIREBASE CONFIG
  await Firebase.initializeApp(
    name: (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS)
        ? null
        : 'firebaseSecondaryInstance',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    print('A Background message just showed up :  ${message.messageId}');
  }

  ///
  showMsgOnBackground(message);
}

/// Request Alerts Permissions

Future<void> requestPermissions() async {
  ///
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }
}

@pragma('vm:entry-point')
void onMsgOpen(RemoteMessage message) {
  if (kDebugMode) {
    print('A new message open, app event was published');
  }
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          color: primaryColor,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
      payload: jsonEncode({
        'id': notification.hashCode,
        'title': notification.title,
        'body': notification.body,
      }),
    );
  }
}

///
@pragma('vm:entry-point')
void onMsg(RemoteMessage message) {
  if (kDebugMode) print(message);
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          color: primaryColor,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
      payload: jsonEncode({
        'id': notification.hashCode,
        'title': notification.title,
        'body': notification.body,
      }),
    );
  }

}

///
@pragma('vm:entry-point')
void showMsgOnBackground(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
      payload: jsonEncode({
        'id': notification.hashCode,
        'title': notification.title,
        'body': notification.body,
      }),
    );
  }

}

///
@pragma('vm:entry-point')
void setToken(String? token) async {
    print('FCM Token: $token');
 
}
@pragma('vm:entry-point')
onDidReceive(NotificationResponse notificationResponse) async {
  print(
      'FB Notification payload on onDidReceiveNotificationResponse/onDidReceiveBackgroundNotificationResponse: $notificationResponse');
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

///
void localMsg(CustomMessage message) {
  if (kDebugMode) print(message);
  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.title,
    message.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        color: primaryColor,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      ),
    ),
    payload: jsonEncode({
      'id': message.hashCode,
      'title': message.title,
      'body': message.body,
    }),
  );
}

class CustomMessage {
  CustomMessage({required this.title, required this.body});

  String title;
  String body;
}