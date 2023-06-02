import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

enum GoAnim { fade }

/// A navigator helper
///
/// Created in purpose of reducing boilerplate code but at a cost of losing
/// functionalities like named route etc.
///
/// Parameter for push, replace, and reset:
/// {@template BuildContext.Navigator.parameter}
/// Pass a widget [child] for screen and an optional parameter [anim] to use
/// pre-made screen transition animation
/// {@endtemplate}
extension Navigator on BuildContext {
  /// Push a page
  ///
  /// {@macro BuildContext.Navigator.parameter}
  Future<T?> push<T extends Object?>(Widget child, [GoAnim? anim]) {
    if (!_isNotNullNavigatorState()) return Future.value(null);
    return navigatorKey.currentState!.push(_getPageRoute(child, anim));
  }

  /// Replace a page
  ///
  /// {@macro BuildContext.Navigator.parameter}
  Future<T?> replace<T extends Object?>(Widget child, [GoAnim? anim]) {
    if (!_isNotNullNavigatorState()) return Future.value(null);
    return navigatorKey.currentState!.pushReplacement(
      _getPageRoute(child, anim),
    );
  }

  /// Reset and push a page
  ///
  /// {@macro BuildContext.Navigator.parameter}
  Future<T?> reset<T extends Object?>(Widget child, [GoAnim? anim]) {
    if (!_isNotNullNavigatorState()) return Future.value(null);
    return navigatorKey.currentState!.pushAndRemoveUntil(
      _getPageRoute(child, anim),
      (route) => false,
    );
  }

  /// Pop current page out of stacks
  void pop<T extends Object?>([T? result]) {
    if (_canPopNavigator()) {
      navigatorKey.currentState?.pop([result]);
    }
  }

  bool _isNotNullNavigatorState() {
    if (navigatorKey.currentState == null) {
      debugPrint('WARNING: navigator.currentState is null');
      return false;
    }
    return true;
  }

  bool _canPopNavigator() {
    if (!_isNotNullNavigatorState()) return false;
    if (!navigatorKey.currentState!.canPop()) {
      debugPrint('WARNING: navigator.currentState!.canPop() is false');
      return false;
    }
    return true;
  }
}

Route<T> _getPageRoute<T extends Object?>(Widget child, [GoAnim? anim]) {
  if (anim == GoAnim.fade) {
    return _CustomPageRoute(child);
  }
  return MaterialPageRoute(builder: (_) => child);
}

/// Jump out with fade Transition, jump in with default transition
class _CustomPageRoute<T> extends PageRoute<T> {
  final Widget child;

  _CustomPageRoute(this.child);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => false;

  @override
  Widget buildPage(context, anim1, anim2) {
    var mainAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: anim1, curve: Curves.fastOutSlowIn));
    return FadeTransition(opacity: mainAnim, child: child);
  }

  @override
  Widget buildTransitions(context, anim1, anim2, child) {
    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    return theme.buildTransitions<T>(this, context, anim1, anim2, child);
  }
}
