import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyLocale {
  static Locale get english => const Locale('en');

  static Locale get khmer => const Locale('km');
}

const List<LocalizationsDelegate> localizationsDelegates = [
  S.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];