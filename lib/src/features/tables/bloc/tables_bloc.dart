import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';
import 'package:test_pos_app/src/features/tables/data/tables_repository.dart';

part 'tables_bloc.freezed.dart';

@freezed
sealed class TablesEvent with _$TablesEvent {
  const factory TablesEvent.refresh() = _Tables$RefreshEvent;

  const factory TablesEvent.paginate() = _Tables$PaginateEvent;

  const factory TablesEvent.clear() = _Tables$ClearEvent;
}

@freezed
sealed class TablesState with _$TablesState {
  const factory TablesState.initial(final List<TableModel> tables) = Tables$InitialState;

  const factory TablesState.inProgress(final List<TableModel> tables) = Tables$InProgressState;

  const factory TablesState.error(final List<TableModel> tables) = Tables$ErrorState;

  const factory TablesState.completed(final List<TableModel> tables) = Tables$CompletedState;

  static TablesState get initialState => TablesState.initial(<TableModel>[]);
}

class TablesBloc extends Bloc<TablesEvent, TablesState> {
  TablesBloc({required final ITablesRepository repository, TablesState? initialState})
    : _iTablesRepository = repository,
      super(initialState ?? TablesState.initialState) {
    //
    on<TablesEvent>(
      (event, emit) => switch (event) {
        final _Tables$RefreshEvent event => _tables$RefreshEvent(event, emit),
        final _Tables$PaginateEvent event => _tables$PaginateEvent(event, emit),
        final _Tables$ClearEvent event => _tables$ClearEvent(event, emit),
      },
    );
  }

  final ITablesRepository _iTablesRepository;

  void _tables$RefreshEvent(_Tables$RefreshEvent event, Emitter<TablesState> emit) async {
    try {
      emit(TablesState.inProgress(<TableModel>[]));
      final tables = await _iTablesRepository.tables();
      emit(TablesState.completed(tables));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(TablesState.error(<TableModel>[]));
    }
  }

  void _tables$PaginateEvent(_Tables$PaginateEvent event, Emitter<TablesState> emit) async {
    //
  }

  void _tables$ClearEvent(_Tables$ClearEvent event, Emitter<TablesState> emit) async {
    try {
      emit(TablesState.initial(<TableModel>[]));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(TablesState.error(<TableModel>[]));
    }
  }
}
