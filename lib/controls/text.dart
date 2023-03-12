import 'package:flutter/material.dart';

enum TextProps { sm, normal, md, lg, xl }

class TextControl extends StatefulWidget {
  final dynamic text;
  final TextProps size;
  final bool? isBold;
  final Color? color;

  const TextControl({this.text, this.size = TextProps.normal, this.isBold = false, this.color});
  @override
  State<TextControl> createState() => _TextControlState();
}

class _TextControlState extends State<TextControl> {
  TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    switch (widget.size) {
      case TextProps.sm:
        textStyle = TextStyle(
          fontSize: 8,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
        );
        break;
      case TextProps.normal:
        textStyle = TextStyle(
          fontSize: 12,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
        );
        break;
      case TextProps.md:
        textStyle = TextStyle(
          fontSize: 20,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
        );
        break;
      case TextProps.lg:
        textStyle = TextStyle(
          fontSize: 30,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
        );
        break;
      case TextProps.xl:
        textStyle = TextStyle(
          fontSize: 50,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
        );
        break;
      default:
    }
    return Text(
      widget.text.toString(),
      style: textStyle,
    );
  }
}
