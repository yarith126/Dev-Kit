import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWrapper extends StatefulWidget {
  final Widget child;

  const LoadingWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<LoadingWrapper> createState() => _LoadingWrapperState();
}

class _LoadingWrapperState extends State<LoadingWrapper> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ValueListenableBuilder<bool>(
          valueListenable: AppState.isBusy,
          builder: (_, isBusy, __) {
            return isBusy ? const _LoadingWidget() : const SizedBox();
          },
        ),
      ],
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.white70),
        Center(
          child: LoadingAnimationWidget.beat(
            color: Palette.primary,
            size: 40,
          ),
        ),
      ],
    );
  }
}


class LoadingWrapperWithUnfocus extends StatelessWidget {
  final Widget child;

  const LoadingWrapperWithUnfocus({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LoadingWrapper(child: child),
    );
  }
}
