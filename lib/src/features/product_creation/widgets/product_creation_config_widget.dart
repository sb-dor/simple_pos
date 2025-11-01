import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/common/uikit/app_bar_back.dart';
import 'package:test_pos_app/src/common/uikit/drop_down_selection_widget.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/common/utils/text_controller_listener.dart';
import 'package:test_pos_app/src/features/authentication/widgets/authentication_listener.dart';
import 'package:test_pos_app/src/features/initialization/logic/factories/product_creation_bloc_factory.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/product_creation/bloc/product_creation_bloc.dart';
import 'package:test_pos_app/src/features/product_creation/widgets/controllers/product_creation_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/main_app_drawer.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';
import 'package:test_pos_app/src/features/synchronization/widgets/synchronization_listener.dart';
import 'package:test_pos_app/src/features/products/models/product_type.dart';
import 'package:test_pos_app/src/features/categories/models/category_model.dart';

part 'product_creation_widget.dart';

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
    final dependencies = DependenciesScope.of(context, listen: false);
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
    return BlocProvider.value(
      value: _productCreationBloc,
      child: _ProductCreationWidgets(productId: widget.productsId),
    );
  }
}
