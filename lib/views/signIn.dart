import 'package:flutter/material.dart';
import 'package:messaging/helperWidgets/styling.dart';
import 'package:messaging/helperWidgets/widget.dart';
import 'package:messaging/views/chatrooms.dart';
import 'package:messaging/views/signUp.dart';

class SignIn extends StatefulWidget {
  final title;

  const SignIn({Key key, this.title}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(style: formTextStyle(), decoration: textFields('email')),
              TextField(style: formTextStyle(), decoration: textFields('password')),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  child: Text(
                    'Forgot password',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                  child: button('Sign In', Colors.blueAccent, context, () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatRooms()));
              })),
              SizedBox(height: 10),
              Container(child: button('Sign In With Google', Colors.white, context, () {})),
              SizedBox(height: 17),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignUp()));
                      },
                      child: Text(
                        'Register Now',
                        style: hint.copyWith(fontSize: 17, color: Colors.white, decoration: TextDecoration.underline),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
