import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/common/utils/paginate_list_helper.dart';
import 'package:test_pos_app/src/features/cashier_feature/data/cashier_feature_repo.dart';
import 'package:test_pos_app/src/features/cashier_feature/models/cashier_feature_state_model.dart';
import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_model.dart';

part 'cashier_feature_bloc.freezed.dart';

@freezed
sealed class CashierFeatureEvents with _$CashierFeatureEvents {
  const factory CashierFeatureEvents.initial() = _Cashier$InitialEvent;

  const factory CashierFeatureEvents.paginate() = _Cashier$PaginateInvoiceEvent;
}

@freezed
sealed class CashierFeatureStates with _$CashierFeatureStates {
  const factory CashierFeatureStates.initial(
    final CashierFeatureStateModel cashierFeatureStateModel,
  ) = Cashier$InititalState;

  const factory CashierFeatureStates.inProgress(
    final CashierFeatureStateModel cashierFeatureStateModel,
  ) = Cashier$InProgressState;

  const factory CashierFeatureStates.error(
    final CashierFeatureStateModel cashierFeatureStateModel,
  ) = Cashier$ErrorState;

  const factory CashierFeatureStates.completed(
    final CashierFeatureStateModel cashierFeatureStateModel,
  ) = Cashier$CompletedState;

  static CashierFeatureStates get initialState =>
      CashierFeatureStates.initial(CashierFeatureStateModel.initial());
}

class CashierFeatureBloc extends Bloc<CashierFeatureEvents, CashierFeatureStates> {
  CashierFeatureBloc({
    required final ICashierFeatureRepo repository,
    required final PaginateListHelper paginateListHelper,
    CashierFeatureStates? initialState,
  }) : _iCashierFeatureRepo = repository,
       _paginateListHelper = paginateListHelper,
       super(initialState ?? CashierFeatureStates.initialState) {
    //
    on<CashierFeatureEvents>(
      (event, emit) => switch (event) {
        final _Cashier$InitialEvent event => _cashier$InitialEvent(event, emit),
        final _Cashier$PaginateInvoiceEvent event => _cashier$PaginateInvoiceEvent(event, emit),
      },
    );
  }

  final ICashierFeatureRepo _iCashierFeatureRepo;
  final PaginateListHelper _paginateListHelper;

  Future<void> _cashier$InitialEvent(
    _Cashier$InitialEvent event,
    Emitter<CashierFeatureStates> emit,
  ) async {
    try {
      emit(CashierFeatureStates.inProgress(state.cashierFeatureStateModel));
      final invoices = await _iCashierFeatureRepo.invoices();
      final currentStateModel = state.cashierFeatureStateModel.copyWith(
        hasMore: _paginateListHelper.checkHasMoreList(
          wholeList: invoices,
          currentList: <CustomerInvoiceModel>[],
        ),
        invoices: _paginateListHelper.paginateList(
          wholeList: invoices,
          currentList: <CustomerInvoiceModel>[],
        ),
        allCustomerInvoices: invoices,
      );
      emit(CashierFeatureStates.completed(currentStateModel));
    } on Object {
      emit(CashierFeatureStates.error(state.cashierFeatureStateModel));
      rethrow;
    }
  }

  Future<void> _cashier$PaginateInvoiceEvent(
    _Cashier$PaginateInvoiceEvent event,
    Emitter<CashierFeatureStates> emit,
  ) async {
    if (state is! Cashier$CompletedState) return;
    if (!state.cashierFeatureStateModel.hasMore) return;

    final paginatingList = List.of(state.cashierFeatureStateModel.invoices);

    paginatingList.addAll(
      _paginateListHelper.paginateList<CustomerInvoiceModel>(
        wholeList: state.cashierFeatureStateModel.allCustomerInvoices,
        currentList: paginatingList,
      ),
    );

    final hasMore = _paginateListHelper.checkHasMoreList(
      wholeList: state.cashierFeatureStateModel.allCustomerInvoices,
      currentList: paginatingList,
    );

    final currentStateModel = state.cashierFeatureStateModel.copyWith(
      hasMore: hasMore,
      invoices: paginatingList,
    );

    emit(CashierFeatureStates.completed(currentStateModel));
  }
}
