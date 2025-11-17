import 'package:flutter/material.dart';
import 'package:test_pos_app/src/features/initialization/models/dependency_container.dart';

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({super.key, required super.child, required this.dependencies});

  static DependencyContainer of(BuildContext context) {
    final result = context.getElementForInheritedWidgetOfExactType<DependenciesScope>()?.widget;
    final checkDep = result is DependenciesScope;
    assert(checkDep, 'No DependenciesScope found in context');
    return (result as DependenciesScope).dependencies;
  }

  final DependencyContainer dependencies;

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) {
    return false;
  }
}
