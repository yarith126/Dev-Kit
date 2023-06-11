import 'package:example/res/generated/l10n/l10n.dart';
import 'package:example/initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  // TODO: request permission at startup
  await initLocalStorage();
  await initFirebaseCore();
  initErrorHandler();
  await initFirebaseMessaging();
  await initFlutterLocalNotificationsPlugin();
  runApp(
    MultiProvider(
      providers: _providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Example',
      localizationsDelegates: _localizationsDelegates,
      supportedLocales: S.delegate.supportedLocales,
      // locale: c.locale,
      theme: _themeData,
      darkTheme: _darkThemeData,
      builder: _textScaleAppBuilder,
      home: Container(),
    );
  }
}

/// Top-level providers for MultiProvider
dynamic _providers = [];

/// Light theme
var _themeData = ThemeData(
  useMaterial3: true,
);

/// Dark theme
var _darkThemeData = ThemeData.dark(
  useMaterial3: true,
);

/// Scale text based on screen size
Widget _textScaleAppBuilder(BuildContext context, Widget? child) {
  double width = MediaQuery.of(context).size.width;
  double textScaleFactor;
  if (width <= 456) {
    textScaleFactor = 0.9;
  } else if (width <= 798) {
    textScaleFactor = 1;
  } else if (width <= 1024) {
    textScaleFactor = 1.1;
  } else {
    textScaleFactor = 1.2;
  }
  return MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
    child: child!,
  );
}

/// Localization delegates
const List<LocalizationsDelegate> _localizationsDelegates = [
  S.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];
