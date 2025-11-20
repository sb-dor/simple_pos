import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';
import 'package:test_pos_app/src/features/order_feature/data/order_feature_repo.dart';
import 'package:test_pos_app/src/features/order_feature/models/order_feature_state_model.dart';
import 'package:test_pos_app/src/features/order_feature/models/order_item_model.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';

part 'order_feature_bloc.freezed.dart';

@freezed
sealed class OrderFeatureEvents with _$OrderFeatureEvents {
  const OrderFeatureEvents._();

  const factory OrderFeatureEvents.init() = _OrderFeature$InitialEvent;

  const factory OrderFeatureEvents.addPlaceEvent(String tableId) = _OrderFeature$AddPlaceEvent;

  const factory OrderFeatureEvents.selectCategoryEvent(final CategoryModel category) =
      _OrderFeature$SelectCategoryEvent;

  const factory OrderFeatureEvents.addProductToOrderEvent(final ProductModel? product) =
      _OrderFeature$AddProductToOrderEvent;

  const factory OrderFeatureEvents.decrementOrderItemQtyEvent(final ProductModel? product) =
      _OrderFeature$DecrementOrderItemQtyEvent;

  const factory OrderFeatureEvents.addOrderItemForChange(final OrderItemModel orderItem) =
      _OrderFeature$AddOrderItemForChangeEvent;

  const factory OrderFeatureEvents.deleteOrderItemFromOrder() =
      _OrderFeature$DeleteOrderItemFromOrderEvent;

  const factory OrderFeatureEvents.finishCustomerInvoice({
    required final void Function(String message) onMessage,
  }) = _OrderFeature$FinishCustomerInvoiceEvent;
}

@freezed
sealed class OrderFeatureStates with _$OrderFeatureStates {
  const factory OrderFeatureStates.initial(final OrderFeatureStateModel orderFeatureStateModel) =
      InitialOrderState;

  const factory OrderFeatureStates.inProgress(final OrderFeatureStateModel orderFeatureStateModel) =
      InProgressOrderState;

  const factory OrderFeatureStates.error(final OrderFeatureStateModel orderFeatureStateModel) =
      ErrorOrderState;

  const factory OrderFeatureStates.completed(final OrderFeatureStateModel orderFeatureStateModel) =
      CompletedOrderState;

  static OrderFeatureStates get initialState =>
      OrderFeatureStates.initial(OrderFeatureStateModel.initial());
}

class OrderFeatureBloc extends Bloc<OrderFeatureEvents, OrderFeatureStates> {
  OrderFeatureBloc({required final IOrderFeatureRepo repository, OrderFeatureStates? initialState})
    : _iOrderFeatureRepo = repository,
      super(initialState ?? OrderFeatureStates.initialState) {
    //
    on<OrderFeatureEvents>(
      (event, emit) => switch (event) {
        final _OrderFeature$InitialEvent event => _orderFeature$InitialEvent(event, emit),
        final _OrderFeature$AddPlaceEvent event => _orderFeature$AddPlaceEvent(event, emit),
        final _OrderFeature$SelectCategoryEvent event => _orderFeature$SelectCategoryEvent(
          event,
          emit,
        ),
        final _OrderFeature$AddProductToOrderEvent event => _orderFeature$AddProductToOrderEvent(
          event,
          emit,
        ),
        final _OrderFeature$DecrementOrderItemQtyEvent event =>
          _orderFeature$DecrementOrderItemQtyEvent(event, emit),
        final _OrderFeature$AddOrderItemForChangeEvent event =>
          _orderFeature$AddOrderItemForChangeEvent(event, emit),
        final _OrderFeature$DeleteOrderItemFromOrderEvent event =>
          _orderFeature$DeleteOrderItemFromOrderEvent(event, emit),
        final _OrderFeature$FinishCustomerInvoiceEvent event =>
          _orderFeature$FinishCustomerInvoiceEvent(event, emit),
      },
    );
  }

  final IOrderFeatureRepo _iOrderFeatureRepo;

  Future<void> _orderFeature$InitialEvent(
    _OrderFeature$InitialEvent event,
    Emitter<OrderFeatureStates> emit,
  ) async {
    emit(OrderFeatureStates.inProgress(state.orderFeatureStateModel));

    await Future.delayed(const Duration(seconds: 3));

    emit(OrderFeatureStates.completed(state.orderFeatureStateModel));
  }

  Future<void> _orderFeature$AddPlaceEvent(
    _OrderFeature$AddPlaceEvent event,
    Emitter<OrderFeatureStates> emit,
  ) async {
    final table = await _iOrderFeatureRepo.table(event.tableId);
    var currentStateModel = state.orderFeatureStateModel.copyWith(table: table);
    final orderedItems = await _iOrderFeatureRepo.dbOrderItems(table);
    currentStateModel = currentStateModel.copyWith(orderItems: orderedItems);
    emit(OrderFeatureStates.completed(currentStateModel));
  }

