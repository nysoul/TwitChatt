import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//This dart file contains prebuilt functions for ui change can be applied appwide by calling these functions anywhere.

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

Widget appBarChat(BuildContext context,String username) {
  return AppBar(
    backgroundColor: Colors.blue[700],
    titleSpacing: -10,
    title:
    Stack(
      children:[
        Text(username.substring(0,1).toUpperCase()+username.substring(1,),
      style: GoogleFonts.roboto(fontSize: 20,color:Colors.white),
      textAlign: TextAlign.left,),
  ]
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
