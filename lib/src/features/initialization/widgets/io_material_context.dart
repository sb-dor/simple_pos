import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/initialization/logic/desktop_initialization.dart';
import 'package:test_pos_app/src/features/initialization/models/dependency_container.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:window_manager/window_manager.dart';

class IoMaterialContext extends StatefulWidget {
  const IoMaterialContext({super.key, required this.dependencyContainer});

  final DependencyContainer dependencyContainer;

  @override
  State<IoMaterialContext> createState() => _IoMaterialContextState();
}

class _IoMaterialContextState extends State<IoMaterialContext> with WindowListener, AppRouter {
  final fadeTransitionPlatforms = {
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
    TargetPlatform.fuchsia: FadeForwardsPageTransitionsBuilder(),
    TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
  };

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResize() async {
    final getSize = await windowManager.getSize();
    final minSize = desktopMinSize;
    if (getSize.width < minSize.width || getSize.height < minSize.height) {
      windowManager.setMinimumSize(desktopMinSize);
    }
    super.onWindowResize();
  }

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
