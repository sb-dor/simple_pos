import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/common/uikit/circular_progress_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/error_button_widget.dart';
import 'package:test_pos_app/src/common/uikit/refresh_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/text_widget.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/features/products/bloc/products_bloc.dart';
import 'package:test_pos_app/src/features/products/models/product_model.dart';
import 'package:test_pos_app/src/features/products/widgets/product_widget.dart';
import 'package:test_pos_app/src/features/products_of_category/bloc/products_of_category_bloc.dart';

class ProductsOfCategoryWidget extends StatefulWidget {
  const ProductsOfCategoryWidget({required this.categoryId, super.key});

  final String categoryId;

  @override
  State<ProductsOfCategoryWidget> createState() => _ProductsOfCategoryWidgetState();
}

class _ProductsOfCategoryWidgetState extends State<ProductsOfCategoryWidget> {
  late final List<Tab> _tabs;
  late final List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _tabs = [const Tab(text: 'Selected products'), const Tab(text: 'All products')];
    _children = [
      _ProdudctsOfCategory(categoryId: widget.categoryId),
      _AllProductsWidget(categoryId: widget.categoryId),
    ];
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: const TextWidget(
            text: Constants.productsOfCategory,
            size: 22,
            fontWeight: FontWeight.w500,
          ),
          bottom: TabBar(tabs: _tabs),
        ),
        body: TabBarView(children: _children),
      ),
    );
}

class _ProdudctsOfCategory extends StatefulWidget {
  const _ProdudctsOfCategory({required this.categoryId});

  final String categoryId;

  @override
  State<_ProdudctsOfCategory> createState() => __ProdudctsOfCategoryState();
}

class __ProdudctsOfCategoryState extends State<_ProdudctsOfCategory> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(const ProductsEvent.load());
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<ProductsOfCategoryBloc, ProductsOfCategoryState>(
      builder: (context, productsOfCategoryState) => RefreshIndicatorWidget(
          onRefresh: () async => context.read<ProductsBloc>().add(const ProductsEvent.load()),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              switch (productsOfCategoryState) {
                ProductsOfCategory$InitialState() => const SliverToBoxAdapter(child: SizedBox.shrink()),
                ProductsOfCategory$InProgressState() => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicatorWidget()),
                ),
                ProductsOfCategory$ErrorState() => SliverFillRemaining(
                  child: Center(
                    child: ErrorButtonWidget(
                      label: Constants.reloadLabel,
                      onTap: () {
                        context.read<ProductsBloc>().add(const ProductsEvent.load());
                      },
                    ),
                  ),
                ),
                ProductsOfCategory$CompletedState() => SliverList.separated(
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemCount: productsOfCategoryState.productsOfCategory.length,
                  itemBuilder: (context, index) {
                    final product = productsOfCategoryState.productsOfCategory[index];
                    return ProductItemTile(product: product);
                  },
                ),
              },
            ],
          ),
        ),
    );
}

class _AllProductsWidget extends StatefulWidget {
  const _AllProductsWidget({required this.categoryId});

  final String categoryId;

  @override
  State<_AllProductsWidget> createState() => __AllProductsWidgetState();
}

class __AllProductsWidgetState extends State<_AllProductsWidget> {
  final Map<String, ProductModel> _selectedProducts = {};
  late final StreamSubscription<ProductsOfCategoryState> _productsOfCategoryStateSubs;

  @override
  void initState() {
    super.initState();

    _productsOfCategoryStateSubs = context.read<ProductsOfCategoryBloc>().stream.listen((state) {
      if (state is ProductsOfCategory$CompletedState) {
        _selectedProducts.clear();
        for (final each in state.productsOfCategory) {
          if (each.id == null) continue;
          _selectedProducts[each.id!] = each;
        }
        setState(() {});
      }
    });

    context.read<ProductsOfCategoryBloc>().add(
      ProductsOfCategoryEvent.load(categoryId: widget.categoryId),
    );
  }

  @override
  void dispose() {
    _productsOfCategoryStateSubs.cancel();
    super.dispose();
  }

  bool _selected(final String? id) => _selectedProducts[id] != null;

  @override
  Widget build(BuildContext context) => BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, productsState) => Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.read<ProductsOfCategoryBloc>().add(
                ProductsOfCategoryEvent.saveProducts(
                  widget.categoryId,
                  _selectedProducts.values.toList(),
                ),
              );
            },
            child: const Icon(Icons.save),
          ),
          body: RefreshIndicatorWidget(
            onRefresh: () async => context.read<ProductsOfCategoryBloc>().add(
              ProductsOfCategoryEvent.load(categoryId: widget.categoryId),
            ),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                switch (productsState) {
                  Products$InitialState() => const SliverToBoxAdapter(child: SizedBox()),
                  Products$InProgressState() => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicatorWidget()),
                  ),
                  Products$ErrorState() => SliverFillRemaining(
                    child: Center(
                      child: ErrorButtonWidget(
                        label: Constants.reloadLabel,
                        onTap: () {
                          context.read<ProductsOfCategoryBloc>().add(
                            ProductsOfCategoryEvent.load(categoryId: widget.categoryId),
                          );
                        },
                      ),
                    ),
                  ),
                  Products$CompletedState() => SliverList.builder(
                    itemCount: productsState.products.length,
                    itemBuilder: (context, index) {
                      final product = productsState.products[index];
                      final selected = _selected(product.id);
                      return Row(
                        children: [
                          Checkbox(
                            value: selected,
                            onChanged: (value) {
                              if (product.id == null) return;
                              setState(() {
                                if (_selectedProducts[product.id!] != null) {
                                  _selectedProducts.remove(product.id!);
                                  return;
                                }
                                _selectedProducts[product.id!] = product;
                              });
                            },
                          ),
                          Expanded(child: ProductItemTile(product: product)),
                        ],
                      );
                    },
                  ),
                },
              ],
            ),
          ),
        ),
    );
}
