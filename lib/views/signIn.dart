import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messaging/helperFunctions/helperFunctions.dart';
import 'package:messaging/helperWidgets/styling.dart';
import 'package:messaging/helperWidgets/widget.dart';
import 'package:messaging/services/auth.dart';
import 'package:messaging/views/chatrooms.dart';
import 'package:messaging/views/signUp.dart';

class SignIn extends StatefulWidget {
  final title;

  const SignIn({Key key, this.title}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  AuthMethods _authMethods = new AuthMethods();
  HelperFunctions _helperFunctions = new HelperFunctions();
  bool loading = false;
  bool isLoggedIn = false;
  bool hide = true;
  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    setState(() {
      loading = true;
    });
    await firebaseAuth.currentUser().then((user) {
      if (user != null) {
        setState(() => isLoggedIn = true);
      }
    });
    if (isLoggedIn) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new ChatRooms()));
    }
    setState(() {
      loading = false;
    });
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
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
                      // obscureText: true,
                      style: formTextStyle(),
                      decoration: textFields('email'),
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'this field cannot be left empty';
                        }
                        if (val.length < 6) {
                          return 'the password length must be greather than 6';
                        }

                        return null;
                      },
                      obscureText: true,
                      style: formTextStyle(),
                      decoration: textFields('password'),
                    ),
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
                      signInUser();
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

  signInUser() {
    HelperFunctions.saveEmail(emailController.text);

    if (formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      _authMethods.signIn(emailController.text, passwordController.text).then((value) {
        if (value != null) {
          HelperFunctions.saveUser(true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatRooms()));
        } else {
          Fluttertoast.showToast(msg: 'Wrong Email or Password');
        }
      }).catchError((e) => print(e.toString()));
    }
  }
}
