import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_pos_app/src/features/categories/data/categories_repository.dart';

part 'categories_bloc.freezed.dart';

@freezed
sealed class CategoriesEvent with _$CategoriesEvent {}

@freezed
sealed class CategoriesState with _$CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({required final ICategoriesRepository repository})
    : _iCategoriesRepository = repository,
      super(CategoriesInitial()) {
    on<CategoriesEvent>((event, emit) {
      //
    });
  }

  final ICategoriesRepository _iCategoriesRepository;
}
