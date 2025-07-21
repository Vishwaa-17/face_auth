import 'package:flutter/material.dart';
import 'package:face_auth/constants/colors.dart';

class CustomTextFormfield extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validate;
  final GlobalKey? formFieldKey;

  const CustomTextFormfield({
    required this.hintText,
    this.formFieldKey,
    this.controller,
    this.validate,
    super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: formFieldKey,
      controller: controller,
      cursorColor: primaryBlack,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 145, 141, 141),
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: primaryWhite,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: validate,
    );
  }
}
