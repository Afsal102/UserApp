import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:groceryuser/components/text_field_container.dart';

class CountryPicker extends StatelessWidget {
  final bool alignleft;
  final ValueChanged<CountryCode> onInit;
  final ValueChanged<CountryCode> onChanged;
  const CountryPicker({
    Key key,
    this.alignleft,
    @required this.onChanged,
    @required this.onInit,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      width: 120,
      child: CountryCodePicker(
        alignLeft: alignleft,
        onInit: onInit,
        initialSelection: 'LK',
        favorite: ['+94', 'LK'],
        onChanged: onChanged,
      ),
    );
  }
}
