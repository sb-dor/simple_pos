import 'package:flutter/material.dart';
import 'package:test_pos_app/src/features/initialization/models/dependency_container.dart';

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({required super.child, required this.dependencies, super.key});

  static DependencyContainer of(BuildContext context) {
    final result = context.getElementForInheritedWidgetOfExactType<DependenciesScope>()?.widget;
    final checkDep = result is DependenciesScope;
    assert(checkDep, 'No DependenciesScope found in context');
    return (result as DependenciesScope).dependencies;
  }

  final DependencyContainer dependencies;

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => false;
}
