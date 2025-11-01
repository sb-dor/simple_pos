import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/common/global_data/global_data.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/app_bar_back.dart';
import 'package:test_pos_app/src/common/uikit/text_widget.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/authentication/widgets/authentication_listener.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/synchronization/widgets/synchronization_listener.dart';
import 'package:test_pos_app/src/features/tables/bloc/tables_bloc.dart';

class SalesModeScreen extends StatefulWidget {
  const SalesModeScreen({
    super.key,
    required this.statefulNavigationShell,
    required this.goRouterState,
  });

  final StatefulNavigationShell statefulNavigationShell;
  final GoRouterState goRouterState;

  @override
  State<SalesModeScreen> createState() => _SalesModeScreenState();
}

class _SalesModeScreenState extends State<SalesModeScreen> with SingleTickerProviderStateMixin {
  late List<Tab> _tabs;
  late final TabController _tabController;
  StreamSubscription<TablesState>? _tablesState;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context, listen: false);
    _tabs = [
      Tab(text: "${Constants.products} (${GlobalData.products.length})"),
      const Tab(text: Constants.settings),
    ];
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.animateTo(widget.statefulNavigationShell.currentIndex);

    // right after user puts query to the query field in the browser
    // we check whether user put correct table_id
    // if it's not right
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tablesBloc = dependencies.tablesBloc;
      if (tablesBloc.state is Tables$CompletedState) {
        _handleStateChange(tablesBloc.state as Tables$CompletedState);
      } else {
        _tablesState = tablesBloc.stream.listen((state) {
          if (state is Tables$CompletedState) {
            _handleStateChange(state);
          }
        });
      }
    });
  }

  void _handleStateChange(Tables$CompletedState state) {
    if (widget.goRouterState.uri.queryParameters.containsKey('table_id') &&
        widget.goRouterState.uri.queryParameters['table_id'] != null &&
        widget.goRouterState.uri.queryParameters['table_id']!.isNotEmpty) {
      final tableId = widget.goRouterState.uri.queryParameters['table_id'] as String;
      if (!state.tables.any((table) => table.id == tableId)) {
        Router.neglect(context, () => context.go(AppRoutesName.orderTables));
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tablesState?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTabIndex = widget.statefulNavigationShell.currentIndex;
    return AuthenticationListener(
      child: (context) => SynchronizationListener(
        child: (context) => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, kToolbarHeight),
            child: AppBarBack(label: Constants.salesMode),
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(gradient: LinearGradient(colors: Constants.appGradientColor)),
            child: SafeArea(
              child: Center(
                child: SizedBox(
                  width: WindowSizeScope.of(context).expandedSize,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      currentTabIndex == 0 ? Colors.amber : null,
                                    ),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    widget.statefulNavigationShell.goBranch(0);
                                  },
                                  child: TextWidget(
                                    text: "Товары",
                                    color: currentTabIndex == 0 ? Colors.white : null,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      currentTabIndex == 1 ? Colors.amber : null,
                                    ),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    widget.statefulNavigationShell.goBranch(1);
                                  },
                                  child: TextWidget(
                                    text: "Настройки",
                                    color: currentTabIndex == 1 ? Colors.white : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: widget.statefulNavigationShell),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
