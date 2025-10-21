import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class OrderFeatureShellRouteController with ChangeNotifier {
  OrderFeatureShellRouteController(this._statefulNavigationShell);

  final StatefulNavigationShell _statefulNavigationShell;
}
