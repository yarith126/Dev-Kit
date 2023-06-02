import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';


late final FirebaseCrashlytics firebaseCrashlytics;
late final FirebaseMessaging firebaseMessaging;

class Initializer {
  static init() async {
    await _initLocalStorage();

    await _initFirebaseCore();

    _initFirebaseCrashlyticsAndErrorHandler();

    await _initFirebaseMessaging();

    await _initFlutterLocalNotificationsPlugin();
  }
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
  await Hive.openBox('app_setting', encryptionCipher: hiveAesCipher);
  await Hive.openBox('credential', encryptionCipher: hiveAesCipher);
}

_initFirebaseCore() async {
  /// Check for Play Services availability
  /// Show error screen, Play Services isn't available.
  // TODO: implement GoogleApi invoke method
  if (Platform.isAndroid) {
    var platform = const MethodChannel('GoogleApi');
    int res = await platform.invokeMethod('hasPlayService');
    if (res != 0) {
      runApp(const MaterialApp(home: PlayServicesUnavailableScreen()));
      throw Exception('Can not start without Play Services');
    }
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  firebaseCrashlytics = FirebaseCrashlytics.instance;
  firebaseMessaging = FirebaseMessaging.instance;
}

/// Catches any errors in app and log to console
/// It sends errors to Firebase Crashlytics in release and profile mode.
_initFirebaseCrashlyticsAndErrorHandler() {
  if (!kDebugMode) {
    // Set Flutter fatal screen
    ErrorWidget.builder = (errorDetails) => const FlutterFatalScreen();
    // Handles Flutter fatal errors
    FlutterError.onError = firebaseCrashlytics.recordFlutterFatalError;
  }

  // Handles non-Flutter errors including native side
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    if (!kDebugMode) {
      firebaseCrashlytics.recordError(error, stackTrace, fatal: true);
    }
    Logger.reportError(error, stackTrace);
    AppState.isBusy.value = false;
    Go.back();
    ErrorDialog.show();
    return true;
  };
}

_initFirebaseMessaging() async {
  final fcmToken = await firebaseMessaging.getToken();
  Logger.error(fcmToken);

  /// Token handler
  firebaseMessaging.onTokenRefresh.listen((fcmToken) {
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new
    // token is generated.
  }).onError((err) {
    // Error getting token.
  });

  // Foreground message handler
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);

  // Background message handler
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
  await NotificationHandler.flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: _notificationTap,
    onDidReceiveBackgroundNotificationResponse: _notificationTap,
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  NotificationHandler.showNotification(message);
}

@pragma('vm:entry-point')
void _notificationTap(NotificationResponse response) {
  Logger.success(response.payload);
  var json = decodeJson(response.payload ?? '');
  if (json['type'] == null) return;
  if (json['type'] == 'chat') Go.to(const CustomerServiceScreen());
}
