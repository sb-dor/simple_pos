import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/order_feature/bloc/order_feature_bloc.dart';

class PlaceWidget extends StatefulWidget {
  const PlaceWidget({super.key, required this.table});

  final TableModel table;

  @override
  State<PlaceWidget> createState() => _PlaceWidgetState();
}

class _PlaceWidgetState extends State<PlaceWidget> {
  late final OrderFeatureBloc _orderFeatureBloc;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _orderFeatureBloc = DependenciesScope.of(context, listen: false).orderFeatureBloc;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {
          context.go("${AppRoutesName.orderTables}/products?table_id=${widget.table.id}");
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 6),
                      blurRadius: 10,
                    ),
                  ]
                : [],
          ),
          padding: const EdgeInsets.all(8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                widget.table.name ?? '',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Positioned(
                top: 5,
                left: 6,
                child: widget.table.imageData != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.memory(
                          widget.table.imageData!,
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      )
                    : (widget.table.icon ?? const Icon(Icons.table_chart)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
