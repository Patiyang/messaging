import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging/helperWidgets/styling.dart';
import 'package:messaging/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String recipent;
  final String chatId;
  final String sender;
  const ChatScreen({Key key, this.recipent, this.chatId, this.sender}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = new TextEditingController();
  Database _database = new Database();
  Stream chatStream;
  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(widget.recipent),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: _firestore.collection('chatRoom').document(widget.chatId).collection('chats').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? Expanded(
                      child: ListView.builder(
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot snap = snapshot.data.documents[index];
                          String message = snap['message'];
                          String sender = snap['sender'];
                          return MessageTiles(message, sender == sender);
                        },
                      ),
                    )
                  : Container();
            },
          ),
          // Spacer(),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey[700],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 2),
                    child: TextField(
                      maxLines: 4,
                      style: TextStyle(color: Colors.white),
                      controller: messageController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                height: 40,
                color: redColor,
                onPressed: () async {
                  await sendMessage();
                  messageController.clear();
                },
                child: Text('Send'),
              )
            ],
          ),
        ],
      ),
    );
  }

  sendMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sender = prefs.getString('userName');
    _database.addConversations(sender, widget.chatId, messageController.text);
  }
}

class MessageTiles extends StatelessWidget {
  final String message;
  final bool isMe;
  const MessageTiles(this.message, this.isMe);
  @override
  Widget build(BuildContext context) {
    return Container(width: MediaQuery.of(context).size.width,
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey,
      ),
      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 12),
      child: Text(message, style: TextStyle(color: Colors.white)),
    );
  }
}
