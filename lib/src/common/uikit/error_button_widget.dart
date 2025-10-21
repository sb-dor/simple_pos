import 'package:flutter/material.dart';
import 'package:test_pos_app/src/common/uikit/text_widget.dart';

class ErrorButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const ErrorButtonWidget({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: FilledButton(
          onPressed: onTap,
          child: TextWidget(text: label, color: Colors.white),
        ),
      ),
    );
  }
}
