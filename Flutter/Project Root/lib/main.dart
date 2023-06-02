import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// If you want to use DevicePreview, change to true.
bool _enableDevicePreviewMode = false;

dynamic _providers = [];

void main() async {
  await Initializer.init();
  PermissionHelper.requestNotification();
  runApp(MultiProvider(providers: _providers, child: const MyMaterialApp()));
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleViewModel>(builder: (_, c, __) {
      c.fetchSavedLocaleAndCurrency();
      if (_enableDevicePreviewMode && !kReleaseMode) {
        return DevicePreview(
          builder: (_) => MaterialApp(
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            title: 'Example',
            localizationsDelegates: localizationsDelegates,
            supportedLocales: S.delegate.supportedLocales,
            theme: themeData,
            builder: _textScaleAppBuilder,
            home: const SplashScreen(),
          ),
        );
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Example',
        localizationsDelegates: localizationsDelegates,
        supportedLocales: S.delegate.supportedLocales,
        locale: c.locale,
        theme: themeData,
        builder: _textScaleAppBuilder,
        home: const SplashScreen(),
      );
    });
  }
}

Widget _textScaleAppBuilder(BuildContext context, Widget? child) {
  double width = MediaQuery.of(context).size.width;
  double textScaleFactor;
  if (width <= 400) {
    textScaleFactor = 0.9;
  } else if (width <= 800) {
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
