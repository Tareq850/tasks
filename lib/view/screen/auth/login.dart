import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth/login_controller.dart';
import '../../../core/functions/validate_input.dart';
import '../../widget/customtextform.dart';


class Login extends StatelessWidget {

  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    LoginControllerImp controllerImp = Get.put(LoginControllerImp());
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: controllerImp.formKey,
            child: Column(
              children: [
                CustomTextForm(
                    textController: controllerImp.emailController,
                    hint: "username or email",
                    label: "Username Or Email",
                    icon: Icons.person,
                    validator: (String? value) {
                      return inputValidate(value!, "name/email", 4, 32);
                    },
                    keyboardType: TextInputType.name,
                    isPassword: false,
                    iconButton: false),
                CustomTextForm(
                    textController: controllerImp.passwordController,
                    hint: "password",
                    label: "Password",
                    icon: Icons.email,
                    validator: (String? value) {
                      return inputValidate(value!, "password", 8, 20);
                    },
                    keyboardType: TextInputType.name,
                    isPassword: true,
                    iconButton: true),
                ElevatedButton(
                  onPressed: () {
                    controllerImp.login();
                  },
                  child: const Text("Login"),
                ),
                ElevatedButton(
                  onPressed: () {
                    controllerImp.googleLogin();
                  },
                  child: const Text("signIn With Google"),
                ),
                ElevatedButton(
                  onPressed: () {
                    controllerImp.goToRegister();
                  },
                  child: const Text("Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
