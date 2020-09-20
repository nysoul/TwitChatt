import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitchat/services/database.dart';
import 'package:twitchat/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot searchSnapshot;

  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
        print(searchSnapshot.toString());
      });
    });
  }
  createChatroomAndStartMessaging(String userName){
    List<String>users =[userName,];

  }

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
       itemCount:searchSnapshot.documents.length,
           shrinkWrap: true,
           itemBuilder: (context,index){
         return SearchTile(
           userName: searchSnapshot.documents[index].data["name"],
           userEmail: searchSnapshot.documents[index].data["email"],
         );
   }):Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child:Column(
          children: [
            Container(
              color: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal:24,vertical: 16),
              child: Row(
                children: [
                  Expanded(
                  child:TextField(
                    controller: searchTextEditingController,
                    style:TextStyle(
                  color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "username",
                        hintStyle:TextStyle(
                  color: Colors.white54
              )),
                  )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                      },
                    child: Container(
                        height:40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF)
                            ]
                          ),
                              borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(10),
                        child: Image.asset("assets/images/search_white.png",height: 25,width: 25)),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  SearchTile({this.userName,this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
      child:Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName,style: simpleTextStyle(),),
              Text(userEmail,style: simpleTextStyle(),)
            ],
          ),
          Spacer(),

          GestureDetector(
            onTap: (){

            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              child: Text("Send Message",style: simpleTextStyle(),),
            ),
          )
        ],
      )
    );
  }
}


