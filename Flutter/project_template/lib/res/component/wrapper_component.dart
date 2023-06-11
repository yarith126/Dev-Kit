import 'package:flutter/material.dart';
import '../../viewmodel/app_state_viewmodel.dart';

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
            return isBusy ? _loadingWidget : const SizedBox();
          },
        ),
      ],
    );
  }

  final Widget _loadingWidget = Stack(
    children: [
      Container(color: Colors.white70),
      const CircularProgressIndicator(),
    ],
  );
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
