import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/product_creation/data/product_creation_repository.dart';
import 'package:test_pos_app/src/features/product_creation/models/product_creation_data.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';
import 'package:uuid/uuid.dart';

part 'product_creation_bloc.freezed.dart';

/// Represents the events that can be dispatched to the [ProductCreationBloc].
@freezed
sealed class ProductCreationEvent with _$ProductCreationEvent {
  /// Initializes the bloc with a product ID, typically for editing an existing product.
  const factory ProductCreationEvent.init({@Default(null) String? productId}) =
      _ProductCreation$InitEvent;

  /// Saves the product creation data.
  const factory ProductCreationEvent.save({
    required final ProductCreationData productCreationData,
    required final void Function() onSave,
  }) = _ProductCreation$SaveEvent;
}

/// Represents the different states of the product creation process.
@freezed
sealed class ProductCreationState with _$ProductCreationState {
  /// The initial state of the bloc, optionally holding a product.
  const factory ProductCreationState.initial(final ProductModel? product) =
      ProductCreation$InitialState;

  /// The state indicating that a product creation or update is in progress.
  const factory ProductCreationState.inProgress(final ProductModel? product) =
      ProductCreation$InProgressState;

  /// The state indicating that an error has occurred.
  const factory ProductCreationState.error(final ProductModel? product) =
      ProductCreation$ErrorState;

  /// The state indicating that the product has been successfully saved.
  const factory ProductCreationState.completed(final ProductModel? product) =
      ProductCreation$CompletedState;

  /// The initial state of the product creation screen.
  static ProductCreationState get initialState => const ProductCreationState.initial(null);
}

/// Manages the state and logic for creating and editing products.
class ProductCreationBloc extends Bloc<ProductCreationEvent, ProductCreationState> {
  //
  /// {@macro product_creation_bloc}
  ProductCreationBloc({
    required final IProductCreationRepository productCreationRepository,
    final ProductCreationState? initialState,
  }) : _productCreationRepository = productCreationRepository,
       super(initialState ?? ProductCreationState.initialState) {
    //
    // Register the event handlers.
    on<ProductCreationEvent>(
      (event, emit) => switch (event) {
        final _ProductCreation$InitEvent event => _productCreation$InitEvent(event, emit),
        final _ProductCreation$SaveEvent event => _productCreation$SaveEvent(event, emit),
      },
    );
  }

  /// The repository for product creation data operations.
  final IProductCreationRepository _productCreationRepository;

  /// Handles the [_ProductCreation$InitEvent] by fetching a product from the repository.
  Future<void> _productCreation$InitEvent(
    _ProductCreation$InitEvent event,
    Emitter<ProductCreationState> emit,
  ) async {
    try {
      final product = await _productCreationRepository.product(event.productId);
      emit(ProductCreationState.initial(product));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  /// Handles the [_ProductCreation$SaveEvent] by saving the product data.
  Future<void> _productCreation$SaveEvent(
    _ProductCreation$SaveEvent event,
    Emitter<ProductCreationState> emit,
  ) async {
    try {
      emit(ProductCreationState.inProgress(state.product));

      final product = (state.product ?? const ProductModel()).copyWith(
        id: state.product?.id ?? const Uuid().v4(),
        name: () => event.productCreationData.name,
        price: () => event.productCreationData.price,
        wholesalePrice: () => event.productCreationData.wholesalePrice,
        packQty: () => event.productCreationData.packQty,
        productType: event.productCreationData.productType,
        barcode: () => event.productCreationData.barcode,
        changed: true,
        visible: event.productCreationData.visible,
        imageData: () => event.productCreationData.image,
      );

      final save = await _productCreationRepository.save(product);

      if (save) {
        emit(ProductCreationState.completed(product));
        event.onSave();
      } else {
        emit(ProductCreationState.error(state.product));
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(ProductCreationState.error(state.product));
    }
  }
}
