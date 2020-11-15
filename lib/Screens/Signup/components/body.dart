import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Controller/loginController.dart';
import 'package:groceryuser/Screens/Login/login_screen.dart';
import 'package:groceryuser/Screens/Signup/components/social_icon.dart';
import 'package:groceryuser/Services/database.dart';
import 'package:groceryuser/components/already_have_an_account_acheck.dart';
import 'package:groceryuser/components/country_code_picker.dart';
import 'package:groceryuser/components/rounded_button.dart';
import 'package:groceryuser/components/rounded_input_field.dart';
import 'package:groceryuser/components/rounded_password_field.dart';
import 'package:groceryuser/components/snackbar.dart';
import 'package:logger/logger.dart';

import 'background.dart';
import 'or_divider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController phoneontroller = TextEditingController();

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lasttNameController = TextEditingController();
  final loginController = Get.put(LoginConroller());
  final loggger = Logger();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String countryCode = '+94', countryName = 'SriLanka';

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
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
                              controller: phoneontroller,
                              hintText: "Phone Number",
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                FilteringTextInputFormatter.singleLineFormatter,
                              ],
                              maxLength: 10,
                              onChanged: (value) {
                                _formKey.currentState.validate();
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
                    RoundedInputField(
                      controller: firstNameController,
                      hintText: "First Name",
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                      maxLength: 30,
                      minLines: 1,
                      icon: Icons.person,
                      onChanged: (value) {
                        _formKey.currentState.validate();
                      },
                      validator: (value) {
                        if (value.isEmpty)
                          return "Please Enter Your First Name";
                        if (!value.isAlphabetOnly)
                          return "Your name Contains invalid characters ";
                        if (value.length < 3) return "Invalid Phone Number";
                        return null;
                      },
                    ),
                    RoundedInputField(
                      controller: lasttNameController,
                      hintText: "Last Name",
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                      icon: Icons.person,
                      maxLength: 30,
                      minLines: 1,
                      onChanged: (value) {
                        _formKey.currentState.validate();
                      },
                      validator: (value) {
                        if (value.isEmpty) return "Please Enter Your Last Name";
                        if (!value.isAlphabetOnly)
                          return "Your name Contains invalid characters ";
                        return null;
                      },
                    ),
                    Offstage(
                      offstage: true,
                      child: RoundedPasswordField(
                        onChanged: (value) {},
                      ),
                    ),
                    RoundedButton(
                      text: "SIGNUP",
                      press: () async {
                        if (_formKey.currentState.validate()) {
                          print('validated');
                          String combinedPno =
                              countryCode.trim() + phoneontroller.text.trim();
                          if (await Database()
                              .searchIfUserExists(phoneontroller.text.trim())) {
                            SnackBars().showSnackBar(
                                'Already Registred', LoginScreen());
                          } else {
                            try {
                              await Database().createWithPhoneNumber(
                                combinedPno,
                                firstNameController.text.trim().toLowerCase(),
                                lasttNameController.text.trim().toLowerCase(),
                                phoneontroller.text.trim(),
                                countryCode,
                                countryName,
                                loginController,
                              );
                            } catch (error) {
                              loggger.e(error.toString());
                            }
                          }
                        }
                      },
                    ),
                  ],
                )),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Get.to(LoginScreen());
              },
            ),
            OrDivider(),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: "assets/icons/facebook.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/twitter.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
