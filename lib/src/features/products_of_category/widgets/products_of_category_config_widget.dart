import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/products_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/products_of_category_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/products/bloc/products_bloc.dart';
import 'package:test_pos_app/src/features/products_of_category/bloc/products_of_category_bloc.dart';
import 'package:test_pos_app/src/features/products_of_category/widgets/products_of_category_widget.dart';

class ProductsOfCategoryConfigWidget extends StatefulWidget {
  const ProductsOfCategoryConfigWidget({super.key, required this.categoryId});

  final String? categoryId;

  @override
  State<ProductsOfCategoryConfigWidget> createState() => _ProductsOfCategoryConfigWidgetState();
}

class _ProductsOfCategoryConfigWidgetState extends State<ProductsOfCategoryConfigWidget> {
  late final ProductsOfCategoryBloc _productsOfCategoryBloc;
  late final ProductsBloc _productsBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context, listen: false);
    _productsOfCategoryBloc = ProductsOfCategoryBlocFactory(
      appDatabase: dependencies.appDatabase,
    ).create();
    _productsBloc = ProductsBlocFactory(dependencies.appDatabase).create();
  }

  @override
  void dispose() {
    _productsOfCategoryBloc.close();
    _productsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _productsOfCategoryBloc),
        BlocProvider.value(value: _productsBloc),
      ],
      child: ProductsOfCategoryWidget(categoryId: widget.categoryId),
    );
  }
}
