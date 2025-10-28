import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/products/data/products_repository.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';

part 'products_bloc.freezed.dart';

@freezed
sealed class ProductsEvent with _$ProductsEvent {
  const factory ProductsEvent.load() = _Products$LoadEvent;
}

@freezed
sealed class ProductsState with _$ProductsState {
  const factory ProductsState.initial() = Products$InitialState;

  const factory ProductsState.inProgress() = Products$InProgressState;

  const factory ProductsState.error() = Products$ErrorState;

  const factory ProductsState.completed(final List<ProductModel> products) =
      Products$CompletedState;
}

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc({required final IProductsRepository iProductsRepository})
    : _iProductsRepository = iProductsRepository,
      super(const ProductsState.initial()) {
    //
    on<ProductsEvent>(
      (event, emit) => switch (event) {
        final _Products$LoadEvent event => _products$LoadEvent(event, emit),
      },
    );
  }

  final IProductsRepository _iProductsRepository;

  void _products$LoadEvent(_Products$LoadEvent event, Emitter<ProductsState> emit) async {
    try {
      emit(ProductsState.inProgress());

      final products = await _iProductsRepository.products();

      emit(ProductsState.completed(products));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(ProductsState.error());
    }
  }
}
