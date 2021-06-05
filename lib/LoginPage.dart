import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_1/UserHomepage/Staffhomepage.dart';
import 'package:flutter_project_1/UserHomepage/Studenthomepage.dart';
import 'package:page_transition/page_transition.dart';
import 'SignUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UserHomepage/Adminhomepage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool showSpinner = false;
  String email;
  String password;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getUser() async {
    try {
      final data = await _firestore.collection('users').doc(email).get();
      if (data['role'] == 'admin') {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                child: AdminHomePage()));
      } else if (data['role'] == 'staff') {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                child: StaffHomePage()));
      } else {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight,
                child: StudentHomePage()));
      }
      print(data['role']);
    } catch (e) {
      print(e);
    }
  }

  Widget buildLoginEmail() {
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
            child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                  if (value == null || value.isEmpty) {
                    return SnackBar(content: Text('Please enter email'));
                  }
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
                ))),
      ],
    );
  }

  Widget buildLoginPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
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
            child: TextFormField(
                onChanged: (value) {
                  password = value;
                  if (value == null || value.isEmpty) {
                    return SnackBar(content: Text('Please insert a password'));
                  }
                },
                keyboardType: TextInputType.text,
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
                )))
      ],
    );
  }

  Widget buildForgotPasswordButton() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: FlatButton(
        onPressed: () => print("Reset Password pressed"),
        padding: EdgeInsets.only(right: 0),
        child: Text(
          'Reset Password',
          style: kStyleText,
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                showSpinner = true;
              });
              try {
                final newUser = await _auth.signInWithEmailAndPassword(
                    email: email, password: password);

                if (newUser != null) {
                  getUser();
                }
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
                        borderRadius: BorderRadius.circular(20.0)))),
            child: Text(
              'Login',
              style: TextStyle(
                color: Color(0xff009bff),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }

  Widget buildSignUpButton(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.bottomToTop, child: SignUpPage()));
        },
        child: Text(
          'Sign Up Here!',
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1c4966),
        title: Text('Welcome to Manager System'),
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
                          'Sign In',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 30),
                        buildLoginEmail(),
                        SizedBox(height: 15),
                        buildLoginPassword(),
                        buildForgotPasswordButton(),
                        buildLoginButton(),
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
