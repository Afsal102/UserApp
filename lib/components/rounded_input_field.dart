import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceryuser/components/text_field_container.dart';
import 'package:groceryuser/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int minLines;
  final List<TextInputFormatter> inputFormatters;

  final FormFieldValidator<String> validator;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.maxLength,
    this.icon = Icons.phone,
    this.inputFormatters,
    this.keyboardType,
    this.minLines,
    this.validator,
    @required this.controller,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        maxLength: maxLength ?? null,
        keyboardType: keyboardType??null,
        validator: validator,
        minLines: minLines??null,
        inputFormatters: inputFormatters??null,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
