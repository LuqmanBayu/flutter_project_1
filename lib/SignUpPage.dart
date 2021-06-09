import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_1/UserHomepage/Studenthomepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'signup_screen';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool showSpinner = false;
  String email, user, password;
  String role = 'student';

  Widget buildSignUpUserName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: kStyleInputContainer,
        ),
        SizedBox(height: 10),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ]),
            height: 60,
            child: TextField(
              onChanged: (value) {
                user = value;
              },
              style: kStyleDefault,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                    Icons.account_circle,
                    color: Color(0xff1c4966),
                  ),
                  hintText: 'Username',
                  hintStyle: kStyleHint),
            ))
      ],
    );
  }

  Widget buildSignUpEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kStyleInputContainer,
        ),
        SizedBox(height: 10),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ]),
            height: 60,
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
              },
              style: kStyleDefault,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.email_rounded,
                  color: Color(0xff1c4966),
                ),
                hintText: 'Email',
                hintStyle: kStyleHint,
              ),
            ))
      ],
    );
  }

  Widget buildSignUpPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Enter Password',
          style: kStyleInputContainer,
        ),
        SizedBox(height: 10),
        Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ]),
            height: 60,
            child: TextField(
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              style: kStyleDefault,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Color(0xff1c4966),
                ),
                hintText: 'Password',
                hintStyle: kStyleHint,
              ),
            ))
      ],
    );
  }

  Widget buildSignUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                showSpinner = true;
              });

              try {
                final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email, password: password);

                if (newUser != null) {
                  _firestore.collection('users').doc(email).set({
                    'user': user,
                    'email': email,
                    'role': role,
                  });
                  Navigator.pushNamed(context, StudentHomePage.id);
                }
                setState(() {
                  showSpinner = false;
                });
              } catch (e) {
                String e2 = e.toString();
                setState(() {
                  showSpinner = false;
                });
                return ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      // 'Please Insert Valid Login Details',
                      e2,
                      textAlign: TextAlign.center,
                    ),
                    duration: const Duration(milliseconds: 4000),
                    width: 280.0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, // Inner padding for SnackBar content.
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
              }
              setState(() {
                showSpinner = false;
              });
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)))),
            child: Text(
              "Sign Up!",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1c4966),
        title: Text('Sign Up Page'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Color(0x661c4966),
                        Color(0x991c4966),
                        Color(0xcc1c4966),
                        Color(0xff1c4966),
                      ])),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        buildSignUpUserName(),
                        SizedBox(height: 10),
                        buildSignUpEmail(),
                        SizedBox(height: 10),
                        buildSignUpPassword(),
                        SizedBox(height: 10),
                        buildSignUpButton(context),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
