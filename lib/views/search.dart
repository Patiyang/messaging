import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging/helperWidgets/styling.dart';
import 'package:messaging/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'conversations.dart';

class SearchUser extends SearchDelegate<String> {
  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => 'Search by UserName';
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      textTheme: TextTheme(headline6: TextStyle(color: Colors.white, fontSize: 17)),
      accentIconTheme: IconThemeData(color: greyColor),
      inputDecorationTheme: InputDecorationTheme(hintStyle: TextStyle(color: Colors.white)),
      primaryColor: greyColor,
      hintColor: Colors.yellow,
      primaryIconTheme: IconThemeData(color: Colors.white),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    String users = 'users';
    String name = 'userName';

    Firestore _firestore = Firestore.instance;
    Database _database = new Database();
    return StreamBuilder(
      stream: _firestore.collection(users).orderBy(name).startAt([query]).endAt([query + '\uf8ff']).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              'no data',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot _snap = snapshot.data.documents[index];
            print(_snap.documentID);
            String recipient = _snap['userName'];
            String email = _snap['email'];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
              child: Material(
                color: greyColor,
                borderRadius: BorderRadius.circular(8),
                child: ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        recipient,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    email,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: MaterialButton(
                    color: redColor,
                    textColor: greyColor,
                    child: Text('Message'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    onPressed: () async {
                      print('the recipient is '+recipient);
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String sender = prefs.getString('userName');
                      String chatId = await getChatId(sender, recipient);
                      await _database.createChatRoom(chatId, [sender, recipient]);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => ChatScreen(recipent: recipient, chatId: chatId, sender: sender)));
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  getChatId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b$a';
    } else {
      return '$a$b';
    }
  }
}
