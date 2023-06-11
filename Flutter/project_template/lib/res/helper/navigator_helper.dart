import 'package:flutter/material.dart';

/// A navigator helper
///
/// Created in purpose of reducing boilerplate code but at a cost of losing
/// functionalities like named route feature and anything else.
///
/// Parameter for push, replace, and reset:
/// {@template BuildContext.Navigator.parameter}
/// Page route will be created with [child]
///
/// Pass [anim] to use pre-made screen transition animation
/// {@endtemplate}
extension ExtendedNavigator on BuildContext {
  /// Push route
  ///
  /// {@macro BuildContext.Navigator.parameter}
  Future<T?> push<T extends Object?>(Widget child, [GoAnim? anim]) {
    return Navigator.push(this, _getPageRoute(child, anim));
  }

  /// Push replacement route
  ///
  /// {@macro BuildContext.Navigator.parameter}
  Future<T?> pushReplacement<T extends Object?>(Widget child, [GoAnim? anim]) {
    return Navigator.pushReplacement(this, _getPageRoute(child, anim));
  }

  /// Push route and remove all other routes
  ///
  /// {@macro BuildContext.Navigator.parameter}
  Future<T?> pushAndRemoveAll<T extends Object?>(Widget child, [GoAnim? anim]) {
    return Navigator.pushAndRemoveUntil(
        this, _getPageRoute(child, anim), (_) => false);
  }

  /// Pop route
  void pop<T extends Object?>([T? result]) {
    if (!Navigator.canPop(this)) {
      return debugPrint('Navigator: Fail to pop page');
    }
    Navigator.pop(this);
  }
}

enum GoAnim { fade }

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
