import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/initialization/models/dependency_container.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';

class WebMaterialContext extends StatefulWidget {
  const WebMaterialContext({super.key, required this.dependencyContainer});

  final DependencyContainer dependencyContainer;

  @override
  State<WebMaterialContext> createState() => _WebMaterialContextState();
}

class _WebMaterialContextState extends State<WebMaterialContext> with AppRouter {
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return WindowSizeScope(
      child: DependenciesScope(
        dependencies: widget.dependencyContainer,
        child: MaterialApp.router(
          routerConfig: goRouter,
          builder: (context, child) => MediaQuery(
            data: mediaQueryData.copyWith(
              textScaler: TextScaler.linear(mediaQueryData.textScaler.scale(1).clamp(0.5, 2)),
            ),
            child: child!,
          ),
          debugShowCheckedModeBanner: !kReleaseMode,
        ),
      ),
    );
  }
}
