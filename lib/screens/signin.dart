import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitchat/services/database.dart';
import 'package:twitchat/widgets/widget.dart';
import 'package:twitchat/services/auth.dart';
import 'package:twitchat/screens/chatroom.dart';
import 'package:twitchat/navigation/helper.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  //Text Editing Controllers
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  

  signIn() async{
    if(formKey.currentState.validate()){
      
      HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);

      setState(() {
        isLoading =true;
      });
      
      databaseMethods.getUserByEmail(emailEditingController.text).then((val){
        snapshotUserInfo = val;
        HelperFunctions.saveUserEmailSharedPreference(snapshotUserInfo.documents[0].data["name"]);
      }
      );
      await authService.signInWithEmailAndPassword(emailEditingController.text.trim(),
          passwordEditingController.text.trim()).then((result) {
        if (result != null) {
         Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        }
    });
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
        body: isLoading
            ? Container(
          child: Center(child: CircularProgressIndicator()),
        ):Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Spacer(),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Enter correct email";
                    },
                    controller: emailEditingController,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration("Mail"),
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (val) {
                      return val.length > 6
                          ? null
                          : "Enter Password 6+ characters";
                    },
                    style: simpleTextStyle(),
                    controller: passwordEditingController,
                    decoration: textFieldInputDecoration("Password"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: (){
//                    Navigator.push(context,
//                        MaterialPageRoute(
//                        builder: (context)=>ForgetPassword()));
                  },
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Text(
                      "Forgot Your Password?",
                      style: simpleTextStyle(),
                    )),
                    )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                signIn();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff007EF4),
                        const Color(0xff2A75BC)
                      ],
                    )),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Sign In",
                  style: biggerTextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Sign In with Twitter",
                style:
                TextStyle(fontSize: 17, color: CustomTheme.textColor),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "New To App? ",
                  style: simpleTextStyle(),
                ),
                GestureDetector(
                  onTap: (){
                    widget.toggleView();
                  },
                child: Text(
                  "Register now",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline),
                ),
                ),
            ],
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}