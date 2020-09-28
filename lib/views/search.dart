import 'package:twitchat/helper/constants.dart';
import 'package:twitchat/models/user.dart';
import 'package:twitchat/services/database.dart';
import 'package:twitchat/views/chat.dart';
import 'package:twitchat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
  final QuerySnapshot allUserNames;
  Search(this.allUserNames);
}

class _SearchState extends State<Search> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool haveUserSearched = false;

  //This function is fired when user click on search button after entering a username on search screen
  initiateSearch() async {
    if(searchEditingController.text.trim().isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByName(searchEditingController.text.trim())
          .then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }




  //Creates a listView Builder for showing search results
  Widget userList(){
    return haveUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchResultSnapshot.documents.length,
        itemBuilder: (context, index){
        return userTile(
          searchResultSnapshot.documents[index].data["userName"],
          searchResultSnapshot.documents[index].data["userEmail"],
        );
        }) :ListView.builder(
        shrinkWrap: true,
        itemCount: widget.allUserNames.documents.length,
        itemBuilder: (context, index){
          return userTile(
            widget.allUserNames.documents[index].data["userName"],
            widget.allUserNames.documents[index].data["userEmail"],
          );
        }) ;
  }


  // Creating a chatroom as soon as user clicks on message button or both the users
  sendMessage(String userName){

      List<String> users = [Constants.myName,userName];
      String chatRoomId = getChatRoomId(Constants.myName,userName);

      Map<String, dynamic> chatRoom = {
        "users": users,
        "chatRoomId" : chatRoomId,
      };

      databaseMethods.addChatRoom(chatRoom, chatRoomId);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Chat(
          chatRoomId: chatRoomId,
        )
      )
      );
  }


  //For creating search result tiles on search page
  Widget userTile(String userName,String userEmail){
    return
      Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [ Colors.lightBlueAccent[200],Colors.lightGreenAccent[100] ],
          )
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Username: "+
                userName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                ),
              ),
              Text(
                "Email: "+ userEmail,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              if(userName != Constants.myName) {
                sendMessage(userName);
              }
                else
                  {
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text("You can't send message to yourself!"),
                          duration: Duration(seconds: 3),
                        ));
                  }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  //Creating chatroom id using both UserNames
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  //The search page main ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      key: _scaffoldKey,
      body: isLoading ? Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.green, Colors.blue])
        ),
        child: Center(
          child: SpinKitThreeBounce(
            color: Colors.white.withOpacity(0.7),
            size: 50.0,
             // duration: const Duration(milliseconds: 1000),
            ),
        ),
      ) :  Opacity(
        opacity: 0.95,
        child: SingleChildScrollView(
          child: Container(
           // height: MediaQuery.of(context).size.height-165,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.green.withOpacity(0.7),Colors.greenAccent.withOpacity(0.6), Colors.blueAccent.withOpacity(0.8),Colors.blue.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.2,0.5,0.8,0.9]),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: Color(0x54FFFFFF),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchEditingController,
                          style: simpleTextStyle(),
                          decoration: InputDecoration(
                            hintText: "search username ...",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            border: InputBorder.none
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          initiateSearch();
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
                            child: Image.asset("assets/images/search_white.png",
                              height: 25, width: 25,)),
                      )
                    ],
                  ),
                ),
               Opacity(
                 opacity: 0.95,
                 child: SingleChildScrollView(
                   child: Container(
                       //alignment: Alignment.topCenter,
                       height: MediaQuery.of(context).size.height-170,
                       decoration: BoxDecoration(
                           gradient: LinearGradient(
                               colors: [Colors.green, Colors.blue]
                           ),
                       ),
                       child: userList()
                   ),
                 ),
               )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


