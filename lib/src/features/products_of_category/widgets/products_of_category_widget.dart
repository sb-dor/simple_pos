import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/common/uikit/circular_progress_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/error_button_widget.dart';
import 'package:test_pos_app/src/common/uikit/text_widget.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/features/products/widgets/product_widget.dart';
import 'package:test_pos_app/src/features/products_of_category/bloc/products_of_category_bloc.dart';

class ProductsOfCategoryWidget extends StatefulWidget {
  const ProductsOfCategoryWidget({super.key, required this.categoryId});

  final String? categoryId;

  @override
  State<ProductsOfCategoryWidget> createState() => _ProductsOfCategoryWidgetState();
}

class _ProductsOfCategoryWidgetState extends State<ProductsOfCategoryWidget> {
  late final List<Tab> _tabs;
  late final List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _tabs = [Tab(text: "Selected products"), Tab(text: "All products")];
    _children = [_ProdudctsOfCategory(categoryId: widget.categoryId), _AllProductsWidget()];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          scrolledUnderElevation: 0.0,
          elevation: 0.0,
          title: TextWidget(
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
}

class _ProdudctsOfCategory extends StatefulWidget {
  const _ProdudctsOfCategory({required this.categoryId});

  final String? categoryId;

  @override
  State<_ProdudctsOfCategory> createState() => __ProdudctsOfCategoryState();
}

class __ProdudctsOfCategoryState extends State<_ProdudctsOfCategory> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsOfCategoryBloc, ProductsOfCategoryState>(
      builder: (context, productsOfCategoryState) {
        return CustomScrollView(
          slivers: [
            switch (productsOfCategoryState) {
              ProductsOfCategory$InitialState() => SliverToBoxAdapter(child: SizedBox.shrink()),
              ProductsOfCategory$InProgressState() => SliverFillRemaining(
                child: Center(child: CircularProgressIndicatorWidget()),
              ),
              ProductsOfCategory$ErrorState() => SliverFillRemaining(
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
              ProductsOfCategory$CompletedState() => SliverList.separated(
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: productsOfCategoryState.productsOfCategory.length,
                itemBuilder: (context, index) {
                  final product = productsOfCategoryState.productsOfCategory[index];
                  return ProductItemTile(product: product);
                },
              ),
            },
          ],
        );
      },
    );
  }
}

class _AllProductsWidget extends StatefulWidget {
  const _AllProductsWidget({super.key});

  @override
  State<_AllProductsWidget> createState() => __AllProductsWidgetState();
}

class __AllProductsWidgetState extends State<_AllProductsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
