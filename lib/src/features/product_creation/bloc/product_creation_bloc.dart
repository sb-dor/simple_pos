import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/product_creation/data/product_creation_repository.dart';
import 'package:test_pos_app/src/features/product_creation/widgets/controllers/product_creation_controller.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';

part 'product_creation_bloc.freezed.dart';

@freezed
sealed class ProductCreationEvent with _$ProductCreationEvent {
  const factory ProductCreationEvent.init({@Default(null) String? productId}) =
      _ProductCreation$InitEvent;

  const factory ProductCreationEvent.save({
    required final ProductCreationData productCreationData,
    required final void Function() onSave,
  }) = _ProductCreation$SaveEvent;
}

@freezed
sealed class ProductCreationState with _$ProductCreationState {
  const factory ProductCreationState.initial(final ProductModel? product) =
      ProductCreation$InitialState;

  const factory ProductCreationState.inProgress(final ProductModel? product) =
      ProductCreation$InProgressState;

  const factory ProductCreationState.error(final ProductModel? product) =
      ProductCreation$ErrorState;

  const factory ProductCreationState.completed(final ProductModel? product) =
      ProductCreation$CompletedState;

  static ProductCreationState get initialState => ProductCreationState.initial(null);
}

class ProductCreationBloc extends Bloc<ProductCreationEvent, ProductCreationState> {
  //
  ProductCreationBloc({
    required final IProductCreationRepository productCreationRepository,
    final ProductCreationState? initialState,
  }) : _productCreationRepository = productCreationRepository,
       super(initialState ?? ProductCreationState.initialState) {
    //
    on<ProductCreationEvent>(
      (event, emit) => switch (event) {
        final _ProductCreation$InitEvent event => _productCreation$InitEvent(event, emit),
        final _ProductCreation$SaveEvent event => _productCreation$SaveEvent(event, emit),
      },
    );
  }

  final IProductCreationRepository _productCreationRepository;

  void _productCreation$InitEvent(
    _ProductCreation$InitEvent event,
    Emitter<ProductCreationState> emit,
  ) async {
    try {} catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  void _productCreation$SaveEvent(
    _ProductCreation$SaveEvent event,
    Emitter<ProductCreationState> emit,
  ) async {
    try {} catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(ProductCreationState.error(state.product));
    }
  }
}
