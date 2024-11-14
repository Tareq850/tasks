import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextForm extends StatelessWidget {
  final void Function()? onPressedIcon;
  final bool isPassword;
  final bool iconButton;
  final TextInputType keyboardType;
  final IconData icon;
  final String hint;
  final String label;
  final TextEditingController textController;
  final String? Function(String?)? validator;

  const CustomTextForm({
    super.key,
    required this.textController,
    required this.hint,
    required this.label,
    required this.icon,
    required this.validator,
    required this.keyboardType,
    required this.isPassword,
    this.onPressedIcon,
    required this.iconButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Get.width / 20.55),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 30,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: TextFormField(
        controller: textController,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: Get.width / 15, vertical: Get.width / 26),
          suffixIcon: iconButton
              ? IconButton(
            onPressed: onPressedIcon,
            icon: Icon(icon, color: Colors.grey.shade600),
          )
              : Icon(icon, color: Colors.grey.shade600),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
