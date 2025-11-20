import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/circular_progress_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/error_button_widget.dart';
import 'package:test_pos_app/src/common/uikit/main_app_bar.dart';
import 'package:test_pos_app/src/common/uikit/main_app_drawer.dart';
import 'package:test_pos_app/src/common/uikit/refresh_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/text_widget.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';

import 'package:test_pos_app/src/features/authentication/widgets/authentication_listener.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/synchronization/widgets/synchronization_listener.dart';
import 'package:test_pos_app/src/features/tables/bloc/tables_bloc.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';

class TablesWidget extends StatefulWidget {
  const TablesWidget({super.key});

  @override
  State<TablesWidget> createState() => _TablesWidgetState();
}

class _TablesWidgetState extends State<TablesWidget> {
  late final TablesBloc _tablesBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context);
    _tablesBloc = dependencies.tablesBloc;

    _tablesBloc.add(const TablesEvent.refresh());
  }

  @override
  Widget build(BuildContext context) => AuthenticationListener(
      child: (context) => SynchronizationListener(
        child: (context) => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, kToolbarHeight),
            child: const MainAppBar(label: Constants.tables),
          ),
          drawer: const MainAppDrawer(),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              context.go(AppRoutesName.tables + AppRoutesName.creation);
            },
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation: WindowSizeScope.of(context).maybeMap(
            orElse: () => FloatingActionButtonLocation.centerFloat,
            compact: () => FloatingActionButtonLocation.endFloat,
          ),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: Constants.appGradientColor,
              ),
            ),
            child: SafeArea(
              child: RefreshIndicatorWidget(
                onRefresh: () async => _tablesBloc.add(const TablesEvent.refresh()),
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                    BlocBuilder<TablesBloc, TablesState>(
                      bloc: _tablesBloc,
                      builder: (context, state) => WindowSizeScope.of(context).maybeMap(
                          orElse: () => SliverFillRemaining(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                width: WindowSizeScope.of(context).expandedSize,
                                child: _buildContent(state: state, gridCount: 3),
                              ),
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  Widget _buildContent({required final TablesState state, required final int gridCount}) {
    switch (state) {
      case Tables$InitialState():
        return const SizedBox.shrink();
      case Tables$InProgressState():
        return const CircularProgressIndicatorWidget();
      case Tables$ErrorState():
        return Center(
          child: ErrorButtonWidget(
            label: Constants.reloadLabel,
            onTap: () {
              _tablesBloc.add(const TablesEvent.refresh());
            },
          ),
        );
      case Tables$CompletedState():
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCount, // 4 items per row
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              mainAxisExtent: 150,
            ),
            itemCount: state.tables.length,
            itemBuilder: (context, index) {
              final table = state.tables[index];
              return _TableWidget(table: table);
            },
          ),
        );
    }
  }
}

class _TableWidget extends StatefulWidget {
  const _TableWidget({required this.table});

  final TableModel table;

  @override
  State<_TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<_TableWidget> {
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () async {
        final path = '${AppRoutesName.tables}${AppRoutesName.creation}?tableId=${widget.table.id}';
        context.go(path);
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(10),
            color: widget.table.color ?? Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('test'),
              SizedBox(
                height: 60,
                child: widget.table.imageData != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        child: Image.memory(widget.table.imageData!, height: 60, fit: BoxFit.cover),
                      )
                    : widget.table.icon ?? const Icon(Icons.table_chart, size: 40),
              ),
              const SizedBox(height: 8),
              TextWidget(
                text: widget.table.name ?? 'Unnamed Table',
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
                maxLines: 1,
              ),
              if (widget.table.vip == true)
                const TextWidget(
                  text: 'VIP Table',
                  color: Colors.red,
                  size: 12,
                  fontWeight: FontWeight.bold,
                ),
            ],
          ),
        ),
      ),
    );
}
