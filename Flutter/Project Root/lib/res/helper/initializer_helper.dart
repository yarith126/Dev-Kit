import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../errors.dart';

late final FirebaseCrashlytics firebaseCrashlytics;
late final FirebaseMessaging firebaseMessaging;

/// Initializes necessary services at startup
initializeStartupServices() async {
  await _initLocalStorage();
  await _initFirebaseCore();
  _initErrorHandler();
  await _initFirebaseMessaging();
  await _initFlutterLocalNotificationsPlugin();
}

/// Hive with FlutterSecureStorage
///
/// It also triggers WidgetsFlutterBinding.ensureInitialized()
/// Data is encrypted with AES encryption.
/// Data will be lost if key somehow is mismatched.
_initLocalStorage() async {
  await Hive.initFlutter();
  const secureStorage = FlutterSecureStorage();

  final tmpEncryptionKey = await secureStorage.read(key: 'key');
  if (tmpEncryptionKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(key: 'key', value: base64UrlEncode(key));
  }

  var encryptionKey = await secureStorage.read(key: 'key');
  final encryptionKeyUint8List = base64Url.decode(encryptionKey!);
  final hiveAesCipher = HiveAesCipher(encryptionKeyUint8List);
  await Hive.openBox('example', encryptionCipher: hiveAesCipher);
}

_initFirebaseCore() async {
  /// Check for Play Services availability
  // TODO: implement GoogleApi invoke method
  if (Platform.isAndroid) {
    var platform = const MethodChannel('GoogleApi');
    int res = await platform.invokeMethod('hasPlayService');
    if (res != 0) {
      // TODO: this may not be a good approach
      // runApp(const MaterialApp(home: PlayServicesUnavailableScreen()));
      // throw Exception('Can not start without Play Services');
    }
  }

  await Firebase.initializeApp();
  firebaseCrashlytics = FirebaseCrashlytics.instance;
  firebaseMessaging = FirebaseMessaging.instance;
}

/// Error handler
///
/// It sends errors to Firebase Crashlytics in release and profile mode.
_initErrorHandler() {
  if (!kDebugMode) {
    // Set Flutter fatal screen
    ErrorWidget.builder = (errorDetails) => const FlutterFatalScreen();
    // Handles Flutter fatal errors
    FlutterError.onError = firebaseCrashlytics.recordFlutterFatalError;
  }

  // Handles platform errors like Dart and native errors
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    if (!kDebugMode) {
      firebaseCrashlytics.recordError(error, stackTrace, fatal: true);
    }
    // Logger.logError(error, stackTrace);
    // AppState.isBusy.value = false;
    // navigatorKey.currentState?.pop();
    // showPlatformErrorDialog();
    return true;
  };
}

_initFirebaseMessaging() async {
  final fcmToken = await firebaseMessaging.getToken();

  // TODO: If necessary send token to application server.
  firebaseMessaging.onTokenRefresh.listen((fcmToken) {
    // Note: This callback is fired at each app startup and whenever a new
    // token is generated.
  }).onError((err) {
    // Error getting token.
  });

  // Foreground state message handler
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);

  // Background state message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Terminated state message handler
  await firebaseMessaging.getInitialMessage();
}

_initFlutterLocalNotificationsPlugin() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await FlutterLocalNotificationsPlugin().initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: _notificationTap,
    onDidReceiveBackgroundNotificationResponse: _notificationTap,
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // TODO: show notification
}

@pragma('vm:entry-point')
void _notificationTap(NotificationResponse response) {
  // var json = decodeJson(response.payload ?? '');
  // if (json['type'] == null) return;
  // if (json['type'] == 'chat') route.push(const CustomerServiceScreen());
}
