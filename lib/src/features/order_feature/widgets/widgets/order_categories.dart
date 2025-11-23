import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/common/constants/constants.dart' hide categories;
import 'package:test_pos_app/src/common/global_data/global_data.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/order_feature/bloc/order_feature_bloc.dart';

class OrderCategories extends StatefulWidget {
  const OrderCategories({super.key});

  @override
  State<OrderCategories> createState() => _OrderCategoriesState();
}

class _OrderCategoriesState extends State<OrderCategories> {
  late OrderFeatureBloc _orderFeatureBloc;

  @override
  void initState() {
    super.initState();
    _orderFeatureBloc = DependenciesScope.of(context).orderFeatureBloc;
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<OrderFeatureBloc, OrderFeatureStates>(
    bloc: _orderFeatureBloc,
    builder: (context, state) {
      switch (state) {
        case InitialOrderState():
        case InProgressOrderState():
        case ErrorOrderState():
          return const SizedBox();
        case CompletedOrderState():
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              mainAxisExtent: 150,
              crossAxisSpacing: 10,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () =>
                    _orderFeatureBloc.add(OrderFeatureEvents.selectCategoryEvent(category)),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: mainAppColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${category.name}',
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          );
      }
    },
  );
}
