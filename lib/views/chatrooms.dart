import 'package:twitchat/helper/authenticate.dart';
import 'package:twitchat/helper/constants.dart';
import 'package:twitchat/helper/helperfunctions.dart';
import 'package:twitchat/helper/theme.dart';
import 'package:twitchat/services/auth.dart';
import 'package:twitchat/services/database.dart';
import 'package:twitchat/views/chat.dart';
import 'package:twitchat/views/howtouse.dart';
import 'package:twitchat/views/search.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black26,
              thickness: 1,
              height: 1,
            ),
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  print(snapshot.data.documents[index].data["chatRoomId"]
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(Constants.myName, ""));
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data["chatRoomId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
                  );

                },)
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        //backgroundColor: Colors.blue[700],
        toolbarOpacity: 0.8,
        title: Image.asset(
          "assets/images/logo.png",
          alignment: Alignment.center,
          color: Colors.white,
          height: 180,
          width: 280,
        ),
        elevation: 0.0,
        centerTitle: false,
        toolbarHeight: 60,
      ),
      body:


      Opacity(
        opacity: 0.9,
        child: Container(
            child: chatRoomsList(),
          ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.

          children: <Widget>[
            DrawerHeader(

              child: Text("Welcome "+Constants.myName,style:TextStyle(fontSize: 50,color: Colors.black87),),
              decoration: BoxDecoration(
                color: Colors.blue[700],
              ),
            ),
            ListTile(
              leading: Icon(Icons.mail),
              title: Text(Constants.myEmail),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('How To Use App'),
              onTap: () {
//                Navigator.push(context,MaterialPageRoute(
//                  builder: (context) => HowToUse() ;
//                ))
                Navigator.pop(context);
              },
            ),
            ListTile(
            title: Text("Sign Out"),
            onTap: (){
              _showMyDialog();

    },
    )
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to sign out'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                HelperFunctions.saveUserLoggedInSharedPreference(false);
                AuthService().signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));

              },
            ),
          ],
        );
      },
    );
  }

}




class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Chat(
            chatRoomId: chatRoomId,
          )
        ));
      },

      child: Container(
         color: Colors.black12,
       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Container(

              height: 27.5,
              width: 27.5,
              decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(35)),
              child: Text(userName.substring(0,1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 5,
            ),
            Text(userName.substring(0,1).toUpperCase()+userName.substring(1,),
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300,
                ))

          ],
        ),
      ),
    );

  }
}
