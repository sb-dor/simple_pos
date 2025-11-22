import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';
import 'package:test_pos_app/src/features/products_of_category/data/products_of_category_repository.dart';

part 'products_of_category_bloc.freezed.dart';

@freezed
sealed class ProductsOfCategoryEvent with _$ProductsOfCategoryEvent {
  const factory ProductsOfCategoryEvent.load({required final String categoryId}) =
      _ProductsOfCategory$LoadEvent;

  const factory ProductsOfCategoryEvent.saveProducts(
    final String categoryId,
    final List<ProductModel> selectedProducts, {
    final void Function(String message)? onMessage,
  }) = _ProductsOfCategory$SaveProductsEvent;
}

@freezed
sealed class ProductsOfCategoryState with _$ProductsOfCategoryState {
  const factory ProductsOfCategoryState.initial() = ProductsOfCategory$InitialState;

  const factory ProductsOfCategoryState.inProgress() = ProductsOfCategory$InProgressState;

  const factory ProductsOfCategoryState.error() = ProductsOfCategory$ErrorState;

  const factory ProductsOfCategoryState.completed(final List<ProductModel> productsOfCategory) =
      ProductsOfCategory$CompletedState;
}

class ProductsOfCategoryBloc extends Bloc<ProductsOfCategoryEvent, ProductsOfCategoryState> {
  ProductsOfCategoryBloc({
    required final IProductsOfCategoryRepository productsOfCategoryRepository,
    required final Logger logger,
  }) : _iProductsOfCategoryRepository = productsOfCategoryRepository,
       _logger = logger,
       super(const ProductsOfCategoryState.initial()) {
    //
    on<ProductsOfCategoryEvent>(
      (event, emit) => switch (event) {
        final _ProductsOfCategory$LoadEvent event => _productsOfCategory$LoadEvent(event, emit),
        final _ProductsOfCategory$SaveProductsEvent event => _productsOfCategory$SaveProductsEvent(
          event,
          emit,
        ),
      },
    );
  }

  final IProductsOfCategoryRepository _iProductsOfCategoryRepository;
  final Logger _logger;

  Future<void> _productsOfCategory$LoadEvent(
    _ProductsOfCategory$LoadEvent event,
    Emitter<ProductsOfCategoryState> emit,
  ) async {
    try {
      emit(const ProductsOfCategoryState.inProgress());

      final products = await _iProductsOfCategoryRepository.productsOfCategory(event.categoryId);

      emit(ProductsOfCategoryState.completed(products));
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(const ProductsOfCategoryState.error());
    }
  }

  Future<void> _productsOfCategory$SaveProductsEvent(
    _ProductsOfCategory$SaveProductsEvent event,
    Emitter<ProductsOfCategoryState> emit,
  ) async {
    try {
      _logger.log(Level.debug, 'Trying to save products for category');

      if (state is! ProductsOfCategory$CompletedState) return;

      final saveProducts = await _iProductsOfCategoryRepository.saveProdouctsToCategory(
        categoryId: event.categoryId,
        products: event.selectedProducts,
      );

      _logger.log(Level.debug, 'Products for category was saved with result: $saveProducts');

      if (saveProducts) {
        final products = await _iProductsOfCategoryRepository.productsOfCategory(event.categoryId);
        emit(ProductsOfCategoryState.completed(products));
      }
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }
}
