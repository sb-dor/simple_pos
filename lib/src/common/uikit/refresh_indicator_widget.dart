import 'package:flutter/material.dart';

class RefreshIndicatorWidget extends StatelessWidget {
  //
  const RefreshIndicatorWidget({super.key, required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(onRefresh: onRefresh, child: child);
  }
}
