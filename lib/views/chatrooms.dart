import 'package:flutter/material.dart';
import 'package:messaging/services/auth.dart';
import 'package:messaging/views/search.dart';
import 'package:messaging/views/signIn.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatRooms> {
  AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SearchUser(),
                  );
                }),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _authMethods.signOut().then((_) => Navigator.push(context, MaterialPageRoute(builder: (_) => SignIn())));
              },
            )
          ],
        ),
      ),
    );
  }
}
