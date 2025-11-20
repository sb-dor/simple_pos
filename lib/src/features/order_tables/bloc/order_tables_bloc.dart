import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/order_tables/data/order_tables_repository.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';

part 'order_tables_bloc.freezed.dart';

@freezed
sealed class OrderTablesEvent with _$OrderTablesEvent {
  const factory OrderTablesEvent.refresh() = _OrderTables$RefreshEvent;
}

@freezed
sealed class OrderTablesState with _$OrderTablesState {
  const factory OrderTablesState.initial(final List<TableModel> tables) = OrderTables$InitialState;

  const factory OrderTablesState.inProgress(final List<TableModel> tables) =
      OrderTables$InProgressState;

  const factory OrderTablesState.error(final List<TableModel> tables) = OrderTables$ErrorState;

  const factory OrderTablesState.completed(final List<TableModel> tables) =
      OrderTables$CompletedState;

  static OrderTablesState get initialState => const OrderTablesState.initial(<TableModel>[]);
}

class OrderTablesBloc extends Bloc<OrderTablesEvent, OrderTablesState> {
  OrderTablesBloc({
    required final IOrderTablesRepository repository,
    OrderTablesState? initialState,
  }) : _iOrderTablesRepository = repository,
       super(initialState ?? OrderTablesState.initialState) {
    //
    on<OrderTablesEvent>(
      (event, emit) => switch (event) {
        final _OrderTables$RefreshEvent event => _orderTables$RefreshEvent(event, emit),
      },
    );
  }

  final IOrderTablesRepository _iOrderTablesRepository;

  Future<void> _orderTables$RefreshEvent(
    _OrderTables$RefreshEvent event,
    Emitter<OrderTablesState> emit,
  ) async {
    try {
      emit(OrderTablesState.inProgress(state.tables));

      final tables = await _iOrderTablesRepository.tables();

      emit(OrderTablesState.completed(tables));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(OrderTablesState.error(state.tables));
    }
  }
}
