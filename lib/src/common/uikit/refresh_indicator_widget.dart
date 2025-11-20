import 'package:flutter/material.dart';

class RefreshIndicatorWidget extends StatelessWidget {
  //
  const RefreshIndicatorWidget({required this.onRefresh, required this.child, super.key});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) => RefreshIndicator.adaptive(onRefresh: onRefresh, child: child);
}
