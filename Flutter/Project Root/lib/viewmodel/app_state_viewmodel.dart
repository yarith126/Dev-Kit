import 'package:flutter/material.dart' show ValueNotifier;

class AppState {
  static ValueNotifier<bool> isBusy = ValueNotifier<bool>(false);
}