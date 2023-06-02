import 'package:flutter/material.dart';

class ErrorDialog {
  static show() {
    if (navigatorKey.currentContext == null) {
      return;
    }

    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        // TODO: implement dialog
        return Container();
      },
    );
  }
}

/// Flutter fatal screen
class FlutterFatalScreen extends StatelessWidget {
  const FlutterFatalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement screen
    return Container();
  }
}

/// Play Services unavailable screen
class PlayServicesUnavailableScreen extends StatelessWidget {
  const PlayServicesUnavailableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement screen
    return Container();
  }
}
