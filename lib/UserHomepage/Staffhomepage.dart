import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_1/Features/ChatPage.dart';
import 'package:flutter_project_1/constants.dart';

import 'package:flutter_project_1/LoginPage.dart';

class StaffHomePage extends StatefulWidget {
  @override
  _StaffHomePageState createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
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

  Widget buildChatFeature() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 400,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.shade800,
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ]),
            child: RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, ChatPage.id);
              },
              elevation: 5.0,
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.chat,
                    color: Colors.black,
                    size: 30,
                  ),
                  SizedBox(
                    width: 80,
                  ),
                  Text(
                    'Discussion Room',
                    textAlign: TextAlign.right,
                    style: kStyleHomePageButtons,
                  ),
                ],
              ),
            ),
          ),
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
        title: Text('Weclome Staff'),
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
                                        style: kStyleDefault),
                                    TextSpan(
                                        text: 'Select Staff features',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w800)),
                                  ],
                                ),
                              );
                            }
                          }),
                      SizedBox(height: 30),
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
