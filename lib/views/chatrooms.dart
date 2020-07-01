import 'package:flutter/material.dart';
import 'package:messaging/services/auth.dart';
import 'package:messaging/views/search.dart';
import 'package:messaging/views/signIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatRooms> {
  AuthMethods _authMethods = AuthMethods();
  String email = '';
  String userName = 'dcdcdc';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          // backgroundColor: Colors.grey[400],
          leading: Image.asset('images/lg.png', height: 50),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  showSearch(
                    context: context,
                    delegate: SearchUser(),
                  );
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  userName = prefs.getString('userName');
                  print(userName);
                }),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('email', '');
                _authMethods
                    .signOut()
                    .then((_) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignIn())));
              },
            )
          ],
        ),
      ),
    );
  }
}
