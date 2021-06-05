import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project_1/Features/ChatPage.dart';
import 'package:flutter_project_1/Features/StudentProfile.dart';
import 'package:flutter_project_1/LoginPage.dart';

class StudentHomePage extends StatefulWidget {
  static const id = 'student_page';
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;
  String email;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final userNow = _auth.currentUser;
      if (userNow != null) {
        loggedInUser = userNow;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget buildChatFeature() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, ChatPage.id);
            },
            elevation: 5,
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Text(
              'Discussion Room',
              style: TextStyle(
                color: Color(0xff009bff),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]);
  }

  Widget buildSeeNotification() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            onPressed: () => print('See Notification'),
            elevation: 5,
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Text(
              'See notification',
              style: TextStyle(
                color: Color(0xff009bff),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]);
  }

  Widget buildStudentProfile() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            onPressed: () => print('Student Profile'),
            elevation: 5,
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Text(
              'Student Profile',
              style: TextStyle(
                color: Color(0xff009bff),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]);
  }

  StudentProfile studentProfile = StudentProfile();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              _auth.signOut();
              Navigator.pushNamed(context, LoginScreen.id);
            },
            child: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
        backgroundColor: Color(0xff1c4966),
        title: Text('Welcome Student'),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
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
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      StreamBuilder<DocumentSnapshot>(
                          stream: _firestore
                              .collection('users')
                              .doc(loggedInUser.email)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            } else {
                              Map<String, dynamic> documentFields =
                                  snapshot.data.data();
                              return RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: 'Logged in as user: ' + ' ',
                                    children: [
                                      TextSpan(
                                        text: documentFields['user'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                      ),
                                      TextSpan(
                                          text: '\n\n' +
                                              'Please Select Student Privileges',
                                          style: TextStyle(fontSize: 24.0))
                                    ],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ));
                            }
                          }),
                      SizedBox(height: 30),
                      CircleAvatar(
                        backgroundColor: Colors.red.shade100,
                        radius: 50.0,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 70, top: 70),
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () {
                              print('pressed');
                              Navigator.pushNamed(context, StudentProfile.id);
                            },
                            child: Icon(
                              Icons.photo_camera,
                              color: Colors.blueAccent,
                              size: 17.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      buildStudentProfile(),
                      SizedBox(height: 15),
                      buildSeeNotification(),
                      SizedBox(height: 15),
                      buildChatFeature(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
