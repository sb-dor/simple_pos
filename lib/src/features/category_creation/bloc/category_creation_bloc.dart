import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:l/l.dart';

import 'package:test_pos_app/src/features/categories/models/category_model.dart';
import 'package:test_pos_app/src/features/category_creation/data/category_creation_repository.dart';
import 'package:test_pos_app/src/features/category_creation/widgets/controllers/category_creation_widget_controller.dart';

part 'category_creation_bloc.freezed.dart';

/// Events for the [CategoryCreationBloc].
/// Used to initialize and save a category.
@freezed
sealed class CategoryCreationEvent with _$CategoryCreationEvent {
  /// Event to initialize category creation with a specific category ID.
  const factory CategoryCreationEvent.init({required String categoryId}) =
      _CategoryCreation$InitEvent;

  /// Event to save category data.
  ///
  /// [categoryCreationData] — the data to save.
  /// [onSave] — callback function invoked after successful save.
  const factory CategoryCreationEvent.save({
    required final CategoryCreationData categoryCreationData,
    required final void Function() onSave,
  }) = _CategoryCreation$SaveEvent;
}

/// States for the [CategoryCreationBloc].
/// Represents different stages of category creation or editing.
@freezed
sealed class CategoryCreationState with _$CategoryCreationState {
  /// Initial state, optionally contains a category if loaded.
  const factory CategoryCreationState.initial(final CategoryModel? category) =
      CategoryCreation$InitialState;

  /// State indicating that category creation or saving is in progress.
  const factory CategoryCreationState.inProgress(final CategoryModel? category) =
      CategoryCreation$InProgressState;

  /// State indicating an error occurred during category creation or saving.
  const factory CategoryCreationState.error(final CategoryModel? category) =
      CategoryCreation$ErrorState;

  /// State indicating category creation or update completed successfully.
  const factory CategoryCreationState.completed(final CategoryModel? category) =
      CategoryCreation$CompletedState;
}

class CategoryCreationBloc extends Bloc<CategoryCreationEvent, CategoryCreationState> {
  CategoryCreationBloc({
    required final ICategoryCreationRepository repository,
    required final CategoryCreationState initialState,
  }) : _iCategoryCreationRepository = repository,
       super(initialState) {
    //
    on<CategoryCreationEvent>(
      (event, state) => switch (event) {
        final _CategoryCreation$InitEvent event => _categoryCreation$InitEvent(event, state),
        final _CategoryCreation$SaveEvent event => _categoryCreation$SaveEvent(event, state),
      },
    );
  }

  /// Repository used to fetch and save category data.
  final ICategoryCreationRepository _iCategoryCreationRepository;

  /// Handles [CategoryCreationEvent.init] to load category data by ID.
  ///
  /// Emits [CategoryCreationState.initial] with the loaded or temporary category.
  Future<void> _categoryCreation$InitEvent(
    _CategoryCreation$InitEvent event,
    Emitter<CategoryCreationState> emit,
  ) async {
    try {
      final category = await _iCategoryCreationRepository.category(event.categoryId);
      if (category == null) {
        l.d(
          'Category was not found\n'
          'Was added temp category with temp id: ${event.categoryId}',
        );
      } else {
        l.d('Found category on init: $category');
      }
      emit(CategoryCreationState.initial(category ?? CategoryModel(id: event.categoryId)));
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  /// Handles [CategoryCreationEvent.save] to save or update category data.
  ///
  /// Emits:
  /// - [CategoryCreationState.inProgress] while saving.
  /// - [CategoryCreationState.completed] if save is successful.
  /// - [CategoryCreationState.initial] if save fails.
  /// - [CategoryCreationState.error] if an exception occurs.
  Future<void> _categoryCreation$SaveEvent(
    _CategoryCreation$SaveEvent event,
    Emitter<CategoryCreationState> emit,
  ) async {
    try {
      emit(CategoryCreationState.inProgress(state.category));

      final category = (state.category ?? const CategoryModel()).copyWith(
        id: state.category?.id ?? event.categoryCreationData.categoryId,
        name: () => event.categoryCreationData.name,
        updatedAt: DateTime.now,
        color: () => event.categoryCreationData.color,
        changed: true,
      );

      final save = await _iCategoryCreationRepository.save(category);

      if (save) {
        emit(CategoryCreationState.completed(category));
      } else {
        emit(CategoryCreationState.initial(state.category));
      }
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(CategoryCreationState.error(state.category));
    }
  }

  /// Clears products associated with the category when the bloc is closed.
  @override
  Future<void> close() async {
    await _iCategoryCreationRepository.clearProducts(state.category?.id ?? '');
    return super.close();
  }
}
