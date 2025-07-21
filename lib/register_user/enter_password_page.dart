import 'package:face_auth/widgets/custom_button.dart';
import 'package:face_auth/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:face_auth/register_user/register_user_page.dart';

class EnterPasswordPage extends StatelessWidget {
  EnterPasswordPage({super.key});

  final TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Password")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFormfield(
                controller: passwordCtrl,
                hintText: 'Password',
              ),
              SizedBox(height: 20),
              CustomButton(
                label: "Continue",
                onTap: () {
                  if (passwordCtrl.text.isNotEmpty) {
                    if (passwordCtrl.text == '12345') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RegisterUserPage(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Incorrect password'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
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

// import 'package:face_auth/widgets/custom_button.dart';
// import 'package:face_auth/widgets/custom_text_form_field.dart';
// import 'package:flutter/material.dart';
// import 'package:face_auth/register_user/register_user_page.dart';

// // 1. ADD THIS IMPORT FOR FIREBASE
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EnterPasswordPage extends StatelessWidget {
//   EnterPasswordPage({super.key});

//   final TextEditingController passwordCtrl = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Enter Password")),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CustomTextFormfield(
//                 controller: passwordCtrl,
//                 hintText: 'Password',
//               ),
//               const SizedBox(height: 20),
//               CustomButton(
//                 label: "Continue",
//                 // 2. MAKE THE ONTAP FUNCTION ASYNCHRONOUS
//                 onTap: () async {
//                   if (passwordCtrl.text.isNotEmpty) {
//                     // --- This is the new Firebase logic ---
//                     try {
//                       // Get the specific password document from Firestore
//                       final snapshot = await FirebaseFirestore.instance
//                           .collection("password")
//                           .doc("PG0eZfMW5FfkOy5JCXuS") // Using the ID from your sample
//                           .get();

//                       // Get the data from the document
//                       final data = snapshot.data();

//                       // Check if the password from Firestore matches the user's input
//                       if (data?['password'] == passwordCtrl.text.trim()) {
//                         // If it matches, navigate to the next page
//                         // (Using a safety check for the BuildContext)
//                         if (context.mounted) {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) => RegisterUserPage(),
//                             ),
//                           );
//                         }
//                       } else {
//                         // If it doesn't match, show the "Incorrect password" snackbar
//                         if (context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: const Text('Incorrect password'),
//                               backgroundColor: Theme.of(context).colorScheme.error,
//                               behavior: SnackBarBehavior.floating,
//                             ),
//                           );
//                         }
//                       }
//                     } catch (e) {
//                       // If there's an error fetching from Firebase, show a generic error
//                       if (context.mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: const Text('Error checking password. Please try again.'),
//                               backgroundColor: Theme.of(context).colorScheme.error,
//                               behavior: SnackBarBehavior.floating,
//                             ),
//                           );
//                         }
//                     }
//                     // --- End of the new Firebase logic ---

//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }