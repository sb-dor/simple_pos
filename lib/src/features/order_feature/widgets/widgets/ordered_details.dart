import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/order_feature/bloc/order_feature_bloc.dart';

class OrderedDetails extends StatefulWidget {
  const OrderedDetails({super.key});

  @override
  State<OrderedDetails> createState() => _OrderedDetailsState();
}

class _OrderedDetailsState extends State<OrderedDetails> {
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
            final currentStateModel = state.orderFeatureStateModel;
            return Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                shrinkWrap: true,
                itemCount: currentStateModel.orderItems.length,
                itemBuilder: (context, index) {
                  final orderItem = currentStateModel.orderItems[index];
                  return GestureDetector(
                    onTap: () =>
                        _orderFeatureBloc.add(OrderFeatureEvents.addOrderItemForChange(orderItem)),
                    child: Container(
                      color:
                          currentStateModel.orderItemForChange?.product?.id == orderItem.product?.id
                          ? Colors.blueAccent.shade100
                          : Colors.transparent,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  orderItem.product?.name ?? '-',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                onPressed: () => _orderFeatureBloc.add(
                                  OrderFeatureEvents.addProductToOrderEvent(orderItem.product),
                                ),
                                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                              ),
                              Text(
                                '${orderItem.qty?.toInt()}',
                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                              ),
                              IconButton(
                                onPressed: () => _orderFeatureBloc.add(
                                  OrderFeatureEvents.decrementOrderItemQtyEvent(orderItem.product),
                                ),
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              ),
                            ],
                          ),
                          if (currentStateModel.orderItemForChange?.product?.id ==
                              orderItem.product?.id)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                      backgroundColor: WidgetStatePropertyAll(Colors.red.shade500),
                                    ),
                                    onPressed: () => _orderFeatureBloc.add(
                                      const OrderFeatureEvents.deleteOrderItemFromOrder(),
                                    ),
                                    child: const Text(
                                      'Удалить из счета',
                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
        }
      },
    );
}
