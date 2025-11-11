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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsOfCategoryBloc, ProductsOfCategoryState>(
      builder: (context, productsOfCategoryState) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            scrolledUnderElevation: 0.0,
            elevation: 0.0,
            title: TextWidget(
              text: Constants.productsOfCategory,
              size: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          body: CustomScrollView(
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
          ),
        );
      },
    );
  }
}
