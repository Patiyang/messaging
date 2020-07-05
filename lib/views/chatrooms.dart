import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging/helperWidgets/styling.dart';
import 'package:messaging/services/auth.dart';
import 'package:messaging/services/database.dart';
import 'package:messaging/views/conversations.dart';
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
  String userName = '';
  String recipient;
  Stream conversations;
  Database database = new Database();
  Firestore _firestore = Firestore.instance;
  @override
  void initState() {
    super.initState();
    getUserName();
    database.getChatLists(userName);
  }

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
        body: Container(
          child: StreamBuilder(
            stream: _firestore.collection('chatRoom').where('users', arrayContains: userName).snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot snap = snapshot.data.documents[index];
                        recipient = snap['chatId'].replaceAll(userName,'');
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Material(
                            color: Colors.grey[700],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ChatScreen(
                                              chatId: snap['chatId'],
                                              recipent: recipient,
                                              sender: userName,
                                            )));
                              },
                              leading: CircleAvatar(
                                backgroundColor: redColor,
                                child: Text(
                                  recipient.substring(0, 1).toUpperCase(),
                                  style: TextStyle(color: greyColor),
                                ),
                              ),
                              title: Text(recipient, style: TextStyle(color: Colors.white, letterSpacing: 1, fontSize: 20)),
                            ),
                          ),
                        );
                      },
                    )
                  : Container();
            },
          ),
        ),
      ),
    );
  }

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName');
  }
}
