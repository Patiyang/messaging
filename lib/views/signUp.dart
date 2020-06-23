import 'package:flutter/material.dart';
import 'package:messaging/helperWidgets/styling.dart';
import 'package:messaging/helperWidgets/widget.dart';
import 'package:messaging/services/auth.dart';
import 'package:messaging/views/chatrooms.dart';
import 'package:messaging/views/conversations.dart';
import 'package:messaging/views/signIn.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthMethods _authMethods = AuthMethods();
  bool loading = false;
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBarMain(context),
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return "UserName cannot be empty";
                        }
                        if (val.length < 4) {
                          return 'the userName length must be greater than 4';
                        }
                        return null;
                      },
                      controller: username,
                      style: formTextStyle(),
                      decoration: textFields('username'),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Email Cannot be empty';
                        }
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(val))
                          return 'Please make sure your email address is valid';
                        else
                          return null;
                      },
                      controller: email,
                      style: formTextStyle(),
                      decoration: textFields('email'),
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'this field cannot be left empty';
                        }
                        if (val.length < 6) {
                          return 'the password length must be greather than 6';
                        }

                        return null;
                      },
                      controller: password,
                      style: formTextStyle(),
                      decoration: textFields('password'),
                      obscureText: true,
                    ),
                    TextFormField(
                        validator: (val) {
                          if (password.text != val || val.isEmpty) {
                            return 'the passwords do not match';
                          }
                          return null;
                        },
                        controller: confirmPassword,
                        style: formTextStyle(),
                        decoration: textFields('Confirm Password'),
                        obscureText: true),
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
                      signUpUser();
                      // whenComplete(() {
                      //   Navigator.push(context, MaterialPageRoute(builder: (_) => SignUp()));
                      // });
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
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignIn()));
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
          Visibility(
            visible: loading == true,
            child: Container(
              color: Colors.white.withOpacity(.7),
              child: Loading(),
            ),
          ),
        ],
      ),
    );
  }

  signUpUser() {
    setState(() {
      loading = true;
    });
    if (formKey.currentState.validate()) {
      _authMethods.signUp(email.text, password.text).then((val) {
        print(val);
        Navigator.push(context, MaterialPageRoute(builder: (_) => ChatRooms()));
      });
      setState(() {
        formKey.currentState.reset();
        loading = false;
      });
    }
  }
}
