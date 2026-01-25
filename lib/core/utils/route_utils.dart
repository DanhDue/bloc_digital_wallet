import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

Route<T> modalSheetBuilder<T>(BuildContext context, Widget child, AutoRoutePage<T> page) {
  return ModalBottomSheetRoute(
    settings: page,
    builder: (context) => child,
    isScrollControlled: true, // Required
    useSafeArea: false,

    // 'expanded' and 'containerBuilder' are not standard ModalBottomSheetRoute properties.
    // If you need custom container, wrap 'child' in your own widget.
    // If you need expanded behavior, ensure the child takes full height or use specialized widgets.
  );
}

// Optional: Helper to wrap content if needed, though standard usually handles it.
class ModalBottomSheetContainer extends StatelessWidget {
  const ModalBottomSheetContainer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
