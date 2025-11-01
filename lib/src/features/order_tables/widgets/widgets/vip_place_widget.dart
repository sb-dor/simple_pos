import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/features/tables/models/table_model.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';

class VipPlaceWidget extends StatefulWidget {
  const VipPlaceWidget({super.key, required this.table});

  final TableModel table;

  @override
  State<VipPlaceWidget> createState() => _VipPlaceWidgetState();
}

class _VipPlaceWidgetState extends State<VipPlaceWidget> {
  bool _hovered = false;

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
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: Colors.amberAccent.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      offset: const Offset(0, 6),
                      blurRadius: 10,
                    ),
                  ]
                : [],
          ),
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: widget.table.color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: widget.table.icon ?? const Icon(Icons.star, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Center(
                  child: Text(
                    widget.table.name ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
