import 'package:assessment/core/packages/statusrequest.dart';
import 'package:assessment/data/datasource/auth_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/functions/handle_data.dart';
import '../../core/services/services.dart';

abstract class RegisterController extends GetxController {
  register();
  goToLogin();
}

class RegisterControllerImp extends RegisterController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  AuthData authData = AuthData(Get.find());
  StatusRequest statusRequest = StatusRequest.none;
  Services services = Get.find();
  @override
  void onInit() {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  @override
  register() async {
    FormState? formData = formKey.currentState;
    if (formData!.validate()) {
      statusRequest = StatusRequest.loading;
      update();

      var response = await authData.register(usernameController.text,
          emailController.text, passwordController.text);
      statusRequest = handleData(response);
      update();

      if (statusRequest == StatusRequest.success) {
        if (response['status'] == "success") {
          Get.offAllNamed("/");
        } else {
          Get.defaultDialog(
              title: "Error", content: Text("Email is already registered".tr));
          statusRequest = StatusRequest.error;
        }
      } else {}
    }
  }

  @override
  goToLogin() async {
    Get.offAllNamed("/");
  }


}
