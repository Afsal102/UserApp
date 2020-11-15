import 'package:flutter/material.dart';

class TextView extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double fontSize;
  final double letterSpacing;

  const TextView(
      {Key key,
      @required this.text,
      this.color,
      this.fontWeight,
      this.letterSpacing,
      this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: fontWeight ?? null,
          letterSpacing: letterSpacing ?? 0,
          fontSize: fontSize ?? 13),
    );
  }
}
