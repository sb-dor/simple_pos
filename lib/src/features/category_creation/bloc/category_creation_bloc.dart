import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';
import 'package:test_pos_app/src/features/category_creation/data/category_creation_repository.dart';
import 'package:test_pos_app/src/features/category_creation/widgets/controllers/category_creation_widget_controller.dart';
part 'category_creation_bloc.freezed.dart';

@freezed
sealed class CategoryCreationEvent with _$CategoryCreationEvent {
  const factory CategoryCreationEvent.init({required String categoryId}) =
      _CategoryCreation$InitEvent;

  const factory CategoryCreationEvent.save({
    required final CategoryCreationData categoryCreationData,
    required final void Function() onSave,
  }) = _CategoryCreation$SaveEvent;
}

@freezed
sealed class CategoryCreationState with _$CategoryCreationState {
  const factory CategoryCreationState.initial(final CategoryModel? category) =
      CategoryCreation$InitialState;

  const factory CategoryCreationState.inProgress(final CategoryModel? category) =
      CategoryCreation$InProgressState;

  const factory CategoryCreationState.error(final CategoryModel? category) =
      CategoryCreation$ErrorState;

  const factory CategoryCreationState.completed(final CategoryModel? category) =
      CategoryCreation$CompletedState;

  static CategoryCreationState get initialState => CategoryCreationState.initial(null);
}

class CategoryCreationBloc extends Bloc<CategoryCreationEvent, CategoryCreationState> {
  CategoryCreationBloc({
    required final ICategoryCreationRepository repository,
    required final Logger logger,
    CategoryCreationState? initialState,
  }) : _iCategoryCreationRepository = repository,
       _logger = logger,
       super(initialState ?? CategoryCreationState.initialState) {
    //
    on<CategoryCreationEvent>(
      (event, emit) => switch (event) {
        final _CategoryCreation$InitEvent event => _categoryCreation$InitEvent(event, emit),
        final _CategoryCreation$SaveEvent event => _categoryCreation$SaveEvent(event, emit),
      },
    );
  }

  final ICategoryCreationRepository _iCategoryCreationRepository;
  final Logger _logger;

  void _categoryCreation$InitEvent(
    _CategoryCreation$InitEvent event,
    Emitter<CategoryCreationState> emit,
  ) async {
    try {
      final category = await _iCategoryCreationRepository.category(event.categoryId);
      _logger.d("Found category on init: $category");
      emit(CategoryCreationState.initial(category ?? CategoryModel(id: event.categoryId)));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  void _categoryCreation$SaveEvent(
    _CategoryCreation$SaveEvent event,
    Emitter<CategoryCreationState> emit,
  ) async {
    try {
      emit(CategoryCreationState.inProgress(state.category));

      final category = (state.category ?? CategoryModel()).copyWith(
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
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(CategoryCreationState.error(state.category));
    }
  }

  @override
  Future<void> close() async {
    await _iCategoryCreationRepository.clearProducts(state.category?.id ?? '');
    return super.close();
  }
}
