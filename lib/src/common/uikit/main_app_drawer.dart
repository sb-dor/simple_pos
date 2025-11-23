import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/common/constants/constants.dart';
import 'package:test_pos_app/src/common/uikit/text_widget.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/synchronization/bloc/synchronization_bloc.dart';
import 'package:test_pos_app/src/features/tables/bloc/tables_bloc.dart';

class MainAppDrawer extends StatefulWidget {
  const MainAppDrawer({super.key});

  @override
  State<MainAppDrawer> createState() => _MainAppDrawerState();
}

class _MainAppDrawerState extends State<MainAppDrawer> {
  late final SynchronizationBloc _synchronizationBloc;
  late final AuthenticationBloc _authenticationBloc;
  late final TablesBloc _tablesBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context);
    _authenticationBloc = dependencies.authenticationBloc;
    _synchronizationBloc = dependencies.synchronizationBloc;
    _tablesBloc = dependencies.tablesBloc;
  }

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: appGradientColor),
      borderRadius: BorderRadius.circular(20),
    ),
    child: SafeArea(
      bottom: false,
      child: Drawer(
        child: ListView(
          children: [
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              bloc: _authenticationBloc,
              builder: (context, state) => SizedBox(
                height: 100,
                child: DrawerHeader(
                  margin: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: appGradientColor),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: state.stateModel.userModel?.name ?? '-',
                              size: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            TextWidget(
                              text: state.stateModel.userModel?.userRole?.name ?? '-',
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _synchronizationBloc.add(
                            SynchronizationEvent.sync(
                              refresh: true,
                              onSyncDone: () {
                                if (mounted) Navigator.pop(context);
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.sync, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text(cashier),
              onTap: () {
                Navigator.pop(context);
                // AutoRouter.of(context).replaceAll([const CashierRoute()]);
                context.go(AppRoutesName.cashier.replaceFirst(':cashierId', '1'));
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text(salesMode),
              onTap: () {
                Navigator.pop(context);
                // AutoRouter.of(context).replaceAll([const OrderFeatureRoute()]);
                context.go(AppRoutesName.orderTables);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_bar),
              title: const Text(tables),
              onTap: () {
                Navigator.pop(context);
                // AutoRouter.of(context).replaceAll([const OrderFeatureRoute()]);
                context.go(AppRoutesName.tables);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text(categories),
              onTap: () {
                Navigator.pop(context);
                // AutoRouter.of(context).replaceAll([const OrderFeatureRoute()]);
                context.go(AppRoutesName.categories);
              },
            ),
            ListTile(
              leading: const Icon(Icons.fastfood),
              title: const Text(products),
              onTap: () {
                Navigator.pop(context);
                // AutoRouter.of(context).replaceAll([const OrderFeatureRoute()]);
                context.go(AppRoutesName.products);
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: OutlinedButton(
                  onPressed: () {
                    _authenticationBloc.add(
                      AuthenticationEvent.logout(
                        onLogout: () {
                          _synchronizationBloc.add(
                            const SynchronizationEvent.changeStateToInitial(),
                          );
                          _tablesBloc.add(const TablesEvent.clear());
                        },
                      ),
                    );
                  },
                  child: const Text(logout),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
