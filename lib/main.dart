import 'package:flutter/material.dart';
import 'package:twitchat/navigation/where.dart';
import 'package:twitchat/screens/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitchat',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1F1F1F),
       ),
      home: Where(),
    );
  }
}




