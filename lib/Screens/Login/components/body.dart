import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/loginController.dart';
import 'package:groceryuser/Screens/Login/components/background.dart';
import 'package:groceryuser/Screens/Signup/signup_screen.dart';
import 'package:groceryuser/Services/database.dart';
import 'package:groceryuser/components/already_have_an_account_acheck.dart';
import 'package:groceryuser/components/country_code_picker.dart';
import 'package:groceryuser/components/loading.dart';
import 'package:groceryuser/components/rounded_button.dart';
import 'package:groceryuser/components/rounded_input_field.dart';
import 'package:groceryuser/components/rounded_password_field.dart';
import 'package:groceryuser/components/snackbar.dart';
import 'package:logger/logger.dart';

class Body extends StatelessWidget {
  final controllerLogin = Get.put(LoginConroller());

  final _phoneController = TextEditingController();
  final loadingcontroller = Get.put(LoginConroller());
  final _formkey = GlobalKey<FormState>();
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context)
        .size; //!rather using this u coud directly call that inside Get.context.size;
    String countryCode = '+94';
    String countryName = 'SriLanka';
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          CountryPicker(
                            onChanged: (value) {
                              countryCode = value.dialCode;
                              countryName = value.name.trim();
                            },
                            alignleft: true,
                            onInit: (value) {
                              countryCode = value.dialCode.toString();
                              countryName = value.name.trim();
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: RoundedInputField(
                              controller: _phoneController,
                              hintText: "Phone Number",
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.singleLineFormatter,
                              ],
                              maxLength: 10,
                              onChanged: (value) {
                                _formkey.currentState.validate();
                              },
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'Please Enter Your Phone Number';
                                if (!value.isNumericOnly)
                                  return 'Phone Number is not valid';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: true,
                      child: RoundedPasswordField(
                        onChanged: (value) {},
                      ),
                    ),
                    RoundedButton(
                        text: "LOGIN",
                        press: () async {
                          try {
                            if (_formkey.currentState.validate()) {
                              String combiedPno = countryCode +
                                  _phoneController.text.toString().trim();
                              if (!await Database().searchIfUserExists(
                                  _phoneController.text.toString().trim())) {
                                SnackBars().showSnackBar(
                                    'Not Registered', SignUpScreen());
                              } else {
                                Database().loginWithPhoneNumber(
                                  combiedPno,
                                  loadingcontroller,
                                  MediaQuery.of(context).size.height / 2 * 0.5,
                                  MediaQuery.of(context).size.width / 2,
                                );
                              }
                            }
                          } on FirebaseAuthException catch (e) {
                            logger.e(e.message.toUpperCase());
                            Get.snackbar('Invalid Code', 'Code is invalid');
                          } catch (e) {
                            logger.e('Some error Occured');
                          }
                        }),
                  ],
                )),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Get.to(SignUpScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
