import 'package:twitchat/screens/signin.dart';
import 'package:twitchat/screens/signup.dart';
import 'package:flutter/material.dart';

class Where extends StatefulWidget {
  @override
  _Where createState() => _Where();
}

class _Where extends State<Where> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView);
    } else {
      return SignUp(toggleView);
    }
  }
}