import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_1/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class StudentProfile extends StatefulWidget {
  static const id = 'student_profile.id';
  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final picker = ImagePicker();
  String imagePath;
  File _image;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadImageToFirebase() async {
    String fileName = basename(_image.path);

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((imagePath) {
      print('Done :' + ' ' + '$imagePath');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1c4966),
        title: Text('Choose profile picture'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image == null
              ? Text('No image selected.')
              : Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(width: 4.0),
                  ),
                  child: CircleAvatar(child: Image.file(_image)),
                ),
          SizedBox(
            height: 15,
          ),
          RaisedButton(
              child: Text('Upload Image'),
              onPressed: () async {
                await uploadImageToFirebase();
              })
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await pickImage(ImageSource.gallery);
        },
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
