import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/category_creation/data/category_creation_repository.dart';
import 'package:test_pos_app/src/features/category_creation/widgets/controllers/category_creation_widget_controller.dart';

part 'category_creation_bloc.freezed.dart';

@freezed
sealed class CategoryCreationEvent with _$CategoryCreationEvent {
  const factory CategoryCreationEvent.init({@Default(null) String? categoryId}) =
      _CategoryCreation$RefreshEvent;

  const factory CategoryCreationEvent.save({
    required final CategoryCreationWidgetData categoryData,
    required final void Function() onSave,
  }) = _CategoryCreation$SaveEvent;
}

@freezed
sealed class CategoryCreationState with _$CategoryCreationState {
  const factory CategoryCreationState.initial() = _Initial;

  static CategoryCreationState get initialState => CategoryCreationState.initial();
}

class CategoryCreationBloc extends Bloc<CategoryCreationEvent, CategoryCreationState> {
  CategoryCreationBloc({
    required final ICategoryCreationRepository repository,
    CategoryCreationState? initialState,
  }) : _iCategoryCreationRepository = repository,
       super(initialState ?? CategoryCreationState.initialState) {
    //
    on<CategoryCreationEvent>(
      (event, emit) => switch (event) {
        final _CategoryCreation$RefreshEvent event => _categoryCreation$RefreshEvent(event, emit),
        final _CategoryCreation$SaveEvent event => _categoryCreation$SaveEvent(event, emit),
      },
    );
  }

  final ICategoryCreationRepository _iCategoryCreationRepository;

  void _categoryCreation$RefreshEvent(
    _CategoryCreation$RefreshEvent event,
    Emitter<CategoryCreationState> emit,
  ) async {}

  void _categoryCreation$SaveEvent(
    _CategoryCreation$SaveEvent event,
    Emitter<CategoryCreationState> emit,
  ) async {}
}
