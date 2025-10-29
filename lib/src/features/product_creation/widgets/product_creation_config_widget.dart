import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/product_creation_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/product_creation/bloc/product_creation_bloc.dart';

class ProductCreationConfigWidget extends StatefulWidget {
  const ProductCreationConfigWidget({super.key, required this.productsId});

  final String? productsId;

  @override
  State<ProductCreationConfigWidget> createState() => _ProductCreationConfigWidgetState();
}

class _ProductCreationConfigWidgetState extends State<ProductCreationConfigWidget> {
  late final ProductCreationBloc _productCreationBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context);
    _productCreationBloc = ProductCreationBlocFactory(
      appDatabase: dependencies.appDatabase,
    ).create();
    _productCreationBloc.add(ProductCreationEvent.init(productId: widget.productsId));
  }

  @override
  void dispose() {
    _productCreationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: _productCreationBloc, child: SizedBox());
  }
}
