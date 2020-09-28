import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twitchat/helper/helperfunctions.dart';
import 'package:twitchat/helper/theme.dart';
import 'package:twitchat/services/auth.dart';
import 'package:twitchat/services/database.dart';
import 'package:twitchat/views/chatrooms.dart';
import 'package:twitchat/views/forgot_password.dart';
import 'package:twitchat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthService authService = new AuthService();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  //Function for connecting with firebase auth and validating sign in process
  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInWithEmailAndPassword(
              emailEditingController.text.trim(), passwordEditingController.text.trim())
          .then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot =
              await DatabaseMethods().getUserInfo(emailEditingController.text.trim());

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["userEmail"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  //Sign in UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              color: Colors.white,
              child: Center(child: SpinKitDoubleBounce(
                color: Colors.white70,
                size: 50.0,
                // duration: const Duration(milliseconds: 1000),
              ),),
            )
          : SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height-80,
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 100),
                          alignment: Alignment.center,
                          child: Text("Welcome To TwitChat",textAlign: TextAlign.center,style: GoogleFonts.roboto(fontSize: 45,fontWeight: FontWeight.w300,color: Colors.black54),)),
                      Spacer(), 
                          Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)
                                      ? null
                                      : "Please Enter Correct Email";
                                },
                                controller: emailEditingController,
                                style: TextStyle(color: Colors.black87, fontSize: 16,),
                                decoration:textFieldInputDecoration("Email"),
                              ),
                              TextFormField(
                                obscureText: true,
                                validator: (val) {
                                  return val.length > 5
                                      ? null
                                      : "Enter Password 6+ characters";
                                },
                                  style: TextStyle(color: Colors.black87, fontSize: 15)
                                ,
                                controller: passwordEditingController,
                                decoration: textFieldInputDecoration("Password"),
                              ),
                            ],
                          ),
                        ),
                      
                      SizedBox(
                        height: 16,
                      ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.end,
//                    children: [
//                      GestureDetector(
//                        onTap: () {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => ForgotPassword()));
//                        },
//                        child: Container(
//                            padding: EdgeInsets.symmetric(
//                                horizontal: 16, vertical: 8),
//                            child: Text(
//                              "Forgot Password?",
//                              style: simpleTextStyle(),
//                            )),
//                      )
//                    ],
//                  ),
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
//                  GestureDetector(
//                    onTap: (){
//                      twitLogin();
//                    },
//                    child: Container(
//                      padding: EdgeInsets.symmetric(vertical: 16),
//                      decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(30),
//                          color: Colors.white),
//                      width: MediaQuery.of(context).size.width,
//                      child: Text(
//                        "Sign In with Google",
//                        style:
//                            TextStyle(fontSize: 17, color: CustomTheme.textColor),
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
//                  ),
//                  SizedBox(
//                    height: 16,
//                  ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.black38,fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggleView();
                            },
                            child: Text(
                              "Register now",
                              style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 17,
                                  decoration:(TextDecoration.underline),
                                  fontStyle: FontStyle.italic,
                                  ),
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
          ),

          );
        }
      }
