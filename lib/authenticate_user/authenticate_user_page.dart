// import 'dart:convert'; // <-- ADDED: Needed for base64Encode
// import 'dart:typed_data'; // <-- ADDED: Needed for Uint8List

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:face_auth/authenticate_user/scanning_animation/animated_view.dart';
// import 'package:face_auth/authenticate_user/user_authenticated_page.dart';
// import 'package:face_auth/widgets/capture_face_view.dart';
// import 'package:face_auth/widgets/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:face_auth/constants/colors.dart';
// import 'package:flutter_face_api/flutter_face_api.dart' as regula;

// class AuthenticateUserPage extends StatefulWidget {
//   const AuthenticateUserPage({super.key});

//   @override
//   State<AuthenticateUserPage> createState() => _AuthenticateUserPageState();
// }

// class _AuthenticateUserPageState extends State<AuthenticateUserPage> {
//   var image1 = regula.MatchFacesImage();
//   var image2 = regula.MatchFacesImage();

//   bool canAuthenticate = false;
//   bool faceMatched = false;
//   bool isMatching = false;
//   String similarity = "";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Authenticate User")),
//       body: Container(
//         color: primaryGrey,
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               Expanded(
//                 child: Stack(
//                   children:[
//                     CaptureFaceView(
//                     onImageCaptured: (Uint8List imageBytes) {
//                       setState(() {
//                         image1.bitmap = base64Encode(imageBytes);
//                         image1.imageType = regula.ImageType.PRINTED;
                  
//                         setState(() {
//                           canAuthenticate = true;
//                         });
//                       });
//                     },
//                   ),
//                   if(isMatching)
//                   Align(
//                     alignment: Alignment.topCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 52),
//                       child: AnimatedView(),
//                     ),
//                     ),
//                   ] 
//                 ),
//               ),
//               Spacer(),
//               if (canAuthenticate)
//                 CustomButton(
//                   label: "Authenticate",
//                   onTap: () {
//                     setState(() {
//                       isMatching = true;

//                     });
//                     FirebaseFirestore.instance.collection('users').get().then((
//                       snap,
//                     ) async {
//                       if (snap.docs.isNotEmpty) {
//                         for (var doc in snap.docs) {
//                           final user = User.fromJson(doc.data());

//                           image2.bitmap = user.image;
//                           image2.imageType = regula.ImageType.PRINTED;

//                           var request = regula.MatchFacesRequest();
//                           request.images = [image1, image2];

//                           var value = await regula.FaceSDK.matchFaces(
//                             jsonEncode(request),
//                           );
//                           var response = regula.MatchFacesResponse.fromJson(
//                             json.decode(value),
//                           );
//                           var str =
//                               await regula
//                                   .FaceSDK.matchFacesSimilarityThresholdSplit(
//                                 jsonEncode(response!.results),
//                                 0.75,
//                               );
//                           var split = regula.matchFacesSimilarityThresholdSplit
//                               .fromJson(jsonDecode(str));
//                           similarity = split!.matchedFaces.length > 0
//                               ? (split.matchedFaces[0]!.similarity! * 100)
//                                     .toStringAsFixed(2)
//                               : 'error';
//                               if(similarity != 'error' && double.parse(similarity) > 90.00){
//                                 faceMatched = true;
//                                 Naigator.of(context).push(MaterialPageRoute(builder: (context) =>
//                                 UserAuthenticatedPage(name: user.name),
//                                 ),);
//                                 break;
//                               }
//                         }
//                         setState(() {
//                           isMatching = false;
//                         });
//                         if(!faceMatched){
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text('User Not Found'),
//                               backgroundColor: Colors.red,
//                               behavior: SnackBarBehavior.floating,
//                             ),
//                           );
//                         }
                        
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text('Registration Failed'),
//                               backgroundColor: Colors.red,
//                               behavior: SnackBarBehavior.floating,
//                             ),
//                           );
//                       }
//                     });
//                   },
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_auth/authenticate_user/scanning_animation/animated_view.dart';
import 'package:face_auth/authenticate_user/user_authenticated_page.dart';
import 'package:face_auth/models/user.dart'; // This import now correctly provides the 'User' class
import 'package:face_auth/widgets/capture_face_view.dart';
import 'package:face_auth/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:face_auth/constants/colors.dart';
import 'package:flutter_face_api/flutter_face_api.dart' as regula;

class AuthenticateUserPage extends StatefulWidget {
  const AuthenticateUserPage({super.key});

  @override
  State<AuthenticateUserPage> createState() => _AuthenticateUserPageState();
}

class _AuthenticateUserPageState extends State<AuthenticateUserPage> {
  final faceSdk = regula.FaceSDK.instance;

  regula.MatchFacesImage? _liveFaceImage;

  bool _canAuthenticate = false;
  bool _isMatching = false;

  @override
  void initState() {
    super.initState();
    faceSdk.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Authenticate User")),
      body: Container(
        color: primaryGrey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CaptureFaceView(
                      onImageCaptured: (Uint8List imageBytes) {
                        setState(() {
                          _liveFaceImage = regula.MatchFacesImage(imageBytes, regula.ImageType.PRINTED);
                          _canAuthenticate = true;
                        });
                      },
                    ),
                    if (_isMatching)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 50),
                        child: AnimatedView(),
                      ),
                  ],
                ),
              ),
              if (_canAuthenticate)
                CustomButton(
                  label: "Authenticate",
                  onTap: _onAuthenticate,
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onAuthenticate() async {
    if (_liveFaceImage == null) return;

    setState(() => _isMatching = true);

    bool faceMatched = false;
    User? matchedUser; // <-- FIX: Changed from UserModel to User

    try {
      final snap = await FirebaseFirestore.instance.collection('users').get();
      if (snap.docs.isEmpty) {
        _showErrorSnackBar('No users registered in the database.');
        return;
      }

      for (var doc in snap.docs) {
        // <-- FIX: Changed from UserModel to User
        final registeredUser = User.fromJson(doc.data());
        
        // This assumes your User's image field is a non-nullable 'String'
        if (registeredUser.image.isEmpty) continue;
        
        final registeredFaceImageBytes = base64Decode(registeredUser.image);
        final registeredFaceImage = regula.MatchFacesImage(
          registeredFaceImageBytes,
          regula.ImageType.PRINTED,
        );

        final request = regula.MatchFacesRequest([_liveFaceImage!, registeredFaceImage]);
        final response = await faceSdk.matchFaces(request);
        final split = await faceSdk.splitComparedFaces(response.results, 0.75);

        if (split.matchedFaces.isNotEmpty) {
          final similarity = split.matchedFaces.first.similarity;
          if (similarity != null && similarity > 0.95) {
            faceMatched = true;
            matchedUser = registeredUser;
            break; 
          }
        }
      }

      if (faceMatched && matchedUser != null) {
        _handleSuccess(matchedUser);
      } else {
        _showErrorSnackBar('User Not Found. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    } finally {
      if (mounted) {
        setState(() => _isMatching = false);
      }
    }
  }

  void _handleSuccess(User matchedUser) { // <-- FIX: Changed from UserModel to User
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserAuthenticatedPage(name: matchedUser.name),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}