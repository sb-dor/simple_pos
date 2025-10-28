import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/features/category_creation/bloc/category_creation_bloc.dart';
import 'package:test_pos_app/src/features/category_creation/widgets/category_creation_widgets.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/category_creation_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/products_of_category_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/products_of_category/bloc/products_of_category_bloc.dart';

class CategoryCreationConfigWidget extends StatefulWidget {
  const CategoryCreationConfigWidget({super.key, this.categoryId});

  final String? categoryId;

  @override
  State<CategoryCreationConfigWidget> createState() => _CategoryCreationConfigWidgetState();
}

class _CategoryCreationConfigWidgetState extends State<CategoryCreationConfigWidget> {
  late final CategoryCreationBloc _categoryCreationBloc;

  late final ProductsOfCategoryBloc _productsCategoriesBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context, listen: false);

    _categoryCreationBloc = CategoryCreationBlocFactory(
      appDatabase: dependencies.appDatabase,
      logger: dependencies.logger,
    ).create();

    _productsCategoriesBloc = ProductsOfCategoryBlocFactory(
      appDatabase: dependencies.appDatabase,
    ).create();

    _categoryCreationBloc.add(CategoryCreationEvent.init(categoryId: widget.categoryId));
    _productsCategoriesBloc.add(ProductsOfCategoryEvent.load(categoryId: widget.categoryId));
  }

  @override
  void dispose() {
    _categoryCreationBloc.close();
    _productsCategoriesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _categoryCreationBloc),
        BlocProvider.value(value: _productsCategoriesBloc),
      ],
      child: CategoryCreationWidgets(categoryId: widget.categoryId),
    );
  }
}
