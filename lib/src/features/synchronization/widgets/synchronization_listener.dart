import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/synchronization/bloc/synchronization_bloc.dart';
import 'package:test_pos_app/src/features/tables/bloc/tables_bloc.dart';

import 'synchronization_popup.dart';

class SynchronizationListener extends StatefulWidget {
  const SynchronizationListener({super.key, required this.child});

  final WidgetBuilder child;

  @override
  State<SynchronizationListener> createState() => _SynchronizationListenerState();
}

class _SynchronizationListenerState extends State<SynchronizationListener> {
  late final TablesBloc _tablesBloc;
  late final SynchronizationBloc _synchronizationBloc;
  bool _showingSyncLoading = false;

  void _closePopup() {
    if (_showingSyncLoading) {
      Navigator.pop(context);
      _showingSyncLoading = false;
    }
  }

  void _showPopup() {
    if (!_showingSyncLoading) {
      _showingSyncLoading = true;
      showDialog(context: context, builder: (context) => SynchronizationPopup());
    }
  }

  void _loadLocalData() {
    _tablesBloc.add(TablesEvent.refresh());
  }

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context, listen: false);
    _tablesBloc = dependencies.tablesBloc;
    _synchronizationBloc = dependencies.synchronizationBloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SynchronizationBloc, SynchronizationState>(
      bloc: _synchronizationBloc,
      listener: (context, synchronizationState) {
        switch (synchronizationState) {
          case Synchronization$InitialState():
            _closePopup();
            break;
          case Synchronization$ErrorState():
            _closePopup();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  synchronizationState.message ?? "Something went wrong with synchronization",
                ),
              ),
            );
            break;
          case Synchronization$InProgressState():
            _showPopup();
            break;
          case Synchronization$CompletedState():
            _closePopup();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Synchronization completed!!!"),
                backgroundColor: Colors.green,
              ),
            );
            _loadLocalData();
            break;
        }
      },
      child: widget.child(context),
    );
  }
}
