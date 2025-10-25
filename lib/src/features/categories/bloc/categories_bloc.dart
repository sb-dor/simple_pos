import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/categories/data/categories_repository.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';

part 'categories_bloc.freezed.dart';

@freezed
sealed class CategoriesEvent with _$CategoriesEvent {
  const factory CategoriesEvent.refresh() = Categories$RefreshEvent;
}

@freezed
sealed class CategoriesState with _$CategoriesState {
  const factory CategoriesState.initial() = Categories$InitialState;

  const factory CategoriesState.inProgress() = Categories$InProgressState;

  const factory CategoriesState.error() = Categories$ErrorState;

  const factory CategoriesState.completed(final List<CategoryModel> categories) =
      Categories$CompletedState;
}

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({required final ICategoriesRepository repository})
    : _iCategoriesRepository = repository,
      super(CategoriesState.initial()) {
    //
    on<CategoriesEvent>(
      (event, emit) => switch (event) {
        final Categories$RefreshEvent event => _categories$RefreshEvent(event, emit),
      },
    );
  }

  final ICategoriesRepository _iCategoriesRepository;

  void _categories$RefreshEvent(
    Categories$RefreshEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      emit(CategoriesState.inProgress());

      final categories = await _iCategoriesRepository.categories();

      emit(CategoriesState.completed(categories));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(CategoriesState.error());
    }
  }
}
