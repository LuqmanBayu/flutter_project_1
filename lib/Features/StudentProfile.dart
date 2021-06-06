import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StudentProfile extends StatefulWidget {
  static const id = 'student_profile.id';
  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  File _image;
  final picker = ImagePicker();

  Future<void> getImage(ImageSource source) async {
    final selected = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (selected != null) {
        _image = File(selected.path);
      } else {
        print('No image selected.');
      }
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
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage(ImageSource.gallery);
        },
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
