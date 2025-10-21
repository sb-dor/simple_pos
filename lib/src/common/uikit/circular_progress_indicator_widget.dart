import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final double? value;
  final bool useAndroidIndicator;
  final Size? size;

  const CircularProgressIndicatorWidget({
    super.key,
    this.strokeWidth = 4,
    this.color,
    this.backgroundColor,
    this.value,
    this.useAndroidIndicator = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (defaultTargetPlatform == TargetPlatform.iOS && !useAndroidIndicator)
          ? CupertinoActivityIndicator(color: color)
          : SizedBox(
              width: size?.width,
              height: size?.height,
              child: CircularProgressIndicator(
                value: value,
                backgroundColor: backgroundColor ?? Colors.transparent,
                color: color,
                strokeWidth: strokeWidth,
              ),
            ),
    );
  }
}
