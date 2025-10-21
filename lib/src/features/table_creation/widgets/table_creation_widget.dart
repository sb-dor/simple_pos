import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/app_bar_back.dart';
import 'package:test_pos_app/src/common/uikit/circular_progress_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/error_button_widget.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/table_creation_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/table_creation/bloc/table_creation_bloc.dart';
import 'package:test_pos_app/src/features/table_creation/widgets/controller/table_creation_change_notifier_controller.dart';

class TableCreationWidget extends StatefulWidget {
  const TableCreationWidget({super.key, required this.tableId});

  final String? tableId;

  @override
  State<TableCreationWidget> createState() => _TableCreationWidgetState();
}

class _TableCreationWidgetState extends State<TableCreationWidget> {
  late final TableCreationBloc _tableCreationBloc;
  late final AuthenticationBloc _authenticationBloc;
  late final TableCreationChangeNotifierController _tableCreationChangeNotifierController;
  late final StreamSubscription<TableCreationState> _tableCreationStates;
  final TextEditingController _nameController = TextEditingController();

  // void _submit() {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //     final table = TableModel(
  //       name: _name,
  //       vip: _isVip,
  //       color: _selectedColor,
  //       imageData: _imageData,
  //       datetime: DateTime.now(),
  //     );
  //     // Process the table model (e.g., save it or send it to a backend)
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Table Created: ${table.name}")));
  //   }
  // }

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context, listen: false);
    _tableCreationBloc = TableCreationBlocFactory(
      appDatabase: dependencies.appDatabase,
      logger: dependencies.logger,
    ).create();
    _authenticationBloc = dependencies.authenticationBloc;
    _tableCreationBloc.add(TableCreationEvent.init(tableId: widget.tableId));
    _tableCreationChangeNotifierController = TableCreationChangeNotifierController(
      textController: _nameController,
    );
    _tableCreationStates = _tableCreationBloc.stream.listen((state) {
      if (state is TableCreation$CompletedState) _stateListener(state);
    });
  }

  @override
  void dispose() {
    _tableCreationStates.cancel();
    _nameController.dispose();
    _tableCreationChangeNotifierController.dispose();
    _tableCreationBloc.close();
    super.dispose();
  }

  void _stateListener(TableCreation$CompletedState state) {
    if (state.tableModel != null && mounted) {
      _tableCreationChangeNotifierController.init(state.tableModel!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, kToolbarHeight),
        child: AppBarBack(label: Constants.tableCreation),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.mainAppColor,
        onPressed: () {
          if (!_tableCreationChangeNotifierController.isValidate) return;
          final establishment = _authenticationBloc.state.stateModel.establishment;
          if (establishment == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No establishment")));
            return;
          }
          _tableCreationBloc.add(
            TableCreationEvent.save(
              tableData: _tableCreationChangeNotifierController.tableModelDataChange,
              establishment: establishment,
              onSave: () {
                if (!mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Table Created: ${_nameController.text}")));
                Navigator.pop(context);
              },
            ),
          );
        },
        child: Icon(Icons.save),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(gradient: LinearGradient(colors: Constants.appGradientColor)),
        child: SafeArea(
          child: Center(
            child: SizedBox(
              width: WindowSizeScope.of(context).expandedSize,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: BlocBuilder<TableCreationBloc, TableCreationState>(
                    bloc: _tableCreationBloc,
                    builder: (context, state) {
                      switch (state) {
                        case TableCreation$InitialState():
                          return SizedBox.shrink();
                        case TableCreation$InProgressState():
                          return CircularProgressIndicatorWidget();
                        case TableCreation$ErrorState():
                          return ErrorButtonWidget(
                            label: Constants.reloadLabel,
                            onTap: () {
                              _tableCreationBloc.add(
                                TableCreationEvent.init(tableId: widget.tableId),
                              );
                            },
                          );
                        case TableCreation$CompletedState():
                          return ListenableBuilder(
                            listenable: _tableCreationChangeNotifierController,
                            builder: (context, child) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        labelText: "Table Name",
                                        errorText: _tableCreationChangeNotifierController.error,
                                      ),
                                    ),
                                  ),
                                  SwitchListTile(
                                    title: Text("VIP Table"),
                                    value: _tableCreationChangeNotifierController
                                        .tableModelDataChange
                                        .isVip,
                                    onChanged: (value) {
                                      _tableCreationChangeNotifierController.changeVIP();
                                    },
                                  ),
                                  ListTile(
                                    title: Text("Pick Table Color"),
                                    trailing: CircleAvatar(
                                      backgroundColor: _tableCreationChangeNotifierController
                                          .tableModelDataChange
                                          .selectedColor,
                                    ),
                                    onTap: () {
                                      _tableCreationChangeNotifierController.pickColor(context);
                                    },
                                  ),
                                  if (_tableCreationChangeNotifierController
                                          .tableModelDataChange
                                          .imageData !=
                                      null)
                                    ElevatedButton(
                                      onPressed: _tableCreationChangeNotifierController.deleteImage,
                                      child: Text("Delete Image"),
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: _tableCreationChangeNotifierController.pickImage,
                                      child: Text("Pick Image"),
                                    ),
                                  _tableCreationChangeNotifierController
                                              .tableModelDataChange
                                              .imageData !=
                                          null
                                      ? SizedBox(
                                          height: 200,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 10),
                                            child: kIsWeb
                                                ? Image.network(
                                                    _tableCreationChangeNotifierController
                                                        .tableModelDataChange
                                                        .imageData!
                                                        .path,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.file(
                                                    File(
                                                      _tableCreationChangeNotifierController
                                                          .tableModelDataChange
                                                          .imageData!
                                                          .path,
                                                    ),
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  SizedBox(height: 20),
                                ],
                              );
                            },
                          );
                      }
                    },
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
