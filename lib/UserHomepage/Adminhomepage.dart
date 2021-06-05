import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project_1/LoginPage.dart';

class AdminHomePage extends StatefulWidget {
  static const id = 'admin_page';
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;
  String email;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
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

  Widget buildManageCourse() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            onPressed: () => print('Manage Course'),
            elevation: 5,
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Text(
              'Manage course',
              style: TextStyle(
                color: Color(0xff009bff),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]);
  }

  Widget buildSendNotification() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            onPressed: () => print('Send Notification to lecturer'),
            elevation: 5,
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Text(
              'Send notification to lecturer',
              style: TextStyle(
                color: Color(0xff009bff),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]);
  }

  Widget buildSendNotificationStudent() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            onPressed: () => print('Send Notification to student'),
            elevation: 5,
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Text(
              'Send notification to Student',
              style: TextStyle(
                color: Color(0xff009bff),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]);
  }

  Widget buildManageStudent() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            onPressed: () => print('Manage Student'),
            elevation: 5,
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Text(
              'Manage Student',
              style: TextStyle(
                color: Color(0xff009bff),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]);
  }

  Widget buildManageLecturer() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            onPressed: () => print('Pressed manage lecturer'),
            elevation: 5,
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Text(
              'Manage Lecturer',
              style: TextStyle(
                color: Color(0xff009bff),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]);
  }

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
              )),
        ],
        backgroundColor: Color(0xff1c4966),
        title: Text('Weclome Admin'),
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
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Logged in as user : ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700)),
                                    TextSpan(
                                        text: documentFields['user'] + '\n\n',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: 'Select admin features',
                                        style: TextStyle(
                                            color: Colors.yellow[300],
                                            fontSize: 25,
                                            fontWeight: FontWeight.w800)),
                                  ],
                                ),
                              );
                            }
                          }),
                      SizedBox(height: 30),
                      buildManageCourse(),
                      SizedBox(height: 15),
                      buildSendNotification(),
                      SizedBox(height: 15),
                      buildSendNotificationStudent(),
                      SizedBox(height: 15),
                      buildManageLecturer(),
                      SizedBox(height: 15),
                      buildManageStudent(),
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
