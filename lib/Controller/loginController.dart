import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:groceryuser/Services/database.dart';

class LoginConroller extends GetxController {
  Rx<User> _user = Rx<User>();
  var showLoading = false.obs;
  var loginShowLoading = false.obs;

  User get user => _user.value;

  @override
  void onInit() {
    _user.bindStream(Database().user);
    super.onInit();
  }
}
