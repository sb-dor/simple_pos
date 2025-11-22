import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:test_pos_app/src/features/authentication/widgets/authentication_auth_check_widget.dart';
import 'package:test_pos_app/src/features/authentication/widgets/authentication_login_widget.dart';
import 'package:test_pos_app/src/features/authentication/widgets/authentication_register_widget.dart';
import 'package:test_pos_app/src/features/authentication/widgets/authentication_select_establishment_widget.dart';
import 'package:test_pos_app/src/features/cashier_feature/widgets/cashier_page.dart';
import 'package:test_pos_app/src/features/categories/widgets/categories_widget.dart';
import 'package:test_pos_app/src/features/category_creation/widgets/category_creation_config_widget.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/order_feature/widgets/sales_mode_screen.dart';
import 'package:test_pos_app/src/features/order_feature/widgets/widgets/sales_mode_products_screen.dart';
import 'package:test_pos_app/src/features/order_feature/widgets/widgets/sales_mode_settings_screen.dart';
import 'package:test_pos_app/src/features/order_tables/widgets/order_feature_page.dart';
import 'package:test_pos_app/src/features/product_creation/widgets/product_creation_config_widget.dart';
import 'package:test_pos_app/src/features/products/widgets/products_widget.dart';
import 'package:test_pos_app/src/features/table_creation/widgets/table_creation_widget.dart';
import 'package:test_pos_app/src/features/tables/widgets/tables_widget.dart';

abstract class AppRoutesName {
  static const String authentication = '/authentication';
  static const String login = '/login';
  static const String register = '/register';
  static const String establishmentsSelection = '/establishments';
  static const String orderTables = '/order-tables';
  static const String cashier = '/cashier/:cashierId';
  static const String tables = '/tables';
  static const String creation = '/creation';
  static const String categories = '/categories';
  static const String products = '/products';
}

mixin AppRouter<T extends StatefulWidget> on State<T> {
  late final GoRouter goRouter;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context);
    goRouter = GoRouter(
      observers: [
        FirebaseAnalyticsObserver(
          analytics: FirebaseAnalytics.instance,
          nameExtractor: (settings) => settings.name,
        ),
        _LocalNavigatorLoggerObserver(dependencies.logger),
      ],
      redirect: (context, state) {
        final authenticationBloc = DependenciesScope.of(context).authenticationBloc;
        if (authenticationBloc.state is Authentication$AuthenticatedState) {
          if (state.name == AppRoutesName.login || state.name == AppRoutesName.register) {
            return AppRoutesName.orderTables;
          }
          return null;
        }
        return null;
      },
      initialLocation: AppRoutesName.authentication,
      routes: [
        GoRoute(
          path: AppRoutesName.authentication,
          builder: (context, state) {
            return const AuthenticationAuthCheckWidget(); //ImageProductSaverWidget AuthenticationAuthCheckWidget();
          },
          routes: [
            GoRoute(
              path: AppRoutesName.login,
              builder: (context, state) => const AuthenticationLoginWidget(),
            ),
            GoRoute(
              path: AppRoutesName.register,
              builder: (context, state) => const AuthenticationRegisterWidget(),
            ),
            GoRoute(
              path: AppRoutesName.establishmentsSelection,
              builder: (context, state) => const AuthenticationSelectEstablishmentWidget(),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutesName.orderTables,
          builder: (context, state) => const OrderFeaturePage(),
          routes: [
            StatefulShellRoute.indexedStack(
              builder: (context, state, navigationShell) => SalesModeScreen(
                key: UniqueKey(), // refresh every time while user refreshes by path
                statefulNavigationShell: navigationShell,
                goRouterState: state,
              ),
              branches: [
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/products',
                      builder: (context, state) {
                        if (!state.uri.queryParameters.containsKey('table_id') ||
                            state.uri.queryParameters['table_id'] == null ||
                            state.uri.queryParameters['table_id']!.isEmpty) {
                          return const Scaffold(body: Center(child: Text('Table was not found')));
                        } else {
                          return SalesModeProductsScreen(
                            tableId: state.uri.queryParameters['table_id'] as String,
                          );
                        }
                      },
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/settings',
                      builder: (context, state) => const SalesModeSettingsScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutesName.cashier,
          builder: (context, state) =>
              CashierPage(cashierId: state.pathParameters['cashierId'] as String),
        ),
        GoRoute(
          path: AppRoutesName.tables,
          builder: (context, state) => const TablesWidget(),
          routes: [
            GoRoute(
              path: AppRoutesName.creation,
              builder: (context, state) =>
                  TableCreationWidget(tableId: state.uri.queryParameters['tableId']),
            ),
          ],
        ),

        GoRoute(
          path: AppRoutesName.categories,
          builder: (context, state) => const CategoriesWidget(),
          routes: [
            GoRoute(
              path: AppRoutesName.creation,
              builder: (context, state) =>
                  CategoryCreationConfigWidget(categoryId: state.uri.queryParameters['categoryId']),
            ),
          ],
        ),

        GoRoute(
          path: AppRoutesName.products,
          builder: (context, state) => const ProductsWidget(),
          routes: [
            GoRoute(
              path: AppRoutesName.creation,
              builder: (context, state) =>
                  ProductCreationConfigWidget(productsId: state.uri.queryParameters['productId']),
            ),
          ],
        ),
      ],
    );
  }
}

final class _LocalNavigatorLoggerObserver extends NavigatorObserver {
  _LocalNavigatorLoggerObserver(this._logger);

  final Logger _logger;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logger.log(Level.info, 'User pushed to: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logger.log(Level.info, 'User popped from: ${route.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _logger.log(Level.info, 'User removed: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logger.log(
      Level.info,
      'User replaced old ${oldRoute?.settings.name} with new ${newRoute?.settings.name}',
    );
  }

  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    super.didChangeTop(topRoute, previousTopRoute);
    _logger.log(Level.info, 'User changed: $topRoute');
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    _logger.log(Level.info, 'User started gesture: ${route.settings.name}');
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    _logger.log(Level.info, 'User stopped gesture');
  }
}
