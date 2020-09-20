import 'package:flutter/material.dart';
import 'package:twitchat/services/auth.dart';
import 'package:twitchat/navigation/where.dart';
import 'package:twitchat/screens/search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Image.asset("assets/images/send.png"),
        actions: [
          GestureDetector(
          onTap: (){

          },
          child:Container(
              padding:EdgeInsets.symmetric(horizontal: 16),
              child:Icon(Icons.exit_to_app)),
    )
        ],
      ),
        floatingActionButton: FloatingActionButton(
        child:Icon(Icons.search),
    onPressed: (){
    Navigator.push(context, MaterialPageRoute(
    builder: (context) => SearchScreen()));
  },
    )
  );
  }
}
