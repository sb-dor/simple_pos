import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/text_widget.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';

class AppBarBack extends StatefulWidget {
  const AppBarBack({
    super.key,
    required this.label,
    required this.backPath,
    this.backLabel = "Назад",
  });

  final String label;
  final String backPath;
  final String backLabel;

  @override
  State<AppBarBack> createState() => _AppBarBackState();
}

class _AppBarBackState extends State<AppBarBack> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: Constants.appGradientColor),
        color: Colors.white.withValues(alpha: 0.8),
      ),
      child: SafeArea(
        child: Center(
          child: SizedBox(
            width: WindowSizeScope.of(context).expandedSize + 200,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    onPressed: () {
                      context.go(widget.backPath);
                    },
                    label: Text(widget.backLabel),
                    icon: Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextWidget(
                      text: widget.label,
                      size: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                      maxLines: 1,
                      overFlow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
