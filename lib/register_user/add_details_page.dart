import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_auth/constants/colors.dart';
import 'package:face_auth/models/user.dart';
import 'package:flutter/material.dart';
import 'package:face_auth/widgets/custom_button.dart';
import 'package:face_auth/widgets/custom_text_form_field.dart';
import 'package:uuid/uuid.dart';

class AddDetailsPage extends StatefulWidget {
  final String image;
  const AddDetailsPage({required this.image, super.key});

  @override
  State<AddDetailsPage> createState() => _AddDetailsPageState();
}

class _AddDetailsPageState extends State<AddDetailsPage> {
  final nameController = TextEditingController();
  final formFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Details")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFormfield(
                formFieldKey: formFieldKey,
                controller: nameController,
                hintText: 'Name',
                validate: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Enter the name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                label: "Register Now",
                onTap: () {
                  if (formFieldKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    final name = nameController.text;

                    final userId = Uuid().v4();

                    final newUser = User(
                      id: userId,
                      name: name,
                      image: widget.image,
                    );

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          Center(child: CircularProgressIndicator()),
                    );

                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .set(newUser.toJson())
                        .then((value) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Registration Success'),
                              backgroundColor: accentColor,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Future.delayed(Duration(seconds: 1), (){
                             Navigator.of(context)
                          ..pop()
                          ..pop()
                          ..pop();
                        });
                          })

                         
                        .catchError((e) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Registration Failed'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
