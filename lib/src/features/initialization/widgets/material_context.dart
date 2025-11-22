import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/initialization/models/dependency_container.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';

class MaterialContext extends StatefulWidget {
  const MaterialContext({required this.dependencyContainer, super.key});

  final DependencyContainer dependencyContainer;

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> with AppRouter {
  final fadeTransitionPlatforms = {
    TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
    TargetPlatform.macOS: const CupertinoPageTransitionsBuilder(),
    // you can add background color for below code
    TargetPlatform.android: const FadeForwardsPageTransitionsBuilder(),
    TargetPlatform.fuchsia: const FadeForwardsPageTransitionsBuilder(),
    TargetPlatform.windows: const FadeForwardsPageTransitionsBuilder(),
  };

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return WindowSizeScope(
      child: DependenciesScope(
        dependencies: widget.dependencyContainer,
        child: MaterialApp.router(
          builder: (context, child) => MediaQuery(
            data: mediaQueryData.copyWith(
              textScaler: TextScaler.linear(mediaQueryData.textScaler.scale(1).clamp(0.5, 2)),
            ),
            child: child!,
          ),
          routerConfig: goRouter,
          debugShowCheckedModeBanner: !kReleaseMode,
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(builders: fadeTransitionPlatforms),
          ),
        ),
      ),
    );
  }
}
