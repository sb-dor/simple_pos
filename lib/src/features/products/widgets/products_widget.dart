import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/circular_progress_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/error_button_widget.dart';
import 'package:test_pos_app/src/common/uikit/main_app_bar.dart';
import 'package:test_pos_app/src/common/uikit/main_app_drawer.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/authentication/widgets/authentication_listener.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/products/bloc/products_bloc.dart';
import 'package:test_pos_app/src/features/synchronization/widgets/synchronization_listener.dart';

import 'product_widget.dart';

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({super.key});

  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  late final ProductsBloc _productsBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context);
    _productsBloc = dependencies.productsBloc;
    _productsBloc.add(ProductsEvent.load());
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationListener(
      child: (context) => SynchronizationListener(
        child: (context) => Scaffold(
          drawer: MainAppDrawer(),
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, kToolbarHeight),
            child: MainAppBar(label: Constants.products),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              context.go("${AppRoutesName.products}${AppRoutesName.creation}");
            },
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: WindowSizeScope.of(context).maybeMap(
            orElse: () => FloatingActionButtonLocation.centerFloat,
            compact: () => FloatingActionButtonLocation.endFloat,
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(gradient: LinearGradient(colors: Constants.appGradientColor)),
            child: Center(
              child: SizedBox(
                width: WindowSizeScope.of(context).expandedSize,
                child: CustomScrollView(
                  slivers: [
                    BlocBuilder<ProductsBloc, ProductsState>(
                      bloc: _productsBloc,
                      builder: (context, productsState) {
                        switch (productsState) {
                          case Products$InitialState():
                            return SliverToBoxAdapter(child: SizedBox.shrink());
                          case Products$InProgressState():
                            return SliverFillRemaining(
                              child: Center(child: CircularProgressIndicatorWidget()),
                            );
                          case Products$ErrorState():
                            return SliverFillRemaining(
                              child: Center(
                                child: ErrorButtonWidget(
                                  label: Constants.reloadLabel,
                                  onTap: () {
                                    context.read<ProductsBloc>().add(ProductsEvent.load());
                                  },
                                ),
                              ),
                            );
                          case Products$CompletedState():
                            return WindowSizeScope.of(context).maybeMap(
                              compact: () => SliverList.builder(
                                itemCount: productsState.products.length,
                                itemBuilder: (context, index) {
                                  final product = productsState.products[index];
                                  return ProductItemTile(
                                    product: product,
                                    onTap: () {
                                      final path =
                                          "${AppRoutesName.products}${AppRoutesName.creation}?productId=${product.id}";
                                      context.go(path);
                                    },
                                  );
                                },
                              ),
                              orElse: () => SliverGrid.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: WindowSizeScope.of(
                                    context,
                                    listen: false,
                                  ).maybeMap(orElse: () => 4, medium: () => 3),
                                  mainAxisExtent: 120,
                                ),
                                itemCount: productsState.products.length,
                                itemBuilder: (context, index) {
                                  final product = productsState.products[index];
                                  return ProductItemTile(
                                    product: product,
                                    onTap: () {
                                      final path =
                                          "${AppRoutesName.products}${AppRoutesName.creation}?productId=${product.id}";
                                      context.go(path);
                                    },
                                  );
                                },
                              ),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