  Future<void> _orderFeature$SelectCategoryEvent(
    _OrderFeature$SelectCategoryEvent event,
    Emitter<OrderFeatureStates> emit,
  ) async {
    final currentStateModel = state.orderFeatureStateModel.copyWith(
      category: event.category,
      productsForShow: await _iOrderFeatureRepo.categoriesProducts(event.category),
    );
    _emitter(currentStateModel, emit);
  }

  Future<void> _orderFeature$AddProductToOrderEvent(
    _OrderFeature$AddProductToOrderEvent event,
    Emitter<OrderFeatureStates> emit,
  ) async {
    var currentStateModel = state.orderFeatureStateModel;
    final orderItems = List<OrderItemModel>.from(state.orderFeatureStateModel.orderItems);
    var item = orderItems.firstWhereOrNull((e) => e.product?.id == event.product?.id);
    if (item == null) {
      item = OrderItemModel(product: event.product, price: event.product?.price, qty: 1);
      orderItems.add(item);
    } else {
      item.qty = (item.qty ?? 0) + 1;
      orderItems[orderItems.indexWhere((e) => e.product?.id == event.product?.id)] = item;
    }
    currentStateModel = currentStateModel.copyWith(orderItems: orderItems);
    await _iOrderFeatureRepo.addToDb(table: state.orderFeatureStateModel.table, item: item);
    _emitter(currentStateModel, emit);
  }

  Future<void> _orderFeature$DecrementOrderItemQtyEvent(
    _OrderFeature$DecrementOrderItemQtyEvent event,
    Emitter<OrderFeatureStates> emit,
  ) async {
    var currentStateModel = state.orderFeatureStateModel;
    final orderItems = List<OrderItemModel>.from(state.orderFeatureStateModel.orderItems);
    final item = orderItems.firstWhereOrNull((e) => e.product?.id == event.product?.id);
    if (item == null) return;
    item.qty = (item.qty ?? 0) - 1;
    if ((item.qty ?? 0.0) <= 0) {
      orderItems.removeWhere((e) => e.product?.id == event.product?.id);
    } else {
      orderItems[orderItems.indexWhere((e) => e.product?.id == event.product?.id)] = item;
    }
    currentStateModel = currentStateModel.copyWith(orderItems: orderItems);
    await _iOrderFeatureRepo.addToDb(table: state.orderFeatureStateModel.table, item: item);
    _emitter(currentStateModel, emit);
  }

  Future<void> _orderFeature$AddOrderItemForChangeEvent(
    _OrderFeature$AddOrderItemForChangeEvent event,
    Emitter<OrderFeatureStates> emit,
  ) async {
    final currentStateModel = state.orderFeatureStateModel.copyWith(
      orderItemForChange: event.orderItem,
    );
    _emitter(currentStateModel, emit);
  }

  Future<void> _orderFeature$DeleteOrderItemFromOrderEvent(
    _OrderFeature$DeleteOrderItemFromOrderEvent event,
    Emitter<OrderFeatureStates> emit,
  ) async {
    await _iOrderFeatureRepo.deleteOrderItemFromOrder(
      state.orderFeatureStateModel.orderItemForChange,
      state.orderFeatureStateModel.table,
    );
    var currentStateModel = state.orderFeatureStateModel.copyWith(
      orderItems: state.orderFeatureStateModel.orderItems
        ..removeWhere(
          (e) => e.product?.id == state.orderFeatureStateModel.orderItemForChange?.product?.id,
        ),
    );
    currentStateModel = currentStateModel.copyWith(orderItemForChange: null);
    _emitter(currentStateModel, emit);
  }

  Future<void> _orderFeature$FinishCustomerInvoiceEvent(
    _OrderFeature$FinishCustomerInvoiceEvent event,
    Emitter<OrderFeatureStates> emit,
  ) async {
    final result = await _iOrderFeatureRepo.finishInvoice(
      state.orderFeatureStateModel.table,
      state.orderFeatureStateModel.orderItems,
    );
    if (result) {
      final currentStateModel = state.orderFeatureStateModel.copyWith(
        orderItems: <OrderItemModel>[],
      );
      _emitter(currentStateModel, emit);
      event.onMessage('Order completed!');
    }
  }

  void _emitter(OrderFeatureStateModel stateModel, Emitter<OrderFeatureStates> emit) {
    switch (state) {
      case InitialOrderState():
        emit(OrderFeatureStates.initial(stateModel));
        break;
      case InProgressOrderState():
        emit(OrderFeatureStates.inProgress(stateModel));
        break;
      case ErrorOrderState():
        emit(OrderFeatureStates.error(stateModel));
        break;
      case CompletedOrderState():
        emit(OrderFeatureStates.completed(stateModel));
        break;
    }
  }
}
