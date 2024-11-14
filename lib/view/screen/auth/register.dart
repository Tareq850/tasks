import 'package:assessment/view/widget/customtextform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth/register_controller.dart';
import '../../../core/functions/validate_input.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    RegisterControllerImp controller = Get.put(RegisterControllerImp());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                CustomTextForm(
                    textController: controller.usernameController,
                    hint: "username",
                    label: "Username",
                    icon: Icons.person,
                    validator: (String? value) {
                      return inputValidate(value!, "name", 4, 16);
                    },
                    keyboardType: TextInputType.name,
                    isPassword: false,
                    iconButton: false),
                CustomTextForm(
                    textController: controller.emailController,
                    hint: "example@gmail.com",
                    label: "Email",
                    icon: Icons.email,
                    validator: (String? value) {
                      return inputValidate(value!, "email", 10, 32);
                    },
                    keyboardType: TextInputType.name,
                    isPassword: false,
                    iconButton: false),
                CustomTextForm(
                    textController: controller.passwordController,
                    hint: "password",
                    label: "Password",
                    icon: Icons.email,
                    validator: (String? value) {
                      return inputValidate(value!, "password", 8, 20);
                    },
                    keyboardType: TextInputType.name,
                    isPassword: false,
                    iconButton: false),
                ElevatedButton(
                  onPressed: () {
                    controller.register();
                  },
                  child: const Text("Register"),
                ),
                ElevatedButton(
                  onPressed: () {
                    controller.goToLogin();
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
