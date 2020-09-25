import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.blue[700],
    title: Image.asset(
      "assets/images/logo.png",
      alignment: Alignment.center,
      color: Colors.white,
      height: 150,
      width: 270,
    ),
    elevation: 0.0,
    centerTitle: false,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black26),

      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black45)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black45)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}
