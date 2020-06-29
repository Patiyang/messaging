import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging/helperWidgets/styling.dart';

import 'conversations.dart';

class SearchUser extends SearchDelegate<String> {

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
      stream: _firestore.collection(users).where(name, isEqualTo: query).snapshots(),
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
                color: Colors.indigo[300],
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
                    textColor: Colors.white,
                    child: Text('Message'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatScreen(recipent: query,)));
                    },
                    color: greyColor,
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
