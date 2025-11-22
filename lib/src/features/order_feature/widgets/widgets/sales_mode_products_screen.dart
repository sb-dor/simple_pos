import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/common/uikit/circular_progress_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/error_button_widget.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/common/utils/extensions/order_item_extentions.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/order_feature/bloc/order_feature_bloc.dart';
import 'package:test_pos_app/src/features/order_feature/widgets/widgets/order_categories.dart';
import 'package:test_pos_app/src/features/order_feature/widgets/widgets/ordered_details.dart';
import 'package:test_pos_app/src/features/order_feature/widgets/widgets/ordering_products.dart';

class SalesModeProductsScreen extends StatefulWidget {
  const SalesModeProductsScreen({required this.tableId, super.key});

  final String tableId;

  @override
  State<SalesModeProductsScreen> createState() => _SalesModeProductsScreenState();
}

class _SalesModeProductsScreenState extends State<SalesModeProductsScreen> {
  late OrderFeatureBloc _orderFeatureBloc;

  @override
  void initState() {
    super.initState();
    _orderFeatureBloc = DependenciesScope.of(context).orderFeatureBloc;
    _orderFeatureBloc.add(OrderFeatureEvents.addPlaceEvent(widget.tableId));
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<OrderFeatureBloc, OrderFeatureStates>(
    bloc: _orderFeatureBloc,
    builder: (context, state) {
      switch (state) {
        case InitialOrderState():
          return const SizedBox.shrink();
        case InProgressOrderState():
          return const CircularProgressIndicatorWidget();
        case ErrorOrderState():
          return ErrorButtonWidget(
            label: reloadLabel,
            onTap: () {
              //
            },
          );
        case CompletedOrderState():
          final currentStateModel = state.orderFeatureStateModel;
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (currentStateModel.orderItems.isNotEmpty)
                  GestureDetector(
                    onTap: () => _orderFeatureBloc.add(
                      OrderFeatureEvents.finishCustomerInvoice(
                        onMessage: (message) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(message)));
                        },
                      ),
                    ),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '$pay - ${currentStateModel.orderItems.total()}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 5),
                const OrderedDetails(),
                Expanded(
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [OrderCategories(), SizedBox(height: 20), OrderingProducts()],
                  ),
                ),
              ],
            ),
          );
      }
    },
  );
}
