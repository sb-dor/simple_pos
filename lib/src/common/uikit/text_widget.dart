import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    required this.text,
    super.key,
    this.size,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.textDecoration,
    this.decorationColor,
    this.overFlow,
    this.textAlign,
    this.padding,
    this.letterSpacing,
    this.height,
  });
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextDecoration? textDecoration;
  final Color? decorationColor;
  final TextOverflow? overFlow;
  final TextAlign? textAlign;
  final EdgeInsets? padding;
  final double? letterSpacing;
  final double? height;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding ?? EdgeInsets.zero,
    child: Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        height: height,
        color: color,
        fontSize: size ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        decoration: textDecoration,
        overflow: overFlow,
        letterSpacing: letterSpacing,
        decorationColor: decorationColor,
      ),
    ),
  );
}
