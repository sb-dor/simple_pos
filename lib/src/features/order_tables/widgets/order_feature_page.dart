import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/circular_progress_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/error_button_widget.dart';
import 'package:test_pos_app/src/common/uikit/main_app_bar.dart';
import 'package:test_pos_app/src/common/uikit/main_app_drawer.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/features/authentication/widgets/authentication_listener.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/order_tables/bloc/order_tables_bloc.dart';
import 'package:test_pos_app/src/features/order_tables/widgets/widgets/place_widget.dart';
import 'package:test_pos_app/src/features/order_tables/widgets/widgets/vip_place_widget.dart';
import 'package:test_pos_app/src/features/synchronization/bloc/synchronization_bloc.dart';
import 'package:test_pos_app/src/features/synchronization/widgets/synchronization_listener.dart';

class OrderFeaturePage extends StatefulWidget {
  const OrderFeaturePage({super.key});

  @override
  State<OrderFeaturePage> createState() => _OrderFeaturePageState();
}

class _OrderFeaturePageState extends State<OrderFeaturePage> {
  late final OrderTablesBloc _orderTablesBloc;
  late final SynchronizationBloc _synchronizationBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context);
    _orderTablesBloc = dependencies.orderTablesBloc;
    _synchronizationBloc = dependencies.synchronizationBloc;

    _synchronizationBloc.add(
      SynchronizationEvent.sync(onSyncDone: () => _orderTablesBloc.add(OrderTablesEvent.refresh())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationListener(
      child: (context) => SynchronizationListener(
        child: (context) => Scaffold(
          drawer: const MainAppDrawer(),
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, kToolbarHeight),
            child: MainAppBar(label: "Simple POS"),
          ),
          body: SafeArea(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: Constants.appGradientColor,
                ),
              ),
              child: BlocBuilder<OrderTablesBloc, OrderTablesState>(
                bloc: _orderTablesBloc,
                builder: (context, state) {
                  return WindowSizeScope.of(context).maybeMap(
                    compact: () => _buildContent(context, state, crossAxisCount: 1),
                    medium: () => _buildContent(context, state, crossAxisCount: 2),
                    orElse: () => Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: WindowSizeScope.of(context).expandedSize,
                        child: _buildContent(context, state, crossAxisCount: 3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    OrderTablesState state, {
    required int crossAxisCount,
  }) {
    return switch (state) {
      OrderTables$InitialState() => const SizedBox.shrink(),
      OrderTables$InProgressState() => const Center(child: CircularProgressIndicatorWidget()),
      OrderTables$ErrorState() => Center(
        child: ErrorButtonWidget(
          label: Constants.reloadLabel,
          onTap: () => context.read<OrderTablesBloc>().add(OrderTablesEvent.refresh()),
        ),
      ),
      OrderTables$CompletedState() =>
        state.tables.isEmpty
            ? const Center(child: Text("No tables"))
            : _BuildGrid(state: state, crossAxisCount: crossAxisCount),
    };
  }
}

class _BuildGrid extends StatefulWidget {
  const _BuildGrid({required this.state, required this.crossAxisCount});

  final OrderTables$CompletedState state;
  final int crossAxisCount;

  @override
  State<_BuildGrid> createState() => _BuildGridState();
}

class _BuildGridState extends State<_BuildGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: ValueKey(widget.state.tables.length),
      padding: const EdgeInsets.all(10),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisExtent: 120,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: widget.state.tables.length,
      itemBuilder: (context, index) {
        final table = widget.state.tables[index];
        return Hero(
          tag: "table_${table.id}",
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: table.vip == true ? VipPlaceWidget(table: table) : PlaceWidget(table: table),
          ),
        );
      },
    );
  }
}
