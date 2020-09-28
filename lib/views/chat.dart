import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:twitchat/helper/constants.dart';
import 'package:twitchat/services/database.dart';
import 'package:twitchat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  Chat({this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController _controller = new ScrollController();

  //widget for building chat screen of users
  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.documents.length,
          controller: _controller,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
              );
            }
            )
            : Container();
      },
    );
  }

  //this function fires up whenever a new message is sent
  addMessage() {
    if (messageEditingController.text.trim().isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text.trim(),
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };
      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  //Automatically obtain all the messages on starting of chatroom
  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    //Scrolling to last of the chat
    Timer(
      Duration(milliseconds:250),
          () => _controller.jumpTo(_controller.position.maxScrollExtent),
    );
    super.initState();
  }

  //For obtaining sender name to be used on chat screen
  getSender(String chatroomid)
  {
    chatroomid=widget.chatRoomId;
    String sender;
    return sender=chatroomid.replaceAll("_","").replaceAll(Constants.myName, "");
  }

  //Building the chat screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarChat(context,getSender(widget.chatRoomId)),
      body: Opacity(
        opacity: 0.9,
        child: Container(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
          color: Colors.transparent,
            image: DecorationImage(
             fit: (BoxFit.cover),
              image: AssetImage(
                'assets/images/cartoon2.jpeg',
              ),
            ),
          ),
        ),
              Container(
                height: MediaQuery.of(context).size.height - 140,
                decoration: BoxDecoration(
                  border: Border(bottom:BorderSide(width: 3,color: Colors.grey)),
//                  borderRadius: BorderRadius.circular(1000),
                    color: Colors.white,
                    gradient: LinearGradient(
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                        colors: [
                          Colors.grey.withOpacity(0),
                          Colors.black,
                                ],
                        stops: [
                          0.99,
                          1.0
                              ]
                    )
                ),
            child: chatMessages()
              ),
              Container(alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 65,
                  padding: EdgeInsets.symmetric(horizontal:4,vertical: 5),
                  color: Colors.transparent,
                  //borderRadius: BorderRadius.circular(40),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                            controller: messageEditingController,
                            style: simpleTextStyle(),
                            decoration:InputDecoration(
                                hintText: "Message ...",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              border:  OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(50.0),
                                ),
                              ),
                              fillColor: Colors.grey.withOpacity(0.5),
                          filled: true,
                             ),
                          )
                          ),
                      SizedBox(width: 16,),
                      GestureDetector(
                        onTap: () {
                          addMessage();
                          Timer(
                            Duration(milliseconds:250),
                                () => _controller.jumpTo(_controller.position.maxScrollExtent),
                          );
                                  },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      const Color(0x36FFFFFF),
                                      const Color(0x0FFFFFFF)
                                    ],
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight
                                ),
                                borderRadius: BorderRadius.circular(40)
                            ),
                            padding: EdgeInsets.all(12),
                            child: Image.asset("assets/images/send.png",
                              height: 25, width: 25,)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


//Adding messages to chat screen
class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25)
            ) :
            BorderRadius.only(
        topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25)),
            gradient: LinearGradient(
              colors: sendByMe ?
              [
                Colors.blue,
                Colors.blue,
              ] :
              [
                Colors.green[700],
                Colors.green[700]
              ]
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300)),
      ),
    );
  }
}

