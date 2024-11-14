import 'package:assessment/core/packages/statusrequest.dart';
import 'package:assessment/data/datasource/auth_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/functions/handle_data.dart';
import '../core/packages/biometric.dart';
import '../core/packages/encryption.dart';
import '../core/services/services.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;

abstract class HomeController extends GetxController {
  editProfile();
  // decryptData(String encryptedData);
}

class HomeControllerImp extends HomeController {
  Encryption encryption = Encryption();
  BiometricAuthService biometricAuth = BiometricAuthService();
  Services services = Get.find();
  StatusRequest statusRequest = StatusRequest.none;
  AuthData authData = AuthData(Get.find());
  @override
  editProfile() async {
    bool isAuthenticated = await biometricAuth.authenticate();
    if (!isAuthenticated) {
      bool isPasswordValid = await _showPasswordDialog();
      if (!isPasswordValid) {
        throw Exception("User not authenticated");
      }
    }
    Get.toNamed("/profile");
  }

  // @override
  // Future<String> decryptData(String encryptedData) async {
  //   String? encryptionIv = await services.storage.read(key: "encryption_iv");
  //   final iv = encrypt.IV.fromBase64(encryptionIv!);
  //   // إذا تم التحقق بنجاح، أكمل فك التشفير
  //   final keyString = await services.storage.read(key: "encryption_key");
  //   if (keyString == null) {
  //     throw Exception("Encryption key not found");
  //   }
  //   final encrypter =
  //       encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(keyString)));
  //   final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
  //   return decrypted;
  // }

  Future<bool> _showPasswordDialog() async {
    TextEditingController passwordController = TextEditingController();
    bool isValid = false;
    await Get.defaultDialog(
      title: "أدخل كلمة المرور",
      content: Column(
        children: [
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "كلمة المرور",
            ),
          ),
        ],
      ),
      textConfirm: "confirm",
      onConfirm: () async {
        statusRequest = StatusRequest.loading;
        update();
        String? email = await services.storage.read(key: "email");
        String decryptEmail = await encryption.decryptData(email!);
        var response =
            await authData.login(decryptEmail, passwordController.text);
        statusRequest = handleData(response);
        update();
        if (statusRequest == StatusRequest.success &&
            response['status'] == 'success') {
          print(response['data']['users_password']);
          isValid = true;
          Get.back();
        } else {
          Get.snackbar("Error", "Password error");
        }
      },
      textCancel: "exit",
      onCancel: () {
        Get.back();
      },
    );
    return isValid;
  }
}
