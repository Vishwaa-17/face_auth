import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:face_auth/constants/colors.dart';
import 'package:image_picker/image_picker.dart';
  
class CaptureFaceView extends StatefulWidget {
  final void Function(Uint8List) onImageCaptured;
  const CaptureFaceView({
    required this.onImageCaptured,
    super.key});

  @override
  State<CaptureFaceView> createState() => _CaptureFaceViewState();
}

class _CaptureFaceViewState extends State<CaptureFaceView> {
  late final ImagePicker picker;
  File? _image;
  @override
  void initState() {
    super.initState();

    picker = ImagePicker();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.camera_enhance_outlined, color: primaryWhite, size: 32),
          ],
        ),
        SizedBox(height: 20),
        CircleAvatar(
          radius: 140,
          backgroundColor: const Color(0xffD9D9D9),
          backgroundImage: _image == null ? null : FileImage(_image!),
          child: _image == null
              ? Center(
                  child: Icon(Icons.camera_alt, size: 80, color: primaryGrey),
                )
              : null,
        ),
        GestureDetector(
          onTap: () async {
            setState(() {
              _image = null;
            });
            final pickedImage = await picker.pickImage(
              source: ImageSource.camera,
              maxHeight: 400,
              maxWidth: 400,
            );

            if (pickedImage == null) {
              return;
            }
            final imagePath = pickedImage.path;
            setState(() {
              _image = File(imagePath);
            });

            final ImageBytes = _image!.readAsBytesSync();

            widget.onImageCaptured(ImageBytes as Uint8List);
          },
          child: Container(
            margin: EdgeInsets.only(top: 40),
            height: 60,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                stops: [0.4, 0.65, 1],
                colors: [Color(0xffD9D9D9), primaryWhite, Color(0xffD9D9D9)],
              ),
              shape: BoxShape.circle,
            ),
          ),
        ),

        SizedBox(height: 20),
        Text(
          'Click here to capture',
          style: TextStyle(color: Color.fromARGB(190, 217, 217, 217)),
        ),
      ],
    );
  }
}
