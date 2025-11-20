import 'package:flutter/material.dart';
import 'package:test_pos_app/src/features/order_feature/models/customer_invoice_model.dart';

class CashierInvoiceWidget extends StatelessWidget {

  const CashierInvoiceWidget({required this.customerInvoice, super.key});
  final CustomerInvoiceModel customerInvoice;

  @override
  Widget build(BuildContext context) => SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: customerInvoice.table?.color,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 30,
                      height: 65,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: customerInvoice.table?.imageData != null
                            ? ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                                child: Image.memory(
                                  customerInvoice.table!.imageData!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : customerInvoice.table?.icon ?? const Icon(Icons.table_chart),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Посетитель',
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '${customerInvoice.table?.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '№${customerInvoice.id} ${customerInvoice.invoiceDateTime?.substring(0, 19)}',
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Итог: ${customerInvoice.total ?? 0.0}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
}
