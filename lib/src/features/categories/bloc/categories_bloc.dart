import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/categories/data/categories_repository.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';

part 'categories_bloc.freezed.dart';

/// Events for the [CategoriesBloc].
/// Currently, only supports refreshing the list of categories.
@freezed
sealed class CategoriesEvent with _$CategoriesEvent {
  /// Event to refresh the list of categories from the repository.
  const factory CategoriesEvent.refresh() = Categories$RefreshEvent;
}

/// States for the [CategoriesBloc].
/// Represents different stages of category data fetching.
@freezed
sealed class CategoriesState with _$CategoriesState {
  /// Initial state before any category action is performed.
  const factory CategoriesState.initial() = Categories$InitialState;

  /// State indicating that category data is being fetched.
  const factory CategoriesState.inProgress() = Categories$InProgressState;

  /// State indicating an error occurred while fetching categories.
  const factory CategoriesState.error() = Categories$ErrorState;

  /// State indicating category data has been successfully fetched.
  ///
  /// [categories] — the list of fetched category models.
  const factory CategoriesState.completed(final List<CategoryModel> categories) =
      Categories$CompletedState;
}

/// Bloc responsible for managing categories state based on [CategoriesEvent].
/// Interacts with [ICategoriesRepository] to fetch category data.
class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  /// Constructs the bloc with a required repository.
  CategoriesBloc({required final ICategoriesRepository repository})
    : _iCategoriesRepository = repository,
      super(const CategoriesState.initial()) {
    //
    on<CategoriesEvent>(
      (event, emit) => switch (event) {
        final Categories$RefreshEvent event => _categories$RefreshEvent(event, emit),
      },
    );
  }

  /// Repository used to fetch category data.
  final ICategoriesRepository _iCategoriesRepository;

  /// Handles the [Categories$RefreshEvent] to fetch categories from the repository.
  ///
  /// Emits:
  /// - [CategoriesState.inProgress] when fetching starts.
  /// - [CategoriesState.completed] with the list of categories if successful.
  /// - [CategoriesState.error] if an exception occurs.
  Future<void> _categories$RefreshEvent(
    Categories$RefreshEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      emit(const CategoriesState.inProgress());

      final categories = await _iCategoriesRepository.categories();

      emit(CategoriesState.completed(categories));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(const CategoriesState.error());
    }
  }
}
