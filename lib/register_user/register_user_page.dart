import 'dart:convert';

import 'package:face_auth/register_user/add_details_page.dart';
import 'package:face_auth/widgets/capture_face_view.dart';
import 'package:face_auth/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:face_auth/constants/colors.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  String? imageData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register User")),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: primaryGrey,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CaptureFaceView(
                onImageCaptured: (imageBytes){
                  setState(() {
                    imageData = base64Encode(imageBytes as List<int>);
                  });
                },
              ),
              Spacer(),
              if(imageData != null)
              CustomButton(
                label: "Register Now",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddDetailsPage(image: imageData!,)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
