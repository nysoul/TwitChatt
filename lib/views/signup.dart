import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twitchat/helper/helperfunctions.dart';
import 'package:twitchat/helper/theme.dart';
import 'package:twitchat/services/auth.dart';
import 'package:twitchat/services/database.dart';
import 'package:twitchat/views/chatrooms.dart';
import 'package:twitchat/widget/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  //Function which completes the sign up process by communicating with firebase auth service
  singUp() async {
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });

      await authService.signUpWithEmailAndPassword(emailEditingController.text.trim(),
          passwordEditingController.text.trim()).then((result){
            if(result != null){
              Map<String,String> userDataMap = {
                "userName" : usernameEditingController.text,
                "userEmail" : emailEditingController.text
              };

              databaseMethods.addUserInfo(userDataMap);

              HelperFunctions.saveUserLoggedInSharedPreference(true);
              HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text.trim());
              HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text.trim());

              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatRoom()
              )
              );
            }
      }
      );
    }
  }


  //The sign up UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        color: Colors.white,
        child: Center(child: SpinKitDoubleBounce(
        color: Colors.white70,
        size: 50.0,
        // duration: const Duration(milliseconds: 1000),
      ),),) :
      SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-80,
          alignment: Alignment.center,
          color:Colors.grey[200],
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 100),
                  alignment: Alignment.center,
                  child: Text("Register Your New Account",textAlign: TextAlign.center,style: GoogleFonts.roboto(fontSize: 43,fontWeight: FontWeight.w300,color: Colors.black54),)),
              Spacer(),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.black87, fontSize: 16,),
                      controller: usernameEditingController,
                      validator: (val){
                        return val.isEmpty || val.length < 3 ? "Enter Username 3+ characters" : null;
                      },
                      decoration: textFieldInputDecoration("Username"),
                    ),
                    TextFormField(
                      controller: emailEditingController,
                      style: TextStyle(color: Colors.black87, fontSize: 16,),
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                            null : "Enter correct email";
                      },
                      decoration: textFieldInputDecoration("Email"),
                    ),
                    TextFormField(
                      obscureText: true,
                      style: TextStyle(color: Colors.black87, fontSize: 15,),
                      decoration: textFieldInputDecoration("Password"),
                      controller: passwordEditingController,
                      validator:  (val){
                        return val.length < 6 ? "Enter Password 6+ characters" : null;
                      },

                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 14,
              ),
              GestureDetector(
                onTap: (){
                  singUp();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [const Color(0xff007EF4), const Color(0xff2A75BC)],
                      )),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Sign Up",
                    style: biggerTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 14,
              ),
//            Container(
//              padding: EdgeInsets.symmetric(vertical: 16),
//              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(30), color: Colors.white),
//              width: MediaQuery.of(context).size.width,
//              child: Text(
//                "Sign Up with Google",
//                style: TextStyle(fontSize: 17, color: CustomTheme.textColor),
//                textAlign: TextAlign.center,
//              ),
//            ),
              SizedBox(
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.black38, fontSize: 16,),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggleView();
                    },
                    child: Text(
                      "SignIn now",
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic),
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
