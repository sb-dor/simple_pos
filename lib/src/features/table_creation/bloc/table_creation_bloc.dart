import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/authentication/models/establishment.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';
import 'package:test_pos_app/src/features/table_creation/data/table_creation_repository.dart';
import 'package:test_pos_app/src/features/table_creation/widgets/controller/table_creation_change_notifier_controller.dart';
import 'package:uuid/uuid.dart';

part 'table_creation_bloc.freezed.dart';

@freezed
sealed class TableCreationEvent with _$TableCreationEvent {
  const factory TableCreationEvent.init({@Default(null) String? tableId}) =
      _TableCreation$RefreshEvent;

  const factory TableCreationEvent.save({
    required final TableModelDataChange tableData,
    required final Establishment establishment,
    required final void Function() onSave,
  }) = _TableCreation$SaveEvent;
}

@freezed
sealed class TableCreationState with _$TableCreationState {
  const factory TableCreationState.initial({@Default(null) final TableModel? tableModel}) =
      TableCreation$InitialState;

  const factory TableCreationState.inProgress({@Default(null) final TableModel? tableModel}) =
      TableCreation$InProgressState;

  const factory TableCreationState.error({@Default(null) final TableModel? tableModel}) =
      TableCreation$ErrorState;

  const factory TableCreationState.completed({@Default(null) final TableModel? tableModel}) =
      TableCreation$CompletedState;
}

class TableCreationBloc extends Bloc<TableCreationEvent, TableCreationState> {
  TableCreationBloc({required final ITableCreationRepository repository})
    : _iTableCreationRepository = repository,
      super(const TableCreationState.initial()) {
    //
    on<TableCreationEvent>(
      (event, emit) => switch (event) {
        final _TableCreation$RefreshEvent event => _tableCreation$RefreshEvent(event, emit),
        final _TableCreation$SaveEvent event => _tableCreation$SaveEvent(event, emit),
      },
    );
  }

  final ITableCreationRepository _iTableCreationRepository;

  void _tableCreation$RefreshEvent(
    _TableCreation$RefreshEvent event,
    Emitter<TableCreationState> emit,
  ) async {
    emit(TableCreationState.inProgress());

    TableModel? table;

    if (event.tableId != null) {
      table = await _iTableCreationRepository.table(event.tableId!);
    }
    print("table getting: $table | ${event.tableId}");

    emit(TableCreationState.completed(tableModel: table));
  }

  void _tableCreation$SaveEvent(
    _TableCreation$SaveEvent event,
    Emitter<TableCreationState> emit,
  ) async {
    var table = state.tableModel ?? TableModel();

    final datetime = DateTime.now();

    final bytes = await event.tableData.imageData?.readAsBytes();

    table = table.copyWith(
      id: table.id ?? Uuid().v4(),
      establishmentId: event.establishment.id,
      name: event.tableData.name,
      vip: event.tableData.isVip,
      updatedAt: datetime,
      imageData: () => bytes,
      color: event.tableData.selectedColor,
    );

    final save = await _iTableCreationRepository.save(table);

    if (save) event.onSave();
  }
}
