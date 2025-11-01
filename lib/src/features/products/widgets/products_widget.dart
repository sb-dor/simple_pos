import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/common/uikit/circular_progress_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/error_button_widget.dart';
import 'package:test_pos_app/src/common/uikit/main_app_bar.dart';
import 'package:test_pos_app/src/common/uikit/main_app_drawer.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
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
  late final AuthenticationBloc _authenticationBloc;
  late final ProductsBloc _productsBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context, listen: false);
    _authenticationBloc = dependencies.authenticationBloc;
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
              await context.push(AppRoutesName.products + AppRoutesName.creation);
              _productsBloc.add(ProductsEvent.load());
            },
            child: Icon(Icons.add),
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(gradient: LinearGradient(colors: Constants.appGradientColor)),
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
                            child: ErrorButtonWidget(label: Constants.reloadLabel, onTap: () {}),
                          ),
                        );
                      case Products$CompletedState():
                        return SliverList.builder(
                          itemCount: productsState.products.length,
                          itemBuilder: (context, index) {
                            final product = productsState.products[index];
                            return ProductItemTile(
                              product: product,
                              onTap: () {
                                // open details or edit product
                              },
                            );
                          },
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
