import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tweet_ui/models/api/tweet.dart';
import 'package:twitchat/helper/constants.dart';
import 'package:twitchat/services/database.dart';
import 'package:twitchat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_api/twitter_api.dart';
import 'dart:convert';
import 'package:tweet_ui/tweet_ui.dart';
class TweetView extends StatefulWidget {
  @override
  _TweetViewState createState() => _TweetViewState();
}

class _TweetViewState extends State<TweetView> {

  TextEditingController searchTweet = new TextEditingController();
  //EmbeddedTweetView output ;
  var output;
  bool isUserSearched;
  int count =20;
  String tSearch;
  bool isLoading = false;
  @override
  void initState() {
    isUserSearched =false;
    super.initState();
  }
  
  // Function which makes request to twitter server and obtains json files
  Future twitLogin() async {
    if (searchTweet.text != null){

      setState(() {
        tSearch=searchTweet.text;
        isLoading =true;
     });
        }

    print("hi");
    // Setting placeholder api keys
    String consumerApiKey = "NG8RuSe3tQwXf9I8eUro75TKP";
    String consumerApiSecret = "3Mxzfij4gqQoEQbV75vRPBW9Weck6C4ZAh8jc6nfNslUnEaVCK";
    String accessToken = "1307004239344889857-tP5EgHzRkyOlBqPozKoBGrGD5kXhZa";
    String accessTokenSecret = "E0HM3Auqn2X4HBmTHITbnnWW0hn1D3PeOccjFqe7OeHS3";

    final _twitterOauth = new twitterApi(
        consumerKey: consumerApiKey,
        consumerSecret: consumerApiSecret,
        token: accessToken,
        tokenSecret: accessTokenSecret
    );


      Future twitterRequest = _twitterOauth.getTwitterRequest(
        // Http Method
        "GET",
        // Endpoint you are trying to reach
        "search/tweets.json",
        // The options for the request
        options: {
          "q": "$tSearch",
          "count": "$count",
          "lang": "en",
          "result_type": "mixed",
          "json":"true",
          // "trim_user": "false",
            "tweet_mode": "extended", // Used to prevent truncating tweets
          "enntities":"false",
        });
      var res = await twitterRequest.catchError((e){
       print(e.toString());
      });
      
      var tweets = json.decode(res.body);
      

      setState(() {
        output=tweets;
        isLoading =false;
        isUserSearched=true;

      });
      
      return output;

    }

  Widget tweetList(){

    return isUserSearched ? SingleChildScrollView(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height-165,
            child: ListView.builder (
                shrinkWrap: true,
                itemCount: count,
                itemBuilder: (context,index) {
                  return EmbeddedTweetView.fromTweet(
                      Tweet.fromRawJson(jsonEncode(output['statuses'][index])));
                }
            ),
          ),
        )
    )
        :Container(
      decoration: BoxDecoration(color: Colors.white),
    );
  }

  //The tweet search page UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarMain(context),

      body: isLoading ? Container(
        decoration: BoxDecoration(
            color: Colors.grey[200])
        ,
        child: Center(
          child: SpinKitWave(
            color: Colors.blueAccent[200].withOpacity(0.8),
            size: 50.0,
            // duration: const Duration(milliseconds: 1000),
          ),
        ),
      ) :Opacity(
        opacity: 0.95,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey[700],
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: Color(0x54FFFFFF),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchTweet,
                          style: simpleTextStyle(),
                          decoration: InputDecoration(
                              hintText: "search for tweets ...",
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

                        twitLogin();
//                        sleep();
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
                  child: Container(

                    child: SingleChildScrollView(
                      child: tweetList(),
                            ),
                  ),
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


