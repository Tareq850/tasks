import 'package:assessment/view/widget/customtextform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/functions/validate_input.dart';
import '../../controller/auth/profile_controller.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileControllerImp profileControllerImp = Get.put(ProfileControllerImp());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: profileControllerImp.formKey,
            child: GetBuilder<ProfileControllerImp>(
              builder: (ProfileControllerImp profileControllerImp) {
                return Column(
                  children: [
                    CustomTextForm(
                        textController: profileControllerImp.usernameController,
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
                        textController: profileControllerImp.emailController,
                        hint: "example@gmail.com",
                        label: "Email",
                        icon: Icons.email,
                        validator: (String? value) {
                          return inputValidate(value!, "email", 10, 32);
                        },
                        keyboardType: TextInputType.name,
                        isPassword: false,
                        iconButton: false),
                    ElevatedButton(
                      onPressed: () {
                        profileControllerImp.editProfile();
                      },
                      child: const Text("Edit"),
                    ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
