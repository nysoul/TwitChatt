import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:twitchat/views/tweet.dart';
import 'package:flutter_brand_icons/flutter_brand_icons.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  //Stream to store and build chatroom data
  Stream chatRooms;

  //Creation of chatroom listView:
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
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data["chatRoomId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
                  );
                },
        )
            : Container();
      },
    );
  }

  Signout()
  {
    HelperFunctions.saveUserLoggedInSharedPreference(false);
    AuthService().signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Authenticate(),
    ),
      (Route route) => false,
    );
  }

  //Calling init function to call getUserInfogetChats() function
  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  //Function to obtain user chat using chatroom id
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

  QuerySnapshot allUserNames;

  //For getting list info of all the users in app
  searchUsernames() async {
    await DatabaseMethods().getAllUsers()
        .then((snapshot) {
      allUserNames = snapshot;
    });
  }

  //Layout of the chatroom page
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
      body: Opacity(
        opacity: 0.9,
        child:
        Container(
            child: chatRoomsList(),
          ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: false,
        child: Icon(Icons.message,size: 30,),
        onPressed: () async{
          await searchUsernames();
          Navigator.push(context, MaterialPageRoute(builder: (context) => Search(allUserNames)));
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(left: 5),
          children: <Widget>[
            DrawerHeader(child:RichText(
                             text: TextSpan(
                                            text: 'Welcome',
                                            style: TextStyle(fontSize: 30,fontWeight: FontWeight.w300,color: Colors.black38),
                                            children: <TextSpan>[
                                              TextSpan(text:"            "+ Constants.myName.substring(0,1).toUpperCase()+Constants.myName.substring(1,).toLowerCase(),
                                                  style: TextStyle(fontWeight: FontWeight.w600,fontSize: 38,color: Colors.black54)),
                                              TextSpan(text: "                "+Constants.myEmail,
                                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300))
                                            ],
                                          ),
                                        ),

              decoration: BoxDecoration(
                border: Border.symmetric(),
                color: Colors.blue[600],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal:10),
              subtitle: Text("Search tweets from Twitter"),
              leading: Icon(BrandIcons.twitter,size:30),
              title: Text("Twitter Search",style: TextStyle(fontSize: 20),),
//              trailing: Icon(BrandIcons.twitter,),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => TweetView())
                );
              },
            ),
//            ListTile(
//              title: Text('How To Use'),
//              onTap: () {
////                Navigator.push(context,MaterialPageRoute(
////                  builder: (context) => HowToUse() ;
////                ))
//                Navigator.pop(context);
//              },
//            ),
            ListTile(
              contentPadding: EdgeInsets.only(left:10),
            title: Text("Sign Out",style: TextStyle(fontSize: 18),),
            subtitle: Text("Not "+  Constants.myName.substring(0,1).toUpperCase()+Constants.myName.substring(1,).toLowerCase(),style: TextStyle(fontSize: 13),),
            leading: Icon(Icons.exit_to_app,size: 28,),
            onTap: (){
              _showMyDialog();
                     },
            )
          ],
        ),
      ),
    );
  }

  //Alert Dialog which pops up on pressing the sign out button.
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
                Signout();

              },
            ),
          ],
        );
      },
    );
  }
}



//Building of each chat view on chatroom
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
        )
        );
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
                      fontWeight: FontWeight.w300)
              ),
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
                )
            )
          ],
        ),
      ),
    );
  }
}
