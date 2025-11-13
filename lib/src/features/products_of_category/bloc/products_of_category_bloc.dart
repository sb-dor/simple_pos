import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';
import 'package:test_pos_app/src/features/products_of_category/data/products_of_category_repository.dart';

part 'products_of_category_bloc.freezed.dart';

@freezed
sealed class ProductsOfCategoryEvent with _$ProductsOfCategoryEvent {
  const factory ProductsOfCategoryEvent.load({required final String? categoryId}) =
      _ProductsOfCategory$LoadEvent;

  const factory ProductsOfCategoryEvent.saveProducts(
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
  }) : _iProductsOfCategoryRepository = productsOfCategoryRepository,
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

  void _productsOfCategory$LoadEvent(
    _ProductsOfCategory$LoadEvent event,
    Emitter<ProductsOfCategoryState> emit,
  ) async {
    try {
      emit(ProductsOfCategoryState.inProgress());

      if (event.categoryId == null) {
        emit(ProductsOfCategoryState.completed(<ProductModel>[]));
        return;
      }

      final products = await _iProductsOfCategoryRepository.productsOfCategory(event.categoryId!);

      emit(ProductsOfCategoryState.completed(products));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(const ProductsOfCategoryState.error());
    }
  }

  void _productsOfCategory$SaveProductsEvent(
    _ProductsOfCategory$SaveProductsEvent event,
    Emitter<ProductsOfCategoryState> emit,
  ) async {
    try {
      if (state is! ProductsOfCategory$CompletedState) {}
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }
}
