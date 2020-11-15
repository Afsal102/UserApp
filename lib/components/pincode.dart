import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCode extends StatelessWidget {
  final TextEditingController controller;
  final _formKey = GlobalKey<FormState>();
  final ValueChanged<String> onCompleted;
  PinCode({Key key, this.onCompleted, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                child: PinCodeTextField(
                  appContext: context,
                  controller: controller,
                  length: 6,
                  onChanged: (value) {
                    _formKey.currentState.validate();
                  },
                  obscureText: false,
                  pastedTextStyle: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  obscuringCharacter: '*',
                  autoDismissKeyboard: true,
                  enablePinAutofill: false,
                  autoDisposeControllers: false,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  animationType: AnimationType.fade,
                  validator: (value) {
                    if (value.isEmpty) return 'Code is Empty';
                    if (value.length != 6)
                      return 'Code must contain 6 characters';
                    return null;
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 60,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: Duration(milliseconds: 300),
                  textStyle: TextStyle(fontSize: 20, height: 1.6),
                  backgroundColor: Colors.blue.shade50,
                  enableActiveFill: false,
                  keyboardType: TextInputType.number,
                  boxShadows: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                  onCompleted: onCompleted,
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
            ],
          )),
    );
  }
}
