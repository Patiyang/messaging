import 'package:flutter/material.dart';
import 'package:messaging/helperWidgets/styling.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBarMain(context),
      body: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(controller: username, style: formTextStyle(), decoration: textFields('username')),
                TextFormField(controller: email, style: formTextStyle(), decoration: textFields('email')),
                TextFormField(
                    controller: password, style: formTextStyle(), decoration: textFields('password'), obscureText: true),
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
                    child: button('Sign Up', Colors.blueAccent, context, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SignUp()));
                })),
                SizedBox(height: 10),
                Container(child: button('Sign In With Google', Colors.white, context, () {})),
                SizedBox(height: 17),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already have an account? ',
                      style: hint.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => SignUp()));
                      },
                      child: Text(
                        'Sign In',
                        style: hint.copyWith(fontSize: 14, color: Colors.white, decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
