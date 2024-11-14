import 'package:assessment/core/packages/statusrequest.dart';
import 'package:assessment/data/datasource/auth_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/functions/handle_data.dart';
import '../../core/packages/encryption.dart';
import '../../core/services/services.dart';

abstract class ProfileController extends GetxController {
  editProfile();
}

class ProfileControllerImp extends ProfileController {
  Encryption encryption = Encryption();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController emailController;
  AuthData authData = AuthData(Get.find());
  StatusRequest statusRequest = StatusRequest.none;
  Services services = Get.find();
  @override
  Future<void> onInit() async {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    initData();
    super.onInit();
  }

  Future<void> initData() async {
    String? username = await services.storage.read(key: "name");
    String? email = await services.storage.read(key: "email");

    String decryptUsername = await encryption.decryptData(username!);
    String decryptEmail = await encryption.decryptData(email!);

    usernameController = TextEditingController(text: decryptUsername);
    emailController = TextEditingController(text: decryptEmail);
    update();
  }

  @override
  editProfile() async {
    String? id = await services.storage.read(key: "id");
    String decryptUsername = await encryption.decryptData(id!);

    String? token = await services.storage.read(key: "token");
    String decryptToken = await encryption.decryptData(token!);

    FormState? formData = formKey.currentState;
    if (formData!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      print(decryptToken);
      var response = await authData.editProfile(decryptUsername, usernameController.text,
          emailController.text, decryptToken);
      statusRequest = handleData(response);
      update();

      if (statusRequest == StatusRequest.success) {
        if (response['status'] == "success") {
          Get.offAllNamed("home");
        } else {
          Get.defaultDialog(
              title: "Error", content: Text("Email is already registered"));
          statusRequest = StatusRequest.error;
        }
      } else {}
    }
  }
}
