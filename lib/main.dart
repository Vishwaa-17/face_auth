import 'package:face_auth/authenticate_user/authenticate_user_page.dart';
import 'package:face_auth/constants/colors.dart';
import 'package:face_auth/register_user/enter_password_page.dart';
import 'package:face_auth/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: scaffoldClr,
        appBarTheme: AppBarTheme(
          backgroundColor: appBarColor,
          foregroundColor: primaryWhite,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldClr,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Face Aunthentication',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  fontSize: 28,
                ),
              ),
              SizedBox(height: 40),
              CustomButton(
                label: 'Register User',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EnterPasswordPage(),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              CustomButton(
                label: 'Authenticate User',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AuthenticateUserPage(),
                    ),
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
