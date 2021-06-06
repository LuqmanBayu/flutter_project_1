import 'package:flutter/material.dart';

const kStyleDefault = TextStyle(color: Colors.black87);

const kStyleText = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

const kStyleInputContainer =
    TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

const kStyleHint = TextStyle(color: Colors.black38);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.blueGrey, width: 5.0),
  ),
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here',
  border: InputBorder.none,
);

const kStyleSendButton = TextStyle(
  color: Colors.blueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
);

const kStyleHomePageButtons = TextStyle(
  color: Color(0xff009bff),
  fontSize: 18,
  fontWeight: FontWeight.bold,
);
