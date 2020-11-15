import 'package:get/get.dart';
import 'package:groceryuser/Controller/loginController.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginConroller(),permanent: true);

  }



}
