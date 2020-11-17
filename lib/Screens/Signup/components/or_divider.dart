import 'package:flutter/material.dart';
import 'package:groceryuser/constants.dart';

class OrDivider extends StatelessWidget {
  final Color color;
  final String text;
  final double thickness;
  final double fontSize;
  final Color textColor;

  OrDivider({Key key, this.color, this.text, this.thickness, this.fontSize, this.textColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              text ?? "OR",
              style: TextStyle(
                color: textColor?? kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: fontSize??null,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: color ?? Color(0xFFD9D9D9),
        // color: Colors.black,
        height: 1.5,
        thickness: thickness??0.0,
      ),
    );
  }
}
