import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging/helperWidgets/styling.dart';

import 'conversations.dart';

class SearchUser extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(accentIconTheme: IconThemeData(color: greyColor),
      inputDecorationTheme: InputDecorationTheme(hintStyle: TextStyle(color: Colors.black)),
      primaryColor: Colors.grey[400],
      primaryIconTheme: IconThemeData(color: greyColor),
      //  primaryColorBrightness: theme.primaryColorBrightness,
      primaryTextTheme: theme.primaryTextTheme,
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
            String userName = _snap['userName'];
            String email = _snap['email'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
              child: Material(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(8),
                child: ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        userName,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    email,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: MaterialButton(
                    textColor: greyColor,
                    child: Text('Message'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatScreen(recipent: userName)));
                    },
                    color: redColor,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
