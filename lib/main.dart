import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_1/Features/ChatPage.dart';
import 'package:flutter_project_1/Features/StudentProfile.dart';
import 'package:flutter_project_1/UserHomepage/Adminhomepage.dart';
import 'package:flutter_project_1/SignUpPage.dart';
import 'package:flutter_project_1/UserHomepage/Studenthomepage.dart';
import 'LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Manager System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(),
        initialRoute: LoginScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          SignUpPage.id: (context) => SignUpPage(),
          AdminHomePage.id: (context) => AdminHomePage(),
          StudentHomePage.id: (context) => StudentHomePage(),
          ChatPage.id: (context) => ChatPage(),
          StudentProfile.id: (context) => StudentProfile(),
        });
  }
}
